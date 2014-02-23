#!/usr/bin/ruby

require 'phashion'
require 'RMagick'
require 'open-uri'
require 'nokogiri'
require "open-uri"

@userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko)"
@proxy = nil
@threadsCount = 10
@timeout = 3
@proxiesQueue = Queue.new
@mutex = Mutex.new

def initProxies
	@proxiesQueue << nil
	File.open('proxies.txt').each do |line|
		proxy = "http://#{line.strip}"
  		@proxiesQueue << proxy
	end
	changeProxy
end

def changeProxy(activeProxy = nil)
	@mutex.synchronize do
		return if activeProxy != @proxy
		@proxy = @proxiesQueue.pop(true) rescue nil
		p "Use proxy: #{@proxy}"
	end
end

def openLink(link)
	activeProxy = @proxy

	begin
		result = open(link, 'User-Agent' => @userAgent, :proxy => activeProxy, :read_timeout => @timeout)
		@mutex.synchronize do
			@proxyUsed = true
		end
		return result	
	rescue Exception => e
		changeProxy(activeProxy)
		openLink(link)
	end
end

def processApp(appLink)
	appName = appLink.scan(/.*app\/(.*)\?mt/).first[0]
	appName = appName.gsub("/","_")
	p "appName: #{appName}"

	doc = Nokogiri::HTML(openLink(appLink).read)
	doc.css('div.lockup.product.application div.artwork img.artwork').each do |link|		
		curDir = Dir.pwd
		pathToFile = "#{curDir}/icons/#{appName}.jpg"

		p "Save #{link['src']} as #{pathToFile}"

		File.open(pathToFile, 'wb') do |fo|
			fo.write openLink(link['src']).read
		end
	end
end

def processGenre(genreLink)
	doc = Nokogiri::HTML(openLink(genreLink).read)
	links = doc.css('div#selectedcontent a')

	queue = Queue.new
	links.each{|e| queue << e}

	threads = []
	@threadsCount.times do
	    threads << Thread.new do
	    	while (link = queue.pop(true) rescue nil)
				p "Process app: #{link.text}"
				processApp(link['href'])
	      	end
	    end
	end

	threads.each {|t| t.join }
end

def processApps()
	doc = Nokogiri::HTML(openLink('https://itunes.apple.com/ru/genre/ios/id36?mt=8').read)
	doc.css('a.top-level-genre').each do |link|	
		p "Process category: #{link.text}"
		processGenre(link['href'])
	end
end

begin
	initProxies
 	processApps
rescue SystemExit, Interrupt
	p "SystemExit"
rescue Exception => e
	p "Exception: #{e.to_s}"
end

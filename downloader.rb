#!/usr/bin/ruby

require 'phashion'
require 'RMagick'
require 'open-uri'
require 'nokogiri'
require "open-uri"

@userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko)"
@proxy = nil
@threadsCount = 10
@proxyies = [
	nil,
	"http://93.91.233.50:8080",
	"http://61.19.42.244:8080",
	"http://190.41.58.77:8080",
	"http://173.201.95.24:80",
	"http://:61.19.42.244:80",
	"http://85.185.45.227:80",
	"http://119.233.255.24:81",
	"http://110.208.26.123:9000",
	"http://122.70.137.12:808",
	"http://190.0.17.202:8080"
]
@proxiesQueue = Queue.new
@mutex = Mutex.new

def initProxies
	@proxyies.each{|e| @proxiesQueue << e}
	changeProxy
end

def changeProxy(activeProxy = nil)
	@mutex.synchronize do
		return if activeProxy != @proxy
		@proxy = queue.pop(true) rescue nil
		p "Use proxy: #{@proxy}"
	end
end

def openLink(link)
	activeProxy = @proxy

	begin
		result = open(link, 'User-Agent' => @userAgent, :proxy => activeProxy)
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
	p e.to_s
end

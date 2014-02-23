#!/usr/bin/ruby

require 'phashion'
require 'RMagick'
require 'open-uri'
require 'nokogiri'
require "open-uri"

@userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko)"
@proxy = URI.parse("http://93.91.233.50:8080")
@threadsCount = 10

def processApp(appLink)
	appName = appLink.scan(/.*app\/(.*)\?mt/).first[0]
	appName = appName.gsub("/","_")
	p "appName: #{appName}"

	begin
		doc = Nokogiri::HTML(open(appLink, 'User-Agent' => @userAgent, :proxy => @proxy).read)
		doc.css('div.lockup.product.application div.artwork img.artwork').each do |link|		
			curDir = Dir.pwd
			pathToFile = "#{curDir}/icons/#{appName}.jpg"

			p "Save #{link['src']} as #{pathToFile}"

			File.open(pathToFile, 'wb') do |fo|
				fo.write open(link['src'], 'User-Agent' => @userAgent, :proxy => @proxy).read
			end
		end
	rescue Exception => e
		p e.to_s
		processApp(appLink)			
	end 
end

def processGenre(genreLink)
	doc = Nokogiri::HTML(open(genreLink).read)
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
	doc = Nokogiri::HTML(open('https://itunes.apple.com/ru/genre/ios/id36?mt=8').read)
	doc.css('a.top-level-genre').each do |link|	
		p "Process category: #{link.text}"
		processGenre(link['href'])
	end
end

begin
  processApps
rescue SystemExit, Interrupt
	p "SystemExit"
rescue Exception => e
	p e.to_s
end

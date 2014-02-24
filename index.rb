#!/usr/bin/ruby

require 'phashion'
require 'json'

imageHashes = Hash.new

Dir.glob("icons/*.jpg") do |iconFile|
	begin
	  puts "Process: #{iconFile}"
	  image = Phashion::Image.new(iconFile)
	  fingerprint = image.fingerprint
	  imageHashes[iconFile] = image.fingerprint
	rescue Exception => e
		p "Exception: #{e.to_s}"
	end
end

File.open("hashes.db","w") do |f|
  f.write(JSON.pretty_generate(imageHashes))
end
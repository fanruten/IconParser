#!/usr/bin/ruby

require 'phashion'
require 'json'

@imageHashes = nil

def compareIcon(file)
	originalImage = Phashion::Image.new(file)
	originalImageFingerprint = originalImage.fingerprint

	minDistance = 100
	minDistanceFile = Array.new

	@imageHashes.each do |imageName, imageFingerprint|
		distance = Phashion.hamming_distance(originalImageFingerprint, imageFingerprint)
	  	#p "distance: #{distance} with: #{iconFile}"
	  	if distance < minDistance
	  		minDistance = distance
	  		minDistanceFile.clear
	  		minDistanceFile.push(imageName)
	  	elsif distance == minDistance
	  		minDistanceFile.push(imageName)
	  	end
	end

	if minDistance <= 15
		p "minDistance: #{minDistance} for: #{file} with: #{minDistanceFile}"
	else
		#p "can't find icon for: #{file}"
	end	
end

File.open("hashes.db","r") do |f|
	@imageHashes = JSON.load(f)
end

Dir.glob("screens/*/*.jpg") do |iconFile|
	compareIcon(iconFile)
end

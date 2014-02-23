#!/usr/bin/ruby

require 'phashion'
require 'RMagick'

def compareIcon(file)
	originalImg = Phashion::Image.new(file)

	minDistance = 100
	minDistanceFile = ""

	Dir.glob("screens/*/*.jpg") do |iconFile|
	  splitedImg = Phashion::Image.new(iconFile)
	  distance = originalImg.distance_from(splitedImg)
	  #p "distance: #{distance} with: #{iconFile}"
	  if distance < minDistance
	  	minDistance = distance
	  	minDistanceFile = iconFile
	  end
	end

	p "minDistance: #{minDistance} with: #{minDistanceFile}"
end

Dir.glob("icons/*.jpg") do |iconFile|
  puts "Compare: #{iconFile}"
  compareIcon(iconFile)
end

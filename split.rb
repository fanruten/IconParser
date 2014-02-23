#!/usr/bin/ruby

require 'RMagick'
require 'pathname'
require 'fileutils'

def splitScreen(file)
	curDir = Dir.pwd
	pathToFile = File.dirname(file)
	fileName = File.basename(file)
	clearFileName = File.basename(file, ".*")
	pathToSplit = "#{curDir}/#{pathToFile}/#{clearFileName}"
	pathToScreen = "#{curDir}/#{file}"

	Dir.chdir pathToFile
	FileUtils.mkdir_p pathToSplit
	Dir.chdir pathToSplit

	screenshot = Magick::ImageList.new(pathToScreen)
		
	icon11 = screenshot.crop(34, 50, 120, 122)
	icon11.write('icon11.jpg')
	icon12 = screenshot.crop(34, 225, 120, 122)
	icon12.write('icon12.jpg')
	icon13 = screenshot.crop(34, 400, 120, 122)
	icon13.write('icon13.jpg')
	icon14 = screenshot.crop(34, 575, 120, 122)
	icon14.write('icon14.jpg')
	icon15 = screenshot.crop(34, 750, 120, 122)
	icon15.write('icon15.jpg')

	icon21 = screenshot.crop(185, 50, 120, 122)
	icon21.write('icon21.jpg')
	icon22 = screenshot.crop(185, 225, 120, 122)
	icon22.write('icon22.jpg')
	icon23 = screenshot.crop(185, 400, 120, 122)
	icon23.write('icon23.jpg')
	icon24 = screenshot.crop(185, 575, 120, 122)
	icon24.write('icon24.jpg')
	icon25 = screenshot.crop(185, 750, 120, 122)
	icon25.write('icon25.jpg')

	icon31 = screenshot.crop(336, 50, 120, 122)
	icon31.write('icon31.jpg')
	icon32 = screenshot.crop(336, 225, 120, 122)
	icon32.write('icon32.jpg')
	icon33 = screenshot.crop(336, 400, 120, 122)
	icon33.write('icon33.jpg')
	icon34 = screenshot.crop(336, 575, 120, 122)
	icon34.write('icon34.jpg')
	icon35 = screenshot.crop(336, 750, 120, 122)
	icon35.write('icon35.jpg')

	icon41 = screenshot.crop(490, 50, 120, 122)
	icon41.write('icon41.jpg')
	icon42 = screenshot.crop(490, 225, 120, 122)
	icon42.write('icon42.jpg')
	icon43 = screenshot.crop(490, 400, 120, 122)
	icon43.write('icon43.jpg')
	icon44 = screenshot.crop(490, 575, 120, 122)
	icon44.write('icon44.jpg')
	icon45 = screenshot.crop(490, 750, 120, 122)
	icon45.write('icon45.jpg')


	icon1 = screenshot.crop(34, 972, 120, 122)
	icon1.write('icon1.jpg')
	icon2 = screenshot.crop(185, 972, 120, 122)
	icon2.write('icon2.jpg')
	icon3 = screenshot.crop(336, 972, 120, 122)
	icon3.write('icon3.jpg')
	icon4 = screenshot.crop(490, 972, 120, 122)
	icon4.write('icon4.jpg')
	
	Dir.chdir curDir
end

Dir.glob("screens/*.PNG") do |screenFile|
  puts "Splitting: #{screenFile}"
  splitScreen(screenFile)
end

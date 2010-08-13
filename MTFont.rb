# MTFont.rb
# mister t
#
# Created by Cameron on 8/5/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

require 'taggable'
require 'enumerator'

class MTFont

	include Taggable

	attr_reader :name, :variants

    #self.inherited(klass)
    #  super
    #end

	def initialize(font_name)
		font = NSFont.fontWithName(font_name, size:12)
		@name = font_name
	end
	
	def variants
		NSFontManager.new.availableMembersOfFontFamily @name
	end

	def is_monospace?
		self.isFixedPitch
	end

end

class MTFonts

	include Enumerable
	
	attr_reader :fontlist
	
	def initialize
		@fontlist = NSFontManager.new.availableFontFamilies.sort	
	end
	
	def each
		@fontlist.each { |f| yield f }
	end

end


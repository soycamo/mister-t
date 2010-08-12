# MTFont.rb
# mister t
#
# Created by Cameron on 8/5/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

require 'taggable'

class MTFont

	include Taggable

	attr_reader :name, :variants

    #self.inherited(klass)
    #  super
    #end

	def initialize(font_name)
		font = NSFont.fontWithName(font_name, size:12)
		@name = font_name
    #@tags = []
	end
	
	def variants
		NSFontManager.new.availableMembersOfFontFamily @fonts[@font_table_view.selectedRow]
	end

	def is_monospace?
		self.isFixedPitch
	end

end

class MTFonts

	def initialize
		NSFontManager.new.availableFontFamilies.sort	
	end

end


# FontData.rb
# mister t
#
# Created by Cameron Adamez on 3/21/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.


class FontData

  attr_accessor :name, :gly, :mono, :tags

  def initialize(font_name)
    font = NSFont.fontWithName(font_name, size:12)
    #if font.displayName
    #    @name = font.displayName
    #  else
    #    @name = font.fontName
    #  end
    @gly = font.numberOfGlyphs.to_i
    @mono = font.isFixedPitch
    @tags = []
  end
  
end
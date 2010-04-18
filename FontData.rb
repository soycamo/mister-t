# FontData.rb
# mister t
#
# Created by Cameron Adamez on 3/21/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.

=begin
      theDict["gly"] = font.numberOfGlyphs
      theDict["ascender"] = font.ascender
      theDict["descender"] = font.descender
      theDict["leading"] = font.leading
      theDict["LineHeight"] = font.defaultLineHeightForFont
      theDict["xHeight"] = font.xHeight
      theDict["capHeight"] = font.capHeight
      theDict["italicAngle"] = font.italicAngle
      theDict["underlinePosition"] = font.underlinePosition
      theDict["underlineThickness"] = font.underlineThickness
      theDict["mostCompatibleStringEncoding"] = font.mostCompatibleStringEncoding
      theDict["XBounds"] = NSMinX(boundRect)
      theDict["YBounds"] = NSMinY(boundRect)
      theDict["WidthBounds"] = NSWidth(boundRect)
      theDict["HeightBounds"] = NSHeight(boundRect)
      theDict["AdvWidth"] = font.maximumAdvancement.width
      theDict["AdvHeight"] = font.maximumAdvancement.height
=end


class Font

  attr_accessor :name, :gly, :tags

  def initialize(font_name)
    @name = font_name
    font = NSFont.fontWithName(font_name, size:12)
    #if font.displayName
    #    @name = font.displayName
    #  else
    #    @name = font.fontName
    #  end
    @gly = font.numberOfGlyphs.to_i

    # Autotagging
    #mono = font.isFixedPitch ? "monospaced" : nil
    
    @tags = []
    
  end
  
  def variants # Array with variant name, displayed style, weight, and who knows what the last number is.
    NSFontManager.new.availableMembersOfFontFamily(self.name)
  end
  
  def bold # returns 
    if self.variants.rassoc("Bold")
      self.variants.rassoc("Bold")[0]
    else 
      false
    end
  end
  
  def italic
    if self.variants.rassoc("Italic")
      self.variants.rassoc("Italic")[0]
    else 
      false
    end
  end
  
end

class TagClass
  
  attr_accessor :f
  
  def initialize(fonts)
    @f = fonts
  end
  
  def allthese
    ary = []
    @f.each do |x|
      ary << x["tags"]
    end
    ary.flatten!.uniq!.sort!
  end
  
  def fonts_from_tag(t)
    ary = []
    @f.each do |x|
      if x["tags"].include?(t)
        ary << x["name"]
      end
    end
    ary.sort!
  end
  
end
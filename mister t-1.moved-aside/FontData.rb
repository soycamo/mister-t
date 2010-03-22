# FontData.rb
# mister t
#
# Created by Cameron Adamez on 3/20/10.
# Copyright 2010 __MyCompanyName__. All rights reserved.


class FontData
  attr_accessor :aFont, :name, :gly, :mono

  def aFont(font)
    NSFont.fontWithName(font, size:12)
  end
  
  @name = @aFont.fontName
  @gly = @aFont.numberOfGlyphs
  @mono = @aFont.isFixedPitch ? "YES" : "NO"

end

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
      # HAY GUYZE we actually call this monospaced but w/e
      theDict["isFixedPitch"] = font.isFixedPitch ? "YES" : "NO" 
=end
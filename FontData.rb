# FontData.rb
# mister t

require 'taggable'

class Font
  include Taggable

  attr_reader :name, :gly, :encod

  def initialize(font_name)
    @name = font_name
    font = NSFont.fontWithName(font_name, size:12)
    @gly = font.numberOfGlyphs.to_i
    @encod = String.localizedNameOfStringEncoding font.mostCompatibleStringEncoding # Not very rubylike.
    
    add_tag "monospace" if font.isFixedPitch
  end
  
  def variants # Array with variant name, displayed style, weight, and who knows what the last number is.
    NSFontManager.new.availableMembersOfFontFamily(self.name)
  end
  
  def has_bold?
    if self.variants.rassoc("Bold")
      self.variants.rassoc("Bold")[0]
    else 
      false
    end
  end
  
  def has_italic?
    if self.variants.rassoc("Italic")
      self.variants.rassoc("Italic")[0]
    else 
      false
    end
  end

  def to_dict
    dict = {}
    dict["name"] = self.name
    dict["encod"] = self.encod
    dict["gly"] = self.gly
    dict["tags"] = self.tags
    dict
  end

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
=end
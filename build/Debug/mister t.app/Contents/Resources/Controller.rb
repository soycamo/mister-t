# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

class Controller

  attr_writer :fontListView, :fontSampleView
  attr_accessor :fonts
  
  def awakeFromNib
    
    @fonts = []
    @fontListView.setDataSource self
    @fontListView.reloadData
    
    @dummytext = "This is some dummy text"
    
    NSNotificationCenter.defaultCenter.addObserver self,
      selector:'fontSetChanged:',
      name:NSFontSetChangedNotification, 
      object: nil
    
    createFontList
  end
  
  def createFontList
  
    nameEnum = NSFontManager.new.availableFonts
    
    nameEnum.each do |name|
      theDict = {}
      font = NSFont.fontWithName(name, size:12)
      
      if font.displayName
        theDict["name"] = font.displayName
      else
        theDict["name"] = font.fontName
      end
    
      #theDict["gly"] = font.numberOfGlyphs.to_s
      #theDict["mono"] = font.isFixedPitch ? "YES" : "NO"

      @fonts << theDict
    end
    
    @fontListView.reloadData
  end
  
  def fontSetChanged(notification)
    @fontListView.reloadData
  end
  
  # TABLESSSS
  
  def numberOfRowsInTableView(view)
    @fonts ? @fonts.size : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @fonts[index]["name"]
  end
  
  # Font sample part
  
  def textView(text)
    @dummytext
  end

end
# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

class Controller

  attr_writer :fontListView, :fontSampleView
  attr_accessor :fonts, :textView
  
  def awakeFromNib
    @fonts = []

    @fontListView.setDataSource self
    @fontListView.reloadData
    
    NSNotificationCenter.defaultCenter.addObserver self,
      selector:'fontSetChanged:',
      name:NSFontSetChangedNotification, 
      object: nil
    
    createFontList
    createSampleView
  end
  
  def createFontList
  
    all_fonts = NSFontManager.new.availableFonts
    all_fonts.each do |f|
      font_dict = {}
      font = FontData.new(f)
      font_dict["name"] = font.name
      @fonts << font_dict
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
  
  def createSampleView
    sample = "The quick brown fox jumps over the lazy dog?!"
    ind = @fontListView.clickedRow
    fontname = @fonts[ind]["name"]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample
  end
  
  def viewItem(sender)

  end

end
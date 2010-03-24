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

    NSNotificationCenter.defaultCenter.addObserver self,
      selector:'fontSetChanged:',
      name:NSFontSetChangedNotification, 
      object: nil
    
    createFontList
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
  
  def numberOfRowsInTableView(view)
    @fonts ? @fonts.size : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @fonts[index]["name"]
  end
  
  def tableViewAction(sender)
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[@fontListView.selectedRow]["name"]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_en
  end
  
  # Font sample part
  
  private

  def createSampleView(findex)
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[findex]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_en
  end

end
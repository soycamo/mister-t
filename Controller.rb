# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

require 'yaml'

class Controller

  attr_writer :fontListView, :fontSampleView, :tokenView
  attr_accessor :fonts
  
  def awakeFromNib

    retrieve_fonts
    
    create_sample_view
    show_tags @fonts[@fontListView.selectedRow]["tags"]
    
    ncenter = NSNotificationCenter.defaultCenter
    ncenter.addObserver self,
      selector:'tableViewSelectionDidChange:',
      name:NSTableViewSelectionDidChangeNotification,
      object: nil
    ncenter.addObserver self,
      selector:'textDidEndEditing:',
      name:NSTextDidEndEditingNotification,
      object: nil
    
  end
  
  def yaml_file
    yaml_file = File.expand_path('~/mister-t.yml')
    unless File.exist?(yaml_file)
      File.open(yaml_file, 'w+'){|f| f << @fonts.to_yaml}
    end
    yaml_file
  end
  
  def retrieve_fonts
    @fonts = YAML.load_file(yaml_file) || []
    if @fonts == []
      createFontList
    end
    @fontListView.setDataSource self
    @fontListView.reloadData
    @fontListView.selectRowIndexes(NSIndexSet.indexSetWithIndex(0), byExtendingSelection:false) 
  end
  
  
  def createFontList
    all_fonts = NSFontManager.new.availableFontFamilies.sort
    all_fonts.each do |f|
      font_dict = {}
      font = FontData.new(f)
      font_dict["name"] = f
      font_dict["tags"] = font.tags
      @fonts << font_dict
    end
    @fontListView.reloadData
  end
  
#  def fontSetChanged(notification)
#    @fontListView.reloadData
#  end
  
  def numberOfRowsInTableView(view)
    @fonts ? @fonts.size : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @fonts[index]["name"]
  end
  
  def tableViewSelectionDidChange(notification)
    create_sample_view
    show_tags @fonts[@fontListView.selectedRow]["tags"]
  end
  
  def textDidEndEditing(notification)
    save_tags
  end
  
  def show_tags(tags)
    unless tags === ''
      @tokenView.setStringValue tags.join(', ')
    else
      @tokenView.setStringValue ''
    end
  end
  
  def addTag(sender)
    save_tags
  end
  
  def clearTag(sender)
    clear_tags
  end

  private
  
  def clear_tags
    @tokenView.setStringValue ''
    @fonts[@fontListView.selectedRow]["tags"] = ''
    File.open(yaml_file, 'w'){|f| f << @fonts.to_yaml}
  end
  
  def save_tags
    @fonts[@fontListView.selectedRow]["tags"] = @tokenView.stringValue.split(', ')
    File.open(yaml_file, 'w'){|f| f << @fonts.to_yaml}
  end
  

  def create_sample_view
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[@fontListView.selectedRow]["name"]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_en
  end

end
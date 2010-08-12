# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

require 'yaml'
require 'SampleController'

class Controller

  attr_writer :fontListView, :fontSampleView, :tokenView
  attr_accessor :fonts
  
  def awakeFromNib

    retrieve_font_data
    
    ncenter = NSNotificationCenter.defaultCenter
    ncenter.addObserver self,
      selector:'tableViewSelectionDidChange:',
      name:NSTableViewSelectionDidChangeNotification,
      object: nil
    ncenter.addObserver self,
      selector:'textDidEndEditing:',
      name:NSTextDidEndEditingNotification,
      object: nil
    
    @fontListView.setDataSource self
    @fontListView.reloadData
    @fontListView.selectRowIndexes(NSIndexSet.indexSetWithIndex(0), byExtendingSelection:false) 
    
  end

  def retrieve_font_data
    camel = File.expand_path('~/test.yml')
    if File.exist?(camel)
      @fonts = YAML.load_file('/Users/camo/test.yml')
    else
      create_font_list
    end
    #sample_view
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
	sample_view
    show_tags @fonts[@fontListView.selectedRow]["tags"]
  end
  
  def textDidEndEditing(notification)
    save_tags
  end
  
  def show_tags(tags)
    unless tags === ''
      @tokenView.objectValue = tags.join(', ')
    else
      @tokenView.objectValue = []
    end
  end
  
  def addTag(sender)
    save_tags
  end
  
  def clearTag(sender)
    clear_tags
  end

  private
  
  def save
    File.open('/Users/camo/test.yml', 'w+') {|f| f << @fonts.to_yaml}
  end
  
  def clear_tags
    @tokenView.setStringValue ''
    @fonts[@fontListView.selectedRow]["tags"] = []
    save
  end
  
  def save_tags
    @fonts[@fontListView.selectedRow]["tags"] = @tokenView.stringValue.split(', ')
    save
  end
  
  def sample_view
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[@fontListView.selectedRow]["name"]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_en
  end
  
  def create_font_list
    @fonts = []
    all_fonts = NSFontManager.new.availableFontFamilies.sort
    all_fonts.each do |f|
      font_dict = {}
      font = FontData.new(f)
      font_dict["name"] = f
      font_dict["tags"] = font.tags
      @fonts << font_dict
    end
    save
  end

end
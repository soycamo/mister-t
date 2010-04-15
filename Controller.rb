# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

class Controller

  require 'yaml'

  attr_writer :fontListView, :fontSampleView, :tokenView
  attr_accessor :fonts
  
  def awakeFromNib

    retrieve_fonts
    
    NSNotificationCenter.defaultCenter.addObserver self,
      selector:'fontSetChanged:',
      name:NSFontSetChangedNotification, 
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
  end
  
  
  def createFontList
    all_fonts = NSFontManager.new.availableFonts
    all_fonts.each do |f|
      font_dict = {}
      font = FontData.new(f)
      font_dict["name"] = font.name
      font_dict["tags"] = font.tags
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
    createSampleView
    if @fonts[@fontListView.selectedRow]["tags"]
      @tokenView.setStringValue @fonts[@fontListView.selectedRow]["tags"].join(', ')
    end
  end
  
  def addTag(sender)
    @fonts[@fontListView.selectedRow]["tags"] = @tokenView.stringValue.split(', ')
    save_tags
  end
  
  def save_tags
    File.open(yaml_file, 'w'){|f| f << @fonts.to_yaml}
    tokenView.reloadData
  end
  
  private

  def createSampleView
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[@fontListView.selectedRow]["name"]
    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_en
  end

end
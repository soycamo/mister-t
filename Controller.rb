# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

require 'yaml'
YAML_FILE = File.expand_path('~/mister-t.yml')

class Controller

  attr_writer :fontListView, :fontSampleView, :tokenView
  attr_accessor :fonts, :tags
  
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

############
# Table View
############

  def retrieve_font_data
    if File.exist?(YAML_FILE)
      @fonts = YAML.load_file(YAML_FILE)
    else
      create_font_list
    end
  end
  
  def numberOfRowsInTableView(view)
    @fonts ? @fonts.size : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    case column.identifier
      when 'tags'
         # tags
      when 'name'
         @fonts[index]["name"]
      when 'variants'
        # variants here
    end
  end
  
  def tableViewSelectionDidChange(notification)
    sample_view
    show_tags @fonts[@fontListView.selectedRow]["tags"]
  end
  
#  def fontSetChanged(notification)
#    create_font_list
#    @fontListView.reloadData
#  end

######
# Tags
######

  def textDidEndEditing(notification)
    save_tags
  end
  
  def show_tags(tags)
    unless tags === '' || tags == nil
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
  
  def tag_cloud(sender)
  end
  
  def tag_list(sender)
  end
  
  private
  
  def save
    File.open(YAML_FILE, 'w+') {|f| f << @fonts.to_yaml}
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
  
  def create_font_list
    @fonts = []
    all_fonts = NSFontManager.new.availableFontFamilies.sort
    all_fonts.each do |f|
      @fonts << Font.new(f).to_dict
    end
    save
  end
  
  def sample_view
    sample_hash = {
    'en' => "The quick brown fox jumps over the lazy dog?!",
    'ja' => "足が早い茶色のキツネがぐうたら犬を飛び越える。",
    'ko' => "키스의 고유조건은 입술끼리 만나야 하고 특별한 기술은 필요치 않다.",
    'th' => "นายสังฆภัณฑ์ เฮงพิทักษ์ฝั่ง ผู้เฒ่าซึ่งมีอาชีพเป็นฅนขายฃวด ถูกตำรวจปฏิบัติการจับฟ้องศาล ฐานลักนาฬิกาคุณหญิงฉัตรชฎา ฌานสมาธิ",
    'zh_CN' => "視野無限廣，窗外有藍天",
    'zh_TW' => "視野無限廣，窗外有藍天",
    'ar' => "نص حكيم له سر قاطع وذو شأن عظيم مكتوب على ثوب أخضر ومغلف بجلد أزرق",
    'hi' => "त्वरित आलसी कुत्ते पर भूरे लोमड़ी कूदता",
    'gu' => "સમજણ પટતી નથી",
    'ro' => "Широкая электрификация южных губерний даст мощный толчок подъёму сельского хозяйства.",
    'he' => "כך התרסק נפץ על גוזל קטן, שדחף את צבי למים",
    'el' => "Γαζίες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο"
    }
    fontname = @fonts[@fontListView.selectedRow]["name"]
    encod = @fonts[@fontListView.selectedRow]["encod"]
    
    # Pretend that this is a case statement. I can't figure out how to get a case statement to work. :(
    if encod.include? "Japanese"
      lang = 'ja'
    elsif encod.include? "Korean"
      lang = 'ko'
    elsif encod.include? "Thai"
      lang = 'th'
    elsif encod.include? "Simplified Chinese"
      lang = 'zh_CN'
    elsif encod.include? "Traditional Chinese"
      lang = 'zh_TW'
    elsif encod.include? "Arabic"
      lang = 'ar'
    elsif encod.include? "Devangari"
      lang = 'hi'
    elsif encod.include? "Gujarati"
      lang = 'gu'
    elsif encod.include? "Cyrillic" # TODO adjust to country locale
      lang = 'ro'
    elsif encod.include? "Greek"
      lang = 'el'
    elsif encod.include? "Hebrew"
      lang = 'he'
    else
      lang = 'en'
    end

    @fontSampleView.setFont NSFont.fontWithName(fontname, size:24)
    @fontSampleView.setStringValue sample_hash[lang]
  end

end

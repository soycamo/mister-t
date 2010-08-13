# Controller.rb
# mister t
#
# Created by Cameron Adamez on 3/18/10.

require 'yaml'

FONT_DATA = File.expand_path('~/test.yml')

class Controller

  attr_writer :fontListView, :fontSampleView, :tokenView, :variantComboBox
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
    
	@variantComboBox.usesDataSource = true
	@variantComboBox.dataSource = self
	@variantComboBox.selectItemAtIndex 0
	@fontListView.dataSource = self
    @fontListView.reloadData
    @fontListView.selectRowIndexes(NSIndexSet.indexSetWithIndex(0), byExtendingSelection:false) 
    
  end

  def retrieve_font_data
    if File.exist?(FONT_DATA)
      @fonts = YAML.load_file(FONT_DATA)
    else
      create_font_list
    end
  end
  
#  def fontSetChanged(notification)
#    @fontListView.reloadData
#  end
  
  def numberOfRowsInTableView(view)
    @fonts ? @fonts.size : 0
  end
  
  def tableView(view, objectValueForTableColumn:column, row:index)
    @fonts[index].name
  end
  
  def tableViewSelectionDidChange(notification)
	sample_view
    @tokenView.objectValue = @fonts[@fontListView.selectedRow].tags
  end
  
  def textDidEndEditing(notification)
	@fonts[@fontListView.selectedRow].add_tags @tokenView.objectValue 
    save
  end
  
  
  #def show_tags(tags)
  #  unless tags === '' || nil
  #    #@tokenView.objectValue = tags.join(', ')
#	  @tokenView.objectValue = tags
 #   else
  #    @tokenView.objectValue = []
  #  end
  #end
  
  def addTag(sender)
    save
  end
  
  def clearTag(sender)
    @fonts[@fontListView.selectedRow].clear_tags
	save
  end

	def numberOfItemsInComboBox(comboBox)
		@fonts[@fontListView.selectedRow].variants.length
	end

	def comboBox(cbox, objectValueForItemAtIndex:index)
		@fonts[@fontListView.selectedRow].variants[index][1]
	end

	#def comboBox(cbox, indexOfItemWithStringValue:str)
	#	@fonts[@fontListView.selectedRow].variants.indexOfObject(str)
	#end

	#def comboBox(cbox, completedString:str)
		# This method is received after each character typed by the user,
		# because we have checked the "completes" flag for genreComboBox in IB.
		# Given the inputString the user has typed, see if we can find a genre with the prefix,
		# and return it as the suggested complete string.

    # NSString *candidate = [self firstGenreMatchingPrefix:inputString];
	

    # return (candidate ? candidate : inputString);

	#end 
	
  private
  
  def save
    File.open('/Users/camo/test.yml', 'w+') {|f| f << @fonts.to_yaml}
  end
  
  def sample_view
    sample_en = "The quick brown fox jumps over the lazy dog?!"
    sample_ja = "足が早い茶色のキツネがぐうたら犬を飛び越える。"
    fontname = @fonts[@fontListView.selectedRow].name
    @fontSampleView.font = NSFont.fontWithName(fontname, size:24)
    @fontSampleView.stringValue = sample_en
  end
  
  def create_font_list
	#This should just return a freaking array of objects, not this whole other BS!
    @fonts = []
    MTFonts.new.each do |f|
      @fonts << MTFont.new(f)
    end
    save
  end

end
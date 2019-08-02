class List
  def initialize(parent, path, with_buttons = true)
    @parent = parent
    @wrapper = Box.new(@parent, { :opts => LAYOUT_FILL_X, :padding => 0, :vSpacing => 0 })
    if with_buttons
      # Top bar
      @buttons = []
      @button_frame = Box.new(@wrapper.object, { :opts => LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, :height => 56, :padding => 16, :hSpacing => 12 })
      @button_frame.object.backColor = clr("#FFFFFF")
      #@buttons << ListButton.new(@button_frame.object, "Filter", nil)
      #@buttons << ListButton.new(@button_frame.object, "Delete", get_icon("delete"))
      @buttons << ListButton.new(@button_frame.object, "Add", get_icon("add"), LAYOUT_SIDE_LEFT, "#FA2360", "#FFFFFF")
      @buttons << ListButton.new(@button_frame.object, "Import from CSV", get_icon("import_k"), LAYOUT_SIDE_LEFT)
      @buttons << ListButton.new(@button_frame.object, "Export", get_icon("export_k"), LAYOUT_SIDE_RIGHT)
    end
    # Data
    @splitter = HorizontalSplitter.new(@wrapper.object)
    @columns, line_no = [], -1
    search = File.file?(path) ? path : path + "/*.csv"
    Dir.glob(search).each do |file|
      csv = CSV.read(file)
      # Create boxes
      @columns << Box.new(@splitter.object, { :opts => LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH, :width => 32, :padding => 0, :vSpacing => 2 })
      csv.first.each { @columns << Box.new(@splitter.object, { :opts => LAYOUT_FILL_Y, :padding => 0, :vSpacing => 2 }) }
      @columns << Box.new(@splitter.object, { :opts => LAYOUT_FILL_Y|LAYOUT_FILL_X, :padding => 0, :vSpacing => 2 })
      @columns.each { |k| k.object.backColor = clr("#F3F3F3")}
      csv.each do |line|
        line_no += 1
        text = Text.new(@columns.first.object, " ", { :opts => LAYOUT_FILL_X, :padding => 8 })
        text.object.backColor = clr("#FFFFFF")
        line.each_with_index do |cell, index|
          is_id = (index == 0) && (line_no > 0)
          opts = { :opts => ICON_BEFORE_TEXT|JUSTIFY_LEFT|LAYOUT_FILL_X, :padding => 8, :padRight => 16 }
          text = Text.new(@columns[index + 1].object, is_id ? " " : cell, opts, is_id ? get_barcode(cell) : nil)
          text.object.backColor = clr("#FFFFFF")
        end
        text = Text.new(@columns.last.object, " ", { :opts => LAYOUT_FILL_X, :padding => 8 })
        text.object.backColor = clr("#FFFFFF")
      end
    end
  end

  def add_button
    return @buttons[0].object.object
  end
end

class ListButton
  attr_accessor :object
  def initialize(parent, text, icon = nil, layout_side = LAYOUT_SIDE_LEFT, back_color = "#EFEFEF", text_color = "#000000")
    @object = Text.new(parent, text, { :opts => ICON_BEFORE_TEXT|layout_side, :padding => 6, :padLeft => 8, :padRight => 8 }, icon)
    @back_color = @object.object.backColor = clr(back_color)
    @text_color = @object.object.textColor = clr(text_color)
    @font = @object.object.font
    @object.object.connect(SEL_ENTER) { on_enter }
    @object.object.connect(SEL_LEAVE) { on_leave }
  end

  def on_enter
    #
  end

  def on_leave
    #
  end
end
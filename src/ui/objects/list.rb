class List
  def initialize(parent, path)
    @parent = parent
    @wrapper = Box.new(@parent, { :opts => LAYOUT_FILL_X, :padding => 0, :vSpacing => 0 })
    # Top bar
    @buttons = []
    @button_frame = Box.new(@wrapper.object, { :opts => LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, :height => 56, :padding => 16, :hSpacing => 12 })
    @button_frame.object.backColor = clr("#FFFFFF")
    @buttons << ListButton.new(@button_frame.object, "Filter", nil)
    @buttons << ListButton.new(@button_frame.object, "Delete", get_icon("delete"))
    @buttons << ListButton.new(@button_frame.object, "Add product", get_icon("add"), LAYOUT_SIDE_RIGHT, "#FA2360", "#FFFFFF")
    @buttons << ListButton.new(@button_frame.object, "Import from CSV", get_icon("import_k"), LAYOUT_SIDE_RIGHT)
    @buttons << ListButton.new(@button_frame.object, "Export", get_icon("export_k"), LAYOUT_SIDE_RIGHT)
    # Data
    @splitter = HorizontalSplitter.new(@wrapper.object)
    @columns, line_no = [], -1
    Dir.glob("#{path}/*.csv").each do |file|
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
          unless (index == 0) && (line_no > 0)
            opts = line_no == 0 ? { :opts => JUSTIFY_LEFT|LAYOUT_FILL_X, :padding => 8 } : { :opts => JUSTIFY_LEFT|LAYOUT_FILL_X, :padding => 8 }
            text = Text.new(@columns[index + 1].object, cell, opts)
            text.object.backColor = clr("#FFFFFF")
          else
            icon = get_barcode(cell)
            puts icon
            opts = { :opts => ICON_BEFORE_TEXT|JUSTIFY_LEFT|LAYOUT_FILL_X, :padding => 8 }
            text = Text.new(@columns[index + 1].object, " ", opts, icon)
            text.object.backColor = clr("#FFFFFF")
          end
        end
        text = Text.new(@columns.last.object, " ", { :opts => LAYOUT_FILL_X, :padding => 8 })
        text.object.backColor = clr("#FFFFFF")
      end
    end
  end
end

class ListButton
  attr_accessor :object
  def initialize(parent, text, icon = nil, layout_side = LAYOUT_SIDE_LEFT, back_color = "#EFEFEF", text_color = "#000000")
    @object = Text.new(parent, text, { :opts => ICON_BEFORE_TEXT|layout_side, :padding => 6 }, icon)
    @object.object.backColor = clr(back_color)
    @object.object.textColor = clr(text_color)
  end
end
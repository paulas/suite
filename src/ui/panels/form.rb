class Form
  def initialize(parent)
    @fields = []
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 16, :vSpacing => 2 })
    set_form(
      {
        "tags" => { :caption => "Tags", :default => "Filter by tag" },
        "sku" => { :caption => "SKU", :default => "Filter by SKU" },
        "conditions" => { :caption => "Conditions", :default => "All conditions" },
        "category" => { :caption => "Category", :default => "All category" },
        "locations" => { :caption => "Locations", :default => "All locations" }
      }
    )
  end

  def set_form(hash)
    hash.each do |key, value|
      # Caption
      text = Text.new(@wrapper.object, value[:caption])
      text.object.textColor = clr("#FFFFFF")
      # Input field
      field = Field.new(@wrapper.object, value[:default])
      field.object.borderColor = clr("#454A52")
      field.object.backColor = @parent.backColor
      field.object.textColor = clr("#636975")
      # Padding
      Text.new(@wrapper.object, "")
      # Assign
      @fields << [key, field]
    end
    Text.new(@wrapper.object, "")
    # Buttons
    opts = { :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL_X }
    splitter = FXSplitter.new(@wrapper.object, opts) { |k| k.barSize = 0; k.backColor = k.parent.backColor; k.create }
    clear_btn = Button.new(splitter, "Clear filter", { :opts => FRAME_LINE|LAYOUT_FIX_WIDTH, :width => (@wrapper.object.parent.width - 40) / 2, :padding => 6 })
    clear_btn.object.borderColor = clr("#454A52")
    clear_btn.object.textColor = clr("#636975")
    Box.new(splitter, { :opts => LAYOUT_FIX_WIDTH, :width => 8} )
    apply_btn = Button.new(splitter, "Apply filter", { :opts => FRAME_NONE|LAYOUT_FILL_X, :padding => 6 })
    apply_btn.object.borderColor = clr("#454A52")
    apply_btn.object.textColor = clr("#FFFFFF")
    apply_btn.object.backColor = clr("#454A52")
  end

  def get_values()
    values = []
    @fields.each do |key, field|
      values << [key, field.object.text]
    end
    return values
  end
end
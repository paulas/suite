class Form
  def initialize(parent, hash = nil)
    @parent = parent
    set_form(hash) unless hash == nil
  end

  def clear
    remove_children(@parent)
    @parent.width = 0
  end

  def set_form(hash)
    @fields = []
    clear
    @parent.width = 200
    @wrapper = Box.new(@parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 16, :vSpacing => 2 })
    hash[:fields].each do |key, value|
      # Caption
      text = Text.new(@wrapper.object, value[:caption])
      text.object.textColor = clr("#FFFFFF")
      # Input field
      field = Field.new(@wrapper.object, value[:default], -1, (value.key?(:password) && value[:password] == true))
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
    buttons = []
    if hash[:buttons].length == 2
      opts = { :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL_X }
      splitter = FXSplitter.new(@wrapper.object, opts) { |k| k.barSize = 0; k.backColor = k.parent.backColor; k.create }
      opts = { :opts => LAYOUT_FIX_WIDTH, :width => (@wrapper.object.parent.width - 40) / 2, :padding => 6 }
      opts[:opts] |= hash[:buttons].first[1].key?(:border_color) ? FRAME_LINE : FRAME_NONE
      buttons << Button.new(splitter, hash[:buttons].first[1][:caption], opts)
      buttons.last.object.borderColor = clr(hash[:buttons].first[1][:border_color]) if hash[:buttons].first[1].key?(:border_color)
      buttons.last.object.textColor = clr(hash[:buttons].first[1][:text_color]) if hash[:buttons].first[1].key?(:text_color)
      buttons.last.object.backColor = clr(hash[:buttons].first[1][:back_color]) if hash[:buttons].first[1].key?(:back_color)
      Box.new(splitter, { :opts => LAYOUT_FIX_WIDTH, :width => 8} )
      opts = { :opts => LAYOUT_FILL_X, :padding => 6 }
      opts[:opts] |= hash[:buttons].to_a.last[1].key?(:border_color) ? FRAME_LINE : FRAME_NONE
      buttons << Button.new(splitter, hash[:buttons].to_a.last[1][:caption], opts)
      buttons.last.object.borderColor = clr(hash[:buttons].to_a.last[1][:border_color]) if hash[:buttons].to_a.last[1].key?(:border_color)
      buttons.last.object.textColor = clr(hash[:buttons].to_a.last[1][:text_color]) if hash[:buttons].to_a.last[1].key?(:text_color)
      buttons.last.object.backColor = clr(hash[:buttons].to_a.last[1][:back_color]) if hash[:buttons].to_a.last[1].key?(:back_color)
    end
    return buttons
  end

  def get_value(text)
    values = get_values
    values.each { |key, value| return value if key == text }
    return nil
  end

  def get_values()
    values = []
    @fields.each { |key, field| values << [key, field.object.text] }
    return values
  end
end
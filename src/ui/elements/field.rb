class Field
  attr_accessor :object
  def initialize(parent, default = "", opts = -1, password = false)
    is_edited = false
    if opts == -1
      opts = { :opts => FRAME_LINE|LAYOUT_FILL_X, :padding => 6 }
      opts[:opts] |= TEXTFIELD_PASSWD if password
    end
    (opts == -1) && password
    @object = FXTextField.new(parent, 0, opts) { |k| k.text = default; k.create }
    @object.connect(SEL_LEFTBUTTONPRESS) { |k| @object.text, @object.textColor, is_edited = "", clr("#FFFFFF"), true unless is_edited }
  end
end
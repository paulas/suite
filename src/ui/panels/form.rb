class Form
  def initialize(parent)
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 16 })
    top_box = Box.new(@wrapper.object)
    top_box.set_backcolor("#FFFFFF")
    label = Text.new(top_box.object, "Test")
  end
end
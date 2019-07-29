class Box
  attr_accessor :object
  def initialize(parent, opts = -1)
    opts = { :opts => FRAME_LINE|LAYOUT_FILL_X } if opts == -1
    @object = FXPacker.new(parent, opts) { |k| k.backColor = parent.backColor; k.create }
  end
end
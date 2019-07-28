class Box
  def initialize(parent, opts = -1)
    opts = { :opts => FRAME_LINE|LAYOUT_FILL_X } if opts == -1
    @packer = FXPacker.new(parent, opts) { |k| k.backColor = parent.backColor; k.create }
  end
  def object
    return @packer
  end
  def set_backcolor(color)
    @packer.backColor = clr(color)
  end
end
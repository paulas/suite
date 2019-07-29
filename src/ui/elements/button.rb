class Button
  attr_accessor :object
  def initialize(parent, caption = "", opts = -1)
    opts = { :opts => LAYOUT_FILL_X|FRAME_NONE } if opts == -1
    @object = FXLabel.new(parent, caption, nil, opts) { |k| 
      k.backColor = parent.backColor
      k.create
    }
  end
end
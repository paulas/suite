class Text
  attr_accessor :object
  def initialize(parent, caption = "", opts = -1, icon = nil)
    opts = { :opts => LAYOUT_FILL_X|JUSTIFY_LEFT } if opts == -1
    @object = FXLabel.new(parent, caption, icon, opts == -1 ? {} : opts) { |k| 
      k.backColor = parent.backColor
      k.create
    }
  end
end
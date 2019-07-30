class HorizontalSplitter
  attr_accessor :object
  def initialize(parent, opts = -1)
    opts = { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y|SPLITTER_HORIZONTAL } if opts == -1
    @object = FXSplitter.new(parent, opts) { |k| k.barSize = 0; k.create }
  end
end
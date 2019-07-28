class Text
  def initialize(parent, caption = "", opts = -1)
    opts = {} if opts == -1
    @label = FXLabel.new(parent, caption, opts) { |k| k.create }
  end
  def object
    return @label
  end
end
class Field
  attr_accessor :object
  def initialize(parent, default = "", opts = -1)
    opts = { :opts => FRAME_LINE|LAYOUT_FILL_X, :padding => 6 }
    @object = FXTextField.new(parent, 0, opts) { |k| k.text = default; k.create }
  end
end
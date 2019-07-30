class Content
  def initialize(parent)
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 24 })
  end
  
  def load_path(path)
    data = JSON.load File.open path
    data["objects"].each do |object|
      object.each do |type, parameters|
        case type
          "list"; List.new(@wrapper.object, parameters["path"])
        end
      end
    end
  end
end
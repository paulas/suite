class Content
  def initialize(parent, path = nil)
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 24, :vSpacing => 24 })
    load_path(path) unless path == nil
  end
  
  def load_path(path)
    remove_children(@wrapper.object)
    data = JSON.load File.open path
    data["objects"].each do |object|
      object.each do |type, parameters|
        case type
        when "list"; List.new(@wrapper.object, parameters["path"])
        when "yuyama_manual"; YuyamaManual.new(@wrapper.object, parameters["prescription"])
        end
      end
    end
  end
end
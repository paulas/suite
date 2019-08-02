class Content
  def initialize(parent, path = nil)
    @parent = parent
    @wrapper = Box.new(parent, { :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 24, :vSpacing => 24 })
    load_path(path) unless path == nil
  end

  def clear
    remove_children(@wrapper.object)
  end
  
  def load_path(path)
    $form.clear
    clear
    remove_children(@wrapper.object)
    data = JSON.load File.open path
    data["objects"].each do |object|
      object.each do |type, parameters|
        case type
        when "list"; List.new(@wrapper.object, parameters["path"])
        when "yuyama_manual"; YuyamaManual.new(@wrapper.object, parameters["prescription"])
        when "yuyama_canister_list"; YuyamaCanisterList.new(@wrapper.object)
        when "caremeds_pharmacy"; CareMedsPharmacy.new(@wrapper.object)
        end
      end
    end
  end
end
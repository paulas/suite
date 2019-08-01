class YuyamaCanisterList
  def initialize(parent)
    @parent = parent
    @canisters = JSON.load File.open "./cfg/systems/Yuyama/canisters.json"
    list = List.new(@parent, format_to_csv(@canisters))
    list.add_button.connect(SEL_LEFTBUTTONPRESS) { add_canister_form }
  end

  def add_canister_form
    cancel_button, add_button = $form.set_form(
      {
        :fields => {
          "canister" => { :caption => "Canister Number", :default => "00000" },
          "medication_name" => { :caption => "Medication Name", :default => "" },
          "manufacturer" => { :caption => "Manufacturer", :default => "" },
          "amp" => { :caption => "AMP", :default => "" },
          "vmp" => { :caption => "VMP", :default => "" },
          "batch_no" => { :caption => "Batch Number", :default => "" },
          "expiry" => { :caption => "Expiry", :default => "08/2019" }
        },
        :buttons => {
          "cancel" => { :caption => "Cancel", :text_color => "#636975", :border_color => "#454A52" },
          "add" => { :caption => "Add", :text_color => "#FFFFFF", :back_color => "#454A52" }
        }
      }
    )
    add_button.object.connect(SEL_LEFTBUTTONPRESS) { add_canister }
    cancel_button.object.connect(SEL_LEFTBUTTONPRESS) { $form.clear }
  end

  def delete_canister(canister_no)
    @canisters.each { |key, value| @canisters.delete(key) if canister_no == key }
    File.open("./cfg/systems/Yuyama/canisters.json","w") do |f|
      f.write(@canisters.to_json)
    end
    $content.load_path("./data/live/page_canister_list.json")
  end

  def add_canister
    @values = $form.get_values
    def get_value(k) @values.each { |key, value| return value if key == k }; return nil end
    @canisters.merge!(
      {
        get_value("canister") => {
          "medication_name" => get_value("medication_name"),
          "amp" => get_value("amp"),
          "vmp" => get_value("vmp"),
          "custom_id" => get_value("custom_id"),
          "bounciness" => get_value("bounciness"),
          "batch_id" => get_value("batch_id"),
          "expiry" => get_value("expiry")
        }
      }
    )
    File.open("./cfg/systems/Yuyama/canisters.json","w") do |f|
      f.write(@canisters.to_json)
    end
    $content.load_path("./data/live/page_canister_list.json")
  end

  def format_to_csv(canisters)
    path = "./cfg/systems/Yuyama/"
    CSV.open(path + "canisters.csv", "w") do |csv|
      csv << [" ", "Canister", "Medication Name", "Manufacturer", "Batch No", "Expiry"]
      canisters.each do |canister, value|
        medication_name = value["medication_name"]
        manufacturer = value.key?("manufacturer") ? value["manufacturer"] : "Generic"
        batch_no = value.key?("batch_no") ? value["batch_no"] : "N/A"
        expiry = value.key?("expiry") ? value["expiry"] : "N/A"
        csv << [canister, canister, medication_name, manufacturer, batch_no, expiry]
      end
    end
    return path
  end
end
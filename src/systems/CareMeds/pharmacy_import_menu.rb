class CareMedsPharmacy
  def view_import_trays
    import_menu
  end

  def import_menu
    buttons = $form.set_form(
      {
        :buttons => {
          "by_care_provider" => { :caption => "Import by care provider", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "by_patient" => { :caption => "Import by patient", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "by_start_date" => { :caption => "Import by start date", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "by_overdue" => { :caption => "Import by overdue", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "cancel" => { :caption => "Cancel", :text_color => "#636975", :border_color => "#454A52" }
        }
      }
    )
    buttons.each do |button|
      case button.object.userData
      when "by_care_provider"; button.object.connect(SEL_LEFTBUTTONPRESS) { by_care_provider_menu }
      when "by_patient"; button.object.connect(SEL_LEFTBUTTONPRESS) { by_patient_menu }
      when "by_start_date"; button.object.connect(SEL_LEFTBUTTONPRESS) { puts "by_start_date" }
      when "by_overdue"; button.object.connect(SEL_LEFTBUTTONPRESS) { puts "by_overdue" }
      when "cancel"; button.object.connect(SEL_LEFTBUTTONPRESS) { add_main_buttons }
      end
    end
  end

  def by_care_provider_menu
    cancel_button, search_button = $form.set_form(
      {
        :fields => {
          "care_provider_id" => { :caption => "Care Provider ID", :default => "Search by ID..." },
          "care_provider_name" => { :caption => "Care Provider Name", :default => "Search by name..." }
        },
        :buttons => {
          "cancel" => { :caption => "Cancel", :text_color => "#636975", :border_color => "#454A52" },
          "search" => { :caption => "Search", :text_color => "#FFFFFF", :back_color => "#454A52" }
        }
      }
    )
    cancel_button.object.connect(SEL_LEFTBUTTONPRESS) { import_menu }
    search_button.object.connect(SEL_LEFTBUTTONPRESS) {
      results, search_id, search_name = [], $form.get_value("care_provider_id"), $form.get_value("care_provider_name").upcase
      @care_providers.each do |care_provider| 
        match = ((search_name != "") and (search_name != " ") and (care_provider["name"].upcase.include?(search_name))) || (care_provider["id"].to_s == search_id)
        results << care_provider if match
      end
      puts results.inspect
    }
  end

  def by_patient_menu
    cancel_button, search_button = $form.set_form(
      {
        :fields => {
          "patient_id" => { :caption => "Patient ID", :default => "Search by ID..." },
          "patient_name" => { :caption => "Patient Name", :default => "Search by name..." }
        },
        :buttons => {
          "cancel" => { :caption => "Cancel", :text_color => "#636975", :border_color => "#454A52" },
          "search" => { :caption => "Search", :text_color => "#FFFFFF", :back_color => "#454A52" }
        }
      }
    )
    cancel_button.object.connect(SEL_LEFTBUTTONPRESS) { import_menu }
    search_button.object.connect(SEL_LEFTBUTTONPRESS) {
      results, search_id, search_name = [], $form.get_value("patient_id"), $form.get_value("patient_name").upcase
      @patients.each do |patient| 
        full_name = "#{patient["forenames"]} #{patient["surname"]}".upcase
        match = ((search_name != "") and (search_name != " ") and (full_name.include?(search_name))) || (patient["id"].to_s == search_id)
        results << patient if match
      end
      puts results.inspect
    }
  end
end
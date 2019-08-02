class CareMedsPharmacy
  def initialize(parent)
    @parent = parent
    forgot_button, login_button = $form.set_form(
      {
        :fields => {
          "username" => { :caption => "Username", :default => "" },
          "password" => { :caption => "Password", :default => "", :password => true }
        },
        :buttons => {
          "forgot" => { :caption => "Forgot", :text_color => "#636975", :border_color => "#454A52" },
          "login" => { :caption => "Login", :text_color => "#FFFFFF", :back_color => "#454A52" }
        }
      }
    )
    login_button.object.connect(SEL_LEFTBUTTONPRESS) do 
      if attempt_login($form.get_value("username"), $form.get_value("password"))
        get_care_providers
        get_patients
        $form.clear
        path = "./cfg/systems/CareMeds/"
        csv = []
        CSV.open(path + "patients.csv", "w") do |csv|
          csv << [" ", "ID", "Surname", "Forename", "DOB", "Care Provider"]
          @patients.each do |patient|
            id = patient["id"]
            surname = patient["surname"]
            forename = patient["forenames"]
            dob = patient["dob"]
            care_provider = get_care_provider(patient["care_provider_id"])["name"]
            csv << [id, id, surname, forename, dob, care_provider]
          end
        end
        csv = []
        CSV.open(path + "care_providers.csv", "w") do |csv|
          csv << [" ", "ID", "Name", "Cycle Base", "Duration", "This Cycle", "Next Cycle"]
          @care_providers.each do |care_provider|
            id = care_provider["id"]
            name = care_provider["name"]
            cycle_base = care_provider["cycle_base"]
            cycle_duration = care_provider["cycle_duration"]
            this_cycle_start_date = care_provider["this_cycle_start_date"]
            next_cycle_start_date = care_provider["next_cycle_start_date"]
            csv << [id, id, name, cycle_base, cycle_duration, this_cycle_start_date, next_cycle_start_date]
          end
        end
        add_main_buttons
        care_provider_list = List.new(@parent, path + "care_providers.csv", false)
        patients_list = List.new(@parent, path + "patients.csv", false)
      else
        forgot_button.object.backColor = "#454A52"
        forgot_button.object.textColor = "#FFFFFF"
      end
    end
  end

  def add_main_buttons
    buttons = $form.set_form(
      {
        :buttons => {
          "import_trays" => { :caption => "Import trays", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "dispense_queue" => { :caption => "Dispense queue", :text_color => "#FFFFFF", :back_color => "#454A52" },
          "view_job_history" => { :caption => "View job history", :text_color => "#636975", :border_color => "#454A52" }
        }
      }
    )
    buttons.each do |button|
      case button.object.userData
      when "import_trays"; button.object.connect(SEL_LEFTBUTTONPRESS) { view_import_trays }
      when "dispense_queue"; button.object.connect(SEL_LEFTBUTTONPRESS) { puts "dispense_queue" }
      when "view_job_history"; button.object.connect(SEL_LEFTBUTTONPRESS) { puts "view_job_history" }
      end
    end
  end
end
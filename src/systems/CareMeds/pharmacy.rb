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
        $form.clear
        csv = []
        path = "./cfg/systems/CareMeds/"
        CSV.open(path + "patients.csv", "w") do |csv|
          csv << [" ", "Surname", "Forename", "DOB", "Care Provider"]
          get_patients.each do |patient|
            id = patient["id"]
            surname = patient["surname"]
            forename = patient["forenames"]
            dob = patient["dob"]
            care_provider = patient["care_provider_id"]
            csv << [id, surname, forename, dob, care_provider]
          end
        end
        list = List.new(@parent, path)
      else
        forgot_button.object.backColor = "#454A52"
        forgot_button.object.textColor = "#FFFFFF"
      end
    end
  end

  def get_patients
    data = { :output_format => "robot" }
    res = @connection.get('/role_pharmacy/patients.json', data) { |req| 
      req.headers = { 'Cookie' => @cookie }
    }
    @patients = JSON.parse(res.body)
    return @patients
  end

  def attempt_login(username, password)
    @connection = Faraday.new('https://testing.caremeds.co.uk')
    data = { "user": { "username": username, "password": password } }
    res = @connection.post('/users/sign_in.json', data)
    @cookie = res.headers['set-cookie']
    return res.headers["status"] == "200 OK"
  end
end
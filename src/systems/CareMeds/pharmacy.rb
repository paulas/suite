class CareMedsPharmacy
  def get_patients
    data = { :output_format => "robot" }
    res = @connection.get('/role_pharmacy/patients.json', data) { |req| 
      req.headers = { 'Cookie' => @cookie }
    }
    @patients = JSON.parse(res.body)
    return @patients
  end

  def get_care_providers()
    data = { :output_format => "robot" }
    res = @connection.get('/role_pharmacy/care_providers.json', data) { |req| 
      req.headers = { 'Cookie' => @cookie }
    }
    @care_providers = JSON.parse(res.body)
    return @care_providers
  end

  def get_care_provider(care_provider_id)
    @care_providers.each { |care_provider| return care_provider if care_provider["id"] == care_provider_id }
    return nil
  end

  def attempt_login(username, password)
    @connection = Faraday.new('https://testing.caremeds.co.uk')
    data = { "user": { "username": username, "password": password } }
    res = @connection.post('/users/sign_in.json', data)
    @cookie = res.headers['set-cookie']
    return res.headers["status"] == "200 OK"
  end
end
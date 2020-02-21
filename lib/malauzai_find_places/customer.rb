module MalauzaiFindPlaces

  class Customer
    def self.get_customer_details(customer)
      customers = YAML.load(File.read("../config/customer_data.yml"))
      return !customers[customer].nil? ? customers[customer] : customers["default_customer"]
    end
  end

end
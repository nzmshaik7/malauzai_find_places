require 'rubygems'
require 'erb'
require 'yaml'
require 'httparty'
require 'active_support'


['customer', 'error', 'request'].each do |file|
  require File.join(File.dirname(__FILE__), file)
end

module MalauzaiFindPlaces

  class Query

    attr_accessor :customer, :latitude, :longitude, :options

    def initialize(latitude, longitude, customer, options ={})
      @options = options
      @customer = customer
      @latitude = latitude
      @longitude = longitude
      @customer = Customer.get_customer_details(customer)
    end


    def search_places
      results = []

      begin
        next_page = false

        request = Request.new(get_url, request_parameters)
        response = request.response


        unless response['results'].empty?
          response['results'].each do |result|
            results << retrieve_places(result)
          end

          if !response["next_page_token"].nil?
            options.merge!({
               :pagetoken => response["next_page_token"]
            })
            next_page = true
          else
            next_page = false
          end

        end
      end while next_page

    end

    private

    def get_url
      url_list = YAML.load(File.read("../config/url_list.yml"))
      url_list["google_search_places"]+@customer["response_output"].to_s
    end

    def request_parameters
      options.merge!({
          :key => @customer["api_key"],
          :location => [@longitude, @latitude].join(","),
          :type => @customer["type"]
      })
    end

    def retrieve_places(result)
      {
          :name => result['name'],
          :location => [result['geometry']['location']['lat'],  result['geometry']['location']['lng']].join(",")
      }
    end

  end
end
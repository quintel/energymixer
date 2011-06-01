class ApiClient
  include HTTParty
  base_uri APP_CONFIG['api_base_uri']
  
  GQueries = [ 
        "costs_share_of_coal",
        "costs_share_of_gas",
        "costs_share_of_oil",
        "costs_share_of_uranium",
        "costs_share_of_sustainable",
        "co2_reduction_from_1990_in_percent_with_co2_corrected_for_electricity_import",
        "share_of_renewable_energy",
        "area_footprint_per_nl",
        "energy_dependence",
        "costs_share_of_sustainable_wind",
        "costs_share_of_sustainable_solar",
        "costs_share_of_sustainable_biomass"
      ]
      
  CarrierCostsGQueries = [
    "costs_share_of_coal",
    "costs_share_of_gas",
    "costs_share_of_oil",
    "costs_share_of_uranium",
    "costs_share_of_sustainable",

    "costs_share_of_oil_buildings",
    "costs_share_of_gas_buildings",
    "costs_share_of_coal_buildings",
    "costs_share_of_uranium_buildings",
    "costs_share_of_sustainable_buildings",

    "costs_share_of_oil_industry",
    "costs_share_of_gas_industry",
    "costs_share_of_coal_industry",
    "costs_share_of_uranium_industry",
    "costs_share_of_sustainable_industry",

    "costs_share_of_oil_transport",
    "costs_share_of_gas_transport",
    "costs_share_of_coal_transport",
    "costs_share_of_uranium_transport",
    "costs_share_of_sustainable_transport",

    "costs_share_of_oil_agriculture",
    "costs_share_of_gas_agriculture",
    "costs_share_of_coal_agriculture",
    "costs_share_of_uranium_agriculture",
    "costs_share_of_sustainable_agriculture"
  ]
  
  def current_situation
    query(ApiClient::GQueries)
  end

  def carrier_costs
    Rails.cache.fetch("carrier_costs") do
      carrier_costs!
    end
  end
    
  def carrier_costs!
    query(ApiClient::CarrierCostsGQueries)
  end

  def api_session_key
    @api_session_key ||= api_session_key!
  end
  
  def api_session_key!
    response = self.class.get("/api/v1/api_scenarios/new.json")
    response["api_scenario"]["api_session_key"]
  rescue
    nil
  end
  
  private
  
    def query(gqueries)
        url   = "/api/v1/api_scenarios/#{api_session_key}.json"
        query = { result: gqueries, reset: 1 }

        response = self.class.get(url, :query => query)
        out = {}
        response["result"].each_pair{|k,v| out[k] = v[0][1]}
        out
      rescue
        nil
    end
end
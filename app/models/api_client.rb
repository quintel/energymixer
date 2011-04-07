class ApiClient
  include HTTParty
  base_uri APP_CONFIG['api_base_uri']
  
  GQueries = [ 
        "costs_share_of_coal",
        "costs_share_of_gas",
        "costs_share_of_oil",
        "costs_share_of_uranium",
        "costs_share_of_sustainable",
        "co2_emission_final_demand_to_1990_in_percent",
        "share_of_renewable_energy",
        "area_footprint_per_nl",
        "energy_dependence",
        "costs_share_of_sustainable_wind",
        "costs_share_of_sustainable_solar",
        "costs_share_of_sustainable_biomass"
      ]

  def current_situation
    Rails.cache.fetch("current_situation") do
      current_situation!
    end
  end
    
  def api_session_key
    @api_session_key ||= api_session_key!
  end
  
  def current_situation!
    url   = "/api/v1/api_scenarios/#{api_session_key}.json"
    query = { result: ApiClient::GQueries, reset: 1 }
    
    response = self.class.get(url, :query => query)
    out = {}
    response["result"].each_pair{|k,v| out[k] = v[0][1]}
    out
  rescue
    nil
  end

  def api_session_key!
    response = self.class.get("/api/v1/api_scenarios/new.json")
    response["api_scenario"]["api_session_key"]
  rescue
    nil
  end  
end
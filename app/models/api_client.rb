class ApiClient
  include HTTParty
  base_uri APP_CONFIG['api_base_path']
  
  GQueries = [ 
        "share_of_total_costs_assigned_to_coal",
        "share_of_total_costs_assigned_to_gas",
        "share_of_total_costs_assigned_to_oil",
        "share_of_total_costs_assigned_to_nuclear",
        "share_of_total_costs_assigned_to_renewables",
        "mixer_reduction_of_co2_emissions_versus_1990",
        "mixer_renewability",
        "mixer_bio_footprint",
        "mixer_net_energy_import",
        "share_of_total_costs_assigned_to_wind",
        "share_of_total_costs_assigned_to_solar",
        "share_of_total_costs_assigned_to_biomass",
        "mixer_total_costs"
      ]
      
  CarrierCostsGQueries = [
    "mixer_total_costs",

    "share_of_total_costs_assigned_to_coal",
    "share_of_total_costs_assigned_to_gas",
    "share_of_total_costs_assigned_to_oil",
    "share_of_total_costs_assigned_to_nuclear",
    "share_of_total_costs_assigned_to_renewables",

    "share_of_total_costs_assigned_to_oil_in_buildings",
    "share_of_total_costs_assigned_to_gas_in_buildings",
    "share_of_total_costs_assigned_to_coal_in_buildings",
    "share_of_total_costs_assigned_to_nuclear_in_buildings",
    "share_of_total_costs_assigned_to_renewables_in_buildings",

    "share_of_total_costs_assigned_to_oil_in_industry",
    "share_of_total_costs_assigned_to_gas_in_industry",
    "share_of_total_costs_assigned_to_coal_in_industry",
    "share_of_total_costs_assigned_to_nuclear_in_industry",
    "share_of_total_costs_assigned_to_renewables_in_industry",

    "share_of_total_costs_assigned_to_oil_in_transport",
    "share_of_total_costs_assigned_to_gas_in_transport",
    "share_of_total_costs_assigned_to_coal_in_transport",
    "share_of_total_costs_assigned_to_nuclear_in_transport",
    "share_of_total_costs_assigned_to_renewables_in_transport",

    "share_of_total_costs_assigned_to_oil_in_agriculture",
    "share_of_total_costs_assigned_to_gas_in_agriculture",
    "share_of_total_costs_assigned_to_coal_in_agriculture",
    "share_of_total_costs_assigned_to_nuclear_in_agriculture",
    "share_of_total_costs_assigned_to_renewables_in_agriculture"
  ]
  
  def intro_page_data
    Rails.cache.fetch("intro_page_data") do
      intro_page_data!
    end
  end

  def intro_page_data!
    data = carrier_costs!
    out = {
      total: {
        amount:     data["mixer_total_costs"],
        coal:       data["share_of_total_costs_assigned_to_coal"],
        gas:        data["share_of_total_costs_assigned_to_gas"],
        oil:        data["share_of_total_costs_assigned_to_oil"],
        nuclear:    data["share_of_total_costs_assigned_to_nuclear"],
        renewables: data["share_of_total_costs_assigned_to_renewables"]
      },
      sectors: {
        buildings: {
          carriers: {}
        },
        industry: {
          carriers: {}
        },
        transport: {
          carriers: {}
        },
        agriculture: {
          carriers: {}
        }
      }
    }

    [:buildings, :industry, :transport, :agriculture].each do |sector|
      [:coal, :gas, :oil, :nuclear, :renewables].each do |carrier|
        out[:sectors][sector][:carriers][carrier] = data["share_of_total_costs_assigned_to_#{carrier}_in_#{sector}"]
      end
      out[:sectors][sector][:total] = out[:sectors][sector][:carriers].values.sum
    end
    out
  rescue
    nil
  end

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
    response = self.class.get("/api_scenarios/new.json")
    # the next ETE release will use id as key
    response["api_scenario"]["id"] || response["api_scenario"]["api_session_key"]
  rescue
    nil
  end
  
  private
  
    def query(gqueries)
        url   = "/api_scenarios/#{api_session_key}.json"
        query = { result: gqueries, reset: 1 }

        response = self.class.get(url, :query => query)
        out = {}
        response["result"].each_pair{|k,v| out[k] = v[0][1]}
        out
      rescue
        nil
    end
end
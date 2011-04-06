require 'net/http'
require 'uri'
require 'json'

class ApiClient
  GQueries = [ 
        "costs_share_of_coal",
        "costs_share_of_gas",
        "costs_share_of_oil",
        "costs_share_of_uranium",
        "costs_share_of_sustainable"
      ]
  
  def current_situation
    @current_situation ||= current_situation!
  end
  
  def current_situation!
    url = APP_CONFIG['api_base_path'] + api_session_key.to_s + ".json"
    uri = URI.parse(url)

    # Silly net/http
    params = ApiClient::GQueries.inject(''){|m, x| m += "result[]=#{x}&" } + "reset=1"
    
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri + "?" + params)
    
    response = http.request(request)    
    data = JSON.parse(response.body)
    out = {}
    data["result"].each_pair{|k,v| out[k] = v[0][1]}
    out
  rescue
    nil
  end
  
  # caching version
  def api_session_key
    @api_session_key ||= api_session_key!
  end
  
  def api_session_key!
    url = APP_CONFIG['api_base_path'] + "new.json"
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)
    data["api_scenario"]["api_session_key"]
  rescue
    nil
  end  
end
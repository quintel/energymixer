class PagesController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
    @questions = Question.ordered.all
    
    # Be careful with this variable!
    @results = {    
      coal: {
       gquery: "costs_share_of_coal",
       unit: "Mln. Euro",
       label: "Coal",
       css_class: "coal"
      },
      gas: {
       gquery: "costs_share_of_gas",
       unit: "Mln. Euro",
       label: "Gas",
       css_class: "gas"
      }, 
      oil: {
       gquery: "costs_share_of_oil",
       unit: "Mln. Euro",
       label: "Oil",
       css_class: "oil"
      },
      nuclear: {
       gquery: "costs_share_of_uranium",
       unit: "Mln. Euro",
       label: "Uranium",
       css_class: "nuclear"
       
      }, 
      renewable: {
       gquery: "costs_share_of_sustainable",
       unit: "Mln. Euro",
       label: "Sustainable",
       css_class: "renewable"       
      }
    }
    
    # This hash keys will be used to create the dashboard items. Mixer.js uses this keys too
    # to perform queries.
    @dashboard_items = [
      { gquery: "co2_emission", label: "CO2 Emissions"},
      { gquery: "share_of_renewable_energy", label: "Share of renewable energy"},
      { gquery: "area_footprint_per_nl", label: "Area Footprint per NL"},
      { gquery: "energy_dependence", label: "Energy Dependence"}
    ]
  end
end

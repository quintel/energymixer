module ScenariosHelper
  # created a json hash with the parameters corresponding to the
  # user selections.
  # This could be rewritten as QuestionsController#index.json
  def answers_json
    out = {}
    Question.all.each do |q|
      q_id = q.id
      out[q_id] = {}
      q.answers.each do |a|
        a_id = a.id
        out[q_id][a_id] = {}
        a.inputs.each do |i|
          out[q_id][a_id][i.slider_id] = i.value
        end
      end
    end
    out.to_json
  end
  
  def answers_conflicts_json
    out = {}
    Answer.all.each do |answer|
      conf_ans_ids = answer.conflicting_answer_ids
      unless conf_ans_ids.empty?
        out[answer.id] = conf_ans_ids
        # now let's update the opposite question
        conf_ans_ids.each do |q|
          out[q] ||= []
          out[q] << answer.id
        end
      end
    end
    out.each_pair{|k,v| v.uniq!}
    out.to_json
  end
  
  # This array is used by mixer.js while querying the engine
  def dashboard_items_json
    DashboardItem.ordered.map(&:gquery).to_json
  end
  
  # As above
  # TODO: cleanup
  def mix_table_json
    Scenario::Results.keys.map{|k| Scenario::Results[k][:gquery]}.to_json
  end
  
  def dashboard_steps_json
    out = {}
    DashboardItem.ordered.each do |i|
      out[i.gquery] = i.steps.split(",").map(&:to_f) rescue []
    end
    out.to_json
  end
  
  def gquery_for_output(i)
    Scenario::Outputs[i]
  end
  
  def dashboard_label_for_output(i)
    DashboardItem.find_by_gquery(gquery_for_output(i)).label rescue nil
  end
  
  def set_class_for_output(i, value)
    gquery = gquery_for_output(i)
    dashboard_item = DashboardItem.find_by_gquery(gquery)
    step = dashboard_item.corresponding_step(value)
    "#{gquery}_step_#{step}"
  rescue
    nil
  end
  
  # Check graph.js for similar method
  def format_dashboard_value(input_id, value)
    gquery = gquery_for_output(input_id)
    case gquery
    when "co2_emission_final_demand_to_1990_in_percent"
      value *= -1
      "#{'+' if value > 0}#{number_with_precision(value * 100, :precision => 2, :separator => ",")}%"
    when "area_footprint_per_nl"
      "#{number_with_precision(value, :precision => 2, :separator => ",")}xNL"
    when "share_of_renewable_energy", "energy_dependence"
      "#{number_with_precision(value * 100, :precision => 2, :separator => ",")}%"
    else
      value
    end
  end
  
  # Accepts as parameter a Scenario object or the id string
  def scenario_in_etm_url(scenario_id)
    scenario_id = scenario_id.etm_scenario_id if scenario_id.is_a?(Scenario)
    "#{APP_CONFIG['view_scenario_path']}#{scenario_id}/load"
  end
  
  def full_text(s)
    out = []
    # Total amount
    out << if s.total_amount < 40_000_000_000
      "De mix is gelukkig goedkoper dan in 2011. We betalen al zo veel aan energie."
    elsif s.total_amount < 60_000_000_000
      "De mix wordt langzaam duurder. Maar als onze economie blijft groeien kunnen we dat wel betalen."
    elsif s.total_amount < 80_000_000_000
      "De mix wordt behoorlijk duurder. Kunnen we dat wel blijven betalen?"
    else
      "De mix wordt veel duurder. Kunnen we dat betalen of groeien we onszelf uit de problemen?"
    end
    
    # CO2
    out << if s.output_5 < -0.25
      "De CO2 van deze mix is erg laag. We zijn goed op weg om de internationale klimaatdoelen te halen."
    elsif s.output_5 < -0.01
      "De CO2 uitstoot neemt af en daardoor leveren we als Nederland een besparing aan de CO2 reductie wereldwijd. Maar is het genoeg?"
    elsif s.output_5 < 0.1
      "De CO2 uitstoot groeit zoals we dat ook in de afgelopen jaren gezien hebben. Maar hoe zit het met de opwarming van de aarde?"
    else
      "De CO2 uitstoot groeit sterk. De economie regeert.  En het klimaat; ach, weten  we wel zeker dat het verandert?"
    end
    
    # Share of renewable energy
    out << if s.output_6 < 0.05
      "We blijven verslaafd aan fossiel en het lukt niet om duurzame energie in te zetten. Misschien is het ook wel niet nodig."
    elsif s.output_6 < 0.1
      "We maken heel langzaam voortgang met het vinden van een betere balans tussen fossiele en duurzame energie, maar hard gaat het niet."
    elsif s.output_6 < 0.14
      "We halen nog steeds de doelen voor duurzame energie die het kabinet in 2011 heeft gezet voor 2020 niet, maar we boeken vooruitgang."
    else
      "De energietransitie begint goed op gang te komen we gaan steeds bewuster om met ons energiegebruik."
    end
    
    # Area footprint
    out << if s.output_7 < 0.71
      "Ons biomassa gebruik is min of meer gelijk aan dat in 2011. Best veel eigenlijk."
    elsif s.output_7 <= 0.91
      "We gaan steeds meer natuur en landbouwgronden inzetten voor de produktie van biomassa."
    else
      "Het gebruik van biomassa groeit sterk. Hoe gaan we de landbouwgronden en natuur vinden om al deze biomassa op te telen?"
    end
    
    # Energy dependence
    out << if s.output_8 < 0.45
      "Terwijl onze eigen aargasreserves opraken lukt het toch goed om de afhankelijkheid van buitenlandse energiebronnen enigszins te beperken."
    elsif s.output_8 < 0.55
      "Onze aardgasreserves raken op en we gaan steeds meer importeren maar de stijging valt nog mee."
    elsif s.output_8 < 0.65
      "Onze aardgasreserves raken op en we gaan steeds meer importeren. De importafhankelijkheid neemt met meer dan 100% toe in 15 jaar."
    else
      "Terwijl onze eigen aardgasreserves krimpen gaan we vrolijk door met produceren en consumeren."
    end
    
    out.map{|x| "<p>#{x}</p>"}.join.html_safe
  end
end

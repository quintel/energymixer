module PagesHelper
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
  
  # This array is used by mixer.js while querying the engine
  def dashboard_items_json
    @dashboard_items.map(&:gquery).to_json
  end
  
  # As above
  def mix_table_json
    @results.keys.map{|k| @results[k][:gquery]}.to_json
  end
  
  def dashboard_steps_json
    out = {}
    @dashboard_items.each do |i|
      out[i.gquery] = i.steps.split(",").map(&:to_f)
    end
    out.to_json
  end
  
  def gquery_for_output(i)
    UserScenario::Outputs[i]
  end
  
  def dashboard_label_for_output(i)
    DashboardItem.find_by_gquery(gquery_for_output(i)).label
  end
  
  def set_class_for_output(i)
    # TODO
    gquery_for_output(i) + "_step_0"
  end
  
  # Check graph.js for similar method
  def format_dashboard_value(input_id, value)
    gquery = gquery_for_output(input_id)
    case gquery
    when "co2_emission_final_demand_to_1990_in_percent"
      "#{'+' if value > 0}#{number_with_precision(value * 100, :precision => 2)}%"
    when "area_footprint_per_nl"
      "#{number_with_precision(value, :precision => 2)}xNL"
    when "share_of_renewable_energy", "energy_dependence"
      "#{number_with_precision(value * 100, :precision => 2)}%"
    else
      value
    end
  end
  
end

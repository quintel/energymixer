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
  def mix_table_json
    @results.keys.map{|k| @results[k][:gquery]}.to_json
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
      "#{'+' if value > 0}#{number_with_precision(value * 100, :precision => 2)}%"
    when "area_footprint_per_nl"
      "#{number_with_precision(value, :precision => 2)}xNL"
    when "share_of_renewable_energy", "energy_dependence"
      "#{number_with_precision(value * 100, :precision => 2)}%"
    else
      value
    end
  end
  
  # Accepts as parameter a Scenario object or the id string
  def scenario_in_etm_url(scenario_id)
    scenario_id = scenario_id.etm_scenario_id if scenario_id.is_a?(Scenario)
    "#{APP_CONFIG['view_scenario_path']}#{scenario_id}/load"
  end
end
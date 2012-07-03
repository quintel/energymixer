module ScenariosHelper
  # created a json hash with the parameters corresponding to the
  # user selections.
  # This could be rewritten as QuestionsController#index.json
  def answers_json
    return false unless @questions
    out = {}
    @questions.each do |q|
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
    return false unless @answers
    out = {}
    @answers.each do |answer|
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
  
  def set_class_for_output(gquery, value)
    dashboard_item = DashboardItem.find_by_gquery(gquery)
    step = dashboard_item.corresponding_step(value)
    "#{gquery}_step_#{step}"
  rescue
    nil
  end
  
  # Check graph.js for similar method
  def format_dashboard_value(gquery, value)
    return if value.nil? #cope with curren values nil on testing server
    case gquery
    when "mixer_reduction_of_co2_emissions_versus_1990"
      "#{'+' if value > 0}#{number_with_precision(value * 100, :precision => 2)}%"
    when "mixer_bio_footprint"
      "#{number_with_precision(value, :precision => 2)}xNL"
    when "mixer_renewability", "mixer_net_energy_import"
      "#{number_with_precision(value * 100, :precision => 2)}%"
    else
      value
    end
  end
  
  # Accepts as parameter a Scenario object or the id string
  def scenario_in_etm_url(scenario_id)
    scenario_id = scenario_id.etm_scenario_id if scenario_id.is_a?(Scenario)
    "#{APP_CONFIG['view_scenario_path']}/#{scenario_id}/load?locale=nl"
  end
    
  def popup_json
    out = {}
    Popup.all.each {|p| out[p.code] = {title: p.title, body: p.body}}
    out.to_json
  end
  
  # On the dashboard we want to know which scenario attribute corresponds to a key
  def output_for_dashboard_item(key)
    gquery = Scenario::DashboardTable[key]
    output = Scenario::Outputs.invert[gquery]
  end
  
  def sortable(scenarios,methode,column, title = nil)
    title ||= column.titleize
    if(methode)
      direction = (column +  " asc" == params[:sort_data]) ? "desc" : "asc"
      link_to title, :sort_data => column + " "+ direction, :id => scenarios.map(&:id)
    else
      direction = (sort_column(column) +  " asc" == params[:sort]) ? "desc" : "asc"
      link_to title, :sort => sort_column(column) + " "+ direction, :id => scenarios.map(&:id)
    end
  end
  
  private 
  
  def sort_column(column)
    Scenario.column_names.include?(column) ? column : "name"
  end
  
end

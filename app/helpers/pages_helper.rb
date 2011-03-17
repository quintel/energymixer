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
  
  def label_for_output(i)
    UserScenario::Outputs[i]
  end
end

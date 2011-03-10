module PagesHelper

  def slider_values
    return {} if @answers.blank?

    @answers.inject({}) do |inputs, answer|
      inputs.update(answer.inputs.slider_values)
    end
  end

  def answers_json
    out = {}
    Question.all.each do |q|
      q_id = "question_#{q.id}"
      out[q_id] = {}
      q.answers.each do |a|
        a_id = "answer_#{a.id}"
        out[q_id][a_id] = {}
        a.inputs.each do |i|
          out[q_id][a_id][i.id] = i.value
        end
      end
    end
    out.to_json
  end

end

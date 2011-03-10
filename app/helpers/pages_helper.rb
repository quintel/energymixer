module PagesHelper

  def slider_values
    return {} if @answers.blank?

    @answers.inject({}) do |inputs, answer|
      inputs.update(answer.inputs.slider_values)
    end
  end

end

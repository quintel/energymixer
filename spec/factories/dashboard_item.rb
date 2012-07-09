FactoryGirl.define do
  factory :dashboard_item do |f|
    f.gquery { generate(:dashboard_gquery) }
    f.label 'label'
    f.steps { "-0.#{ rand(7) + 1 },0.0,0.#{ rand(7) + 1 }" }
    f.association :question_set, factory: :question_set
  end

  sequence(:dashboard_gquery) do |n|
    Scenario::Outputs[:"output_#{ n % 12 }"]
  end
end

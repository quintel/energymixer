FactoryGirl.define do
  factory :dashboard_item do |f|
    f.gquery { generate(:dashboard_gquery) }
    f.label 'label'
    f.steps '-0.5,0.0,0.5'
    f.association :question_set, factory: :question_set
  end

  sequence(:dashboard_gquery) do |n|
    Scenario::Outputs[:"output_#{ n % 12 }"]
  end
end

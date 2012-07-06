Factory.define :dashboard_item do |f|
  f.gquery 'foo'
  f.label 'label'
  f.steps '-0.5,0.0,0.5'
  f.association :question_set, factory: :question_set
end

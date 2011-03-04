Factory.define :answer do |f|
  f.association :question, :factory => :question
  f.sequence(:answer) {|n| "Answer ##{n}"}
  # f.inputs {|i| [i.association(:input), i.association(:input)] }
end
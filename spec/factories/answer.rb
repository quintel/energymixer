Factory.define :answer do |f|
  f.sequence(:answer) {|n| "Answer ##{n}"}
  f.description "lorem ipsum"
  f.inputs {|i| Array.new(3).map{ i.association(:input)} }
end
Factory.define :question do |f|
  f.sequence(:question) {|n| "Question ##{n}"}
  f.answers {|a| [a.association(:answer)] }
end
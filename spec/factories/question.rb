Factory.define :question do |f|
  f.sequence(:question) {|n| "Question ##{n}"}
  f.answers {|a| Array.new(2).map { a.association(:answer) } }
end
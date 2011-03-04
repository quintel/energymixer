Factory.define :input do |f|
  f.sequence(:key) {|n| "input_key_#{n}"}
  f.value 1.23
end
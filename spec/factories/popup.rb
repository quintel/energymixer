Factory.define :popup do |f|
  f.sequence(:code) { |n| "code_#{n}"}
  f.title 'title'
  f.body 'body'
end
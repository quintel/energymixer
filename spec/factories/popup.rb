FactoryGirl.define do
  factory :popup do |f|
    f.sequence(:code) { |n| "code_#{n}"}
    f.title_nl 'title'
    f.body_nl 'body'
    f.title_de 'title'
    f.body_de 'body'
  end
end

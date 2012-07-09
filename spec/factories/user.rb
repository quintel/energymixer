FactoryGirl.define do
  factory :user do |f|
    f.email 'user@quintel.com'
    f.password 'password'
  end
end

Factory.define :user_scenario do |f|
  f.name 'bill clinton'
  f.email 'test@quintel.com'
  f.age 99
  f.featured false
  f.output_0 0.00
  f.output_1 0.00
  f.output_2 0.00
  f.output_3 0.00
  f.output_4 0.00
  f.output_5 0.00
  f.output_6 0.00
  f.output_7 0.00
  f.output_8 0.00
end

Factory.define :featured_user_scenario, :parent => :user_scenario do |f|
  f.featured true
end

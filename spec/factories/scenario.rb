Factory.define :scenario do |f|
  f.title 'scenario title'
  f.name 'bill clinton'
  f.email 'test@quintel.com'
  f.age 99
  f.featured false
  f.public true
  f.output_0 1.00
  f.output_1 1.00
  f.output_2 1.00
  f.output_3 1.00
  f.output_4 1.00
  f.output_5 1.00
  f.output_6 1.00
  f.output_7 1.00
  f.output_8 1.00
  f.output_9 1.00
  f.output_10 1.00
  f.output_11 1.00
  f.output_12 1.00
end

Factory.define :featured_scenario, :parent => :scenario do |f|
  f.featured true
end

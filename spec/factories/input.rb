Factory.define :input do |f|
  f.slider_id { Input::KEYS.keys.sample }
  f.value 1.23
end
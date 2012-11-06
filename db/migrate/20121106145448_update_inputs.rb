class UpdateInputs < ActiveRecord::Migration
  def up
    # query the engine for an updated list
    inputs = Input.available_inputs

    add_column :inputs, :key, :string

    Input.reset_column_information

    Input.find_each do |i|
      if key = inputs[i.slider_id]
        i.key = key
        i.save
      else
        puts "Removing bad input!"
        i.destroy
      end
    end

    remove_column :inputs, :slider_id
  end

  def down
    remove_column :inputs, :key
    add_column :inputs, :slider_id, :integer
  end
end

class SwapAddonHeatPumpForHybrid < ActiveRecord::Migration
  ADDON  = 'households_space_heater_heatpump_add_on_electricity_share'
  HYBRID = 'households_space_heater_hybrid_heatpump_air_water_electrcity_share'

  def up
    Input.where(key: ADDON).update_all(key: HYBRID)
  end

  def down
    Input.where(key: HYBRID).update_all(key: ADDON)
  end
end

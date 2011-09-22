class UpdateOldRecords < ActiveRecord::Migration
  def self.up
    Scenario.all.each do |s|
      total = s.total_amount
      s.update_attribute(:output_12, total)
      [:output_0,:output_1,:output_2,:output_3,:output_4,:output_9,:output_10,:output_11].each do |output|
        old_value = s.send(output)
        next if !old_value || old_value < 1
        new_value = s.send(output) / total rescue 0
        s.update_attribute(output, new_value)
      end
    end

    dashboard = {
      "co2_emission_percent_change_from_1990_corrected_for_electricity_import" => "mixer_co2_reduction_from_1990",
      "share_of_renewable_energy" => "mixer_renewability",
      "area_footprint_per_nl" => "mixer_bio_footprint",
      "energy_dependence" => "mixer_net_energy_import"
    }
    dashboard.each_pair do |o,n|
      i = DashboardItem.find_by_gquery(o)
      i.update_attribute(:gquery, n)
    end
  end

  def self.down
  end
end

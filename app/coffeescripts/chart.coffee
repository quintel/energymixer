class @Chart extends Backbone.View
  initialize: ->
    @dashboard_steps = window.globals.dashboard_steps
  
  # Main entry point.
  # assumes results have been stored
  render: ->
    for own key, value of @model.dashboard_values
      @update_dashboard_item(key, value)
    @.update_bar_chart()
  
  block_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy({img: '/images/spinner.gif'})
    @model.questions.disable_all_question_links();
  
  unblock_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy("clear")
    @model.questions.update_question_links()
  
  # the following methods should not be called directly
  # You might only have to update the format_dashboard_value method
  update_dashboard_item: (key, value) ->
    formatted_value = @format_dashboard_value key, value
    dashboard_item = $ ".dashboard_item##{key}"
    dashboard_item.find(".value").html formatted_value
    
    # Decide which image to show as background.    
    # since we're doing everything through css classes, let's remove
    # the existing background-related classes
    gauge_icon = dashboard_item.find '.gauge_icon'
    gauge_icon.removeClass "#{key}_step_#{i}" for i in [ 0..10 ]
    
    # Find the right step
    step = @find_step_for_dashboard_item key, value
    gauge_icon.addClass "#{key}_step_#{step}"
  
  find_step_for_dashboard_item: (key, value) ->
    # see DashboardItem#corresponding_step
    steps = @dashboard_steps[key];
    step = 0;
    for i in steps
      step += 1 if (value > i)
    return step
  
  # it would be nice to define these formats in the controller but the
  # code would become a nightmare
  # This formatter has a ruby equivalent as a view helper
  format_dashboard_value: (key, value) ->
    out = ""
    switch key
      when "mixer_reduction_of_co2_emissions_versus_1990"
        out = "+" if (value > 0) 
        out += sprintf("%.1f", value * 100) + "%"
      when "mixer_bio_footprint"
        out = sprintf("%.2f", value) + "xNL"
      when "mixer_renewability", "mixer_net_energy_import"
        out = sprintf("%.1f", value * 100) + "%"
      else
        out = value
    return out
  
  # TODO: DRY  
  update_bar_chart: ->
    current_sum = @model.gquery_results["mixer_total_costs"]
    charts_to_be_updated = $(".charts_container").not('.static')
    
    # main chart
    chart_max_height = 360
    max_amount = globals.chart_max_amount
    current_chart_height = Math.sqrt(current_sum / max_amount) * chart_max_height
    for own code, gquery of @model.gqueries.primary
      ratio = @model.gquery_results[gquery]
      new_height = ratio * current_chart_height
      item = charts_to_be_updated.find("li.#{code}")
      item.animate({"height": new_height}, "slow")
      # update the legend
      percentage = Math.round(ratio * 100)
      selector = $ ".legend tr.#{code} td.value"
      selector.html("#{percentage}%")
    
    # renewable subchart
    chart_max_height = 160
    total_renewables_ratio = @model.gquery_results.mixer_renewability
    for own code, gquery of @model.gqueries.secondary
      ratio = @model.gquery_results[gquery]
      new_height = Math.round(ratio / total_renewables_ratio * chart_max_height)
      item = charts_to_be_updated.find("ul.chart .#{code}")
      item.animate({"height": new_height}, "slow")
      # legend
      percentage = Math.round(ratio * 100)
      selector = $ ".legend tr.#{code} td.value"
      selector.html("#{percentage}%")
    
    # and top counter
    $(".chart header span.total_amount").html(sprintf("%.1f" ,current_sum / 1000000000))
    
    this.unblock_interface()
  
  update_etm_link: (url) ->
    $("footer a").click (e) =>
      if(confirm(window.globals.open_in_etm_link))
        $(e.target).attr("href", url)

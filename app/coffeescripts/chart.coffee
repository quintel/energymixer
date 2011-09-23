class @Chart
  constructor: (app) ->
    @app = app
    @dashboard_steps = window.globals.dashboard_steps
    @mixer = @app.mixer
  
  # Main entry point.
  # assumes results have been stored
  refresh: ->
    for own key, value of @mixer.dashboard_values
      this.update_dashboard_item(key, value)
    this.update_bar_chart()
  
  block_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy({img: '/images/spinner.gif'})
    @app.questions.disable_all_question_links();
  
  unblock_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy("clear")
    @app.questions.update_question_links()
  
  # the following methods should not be called directly
  # You might only have to update the format_dashboard_value method
  update_dashboard_item: (key, value) ->
    dashboard_selector = ".dashboard_item##{key}"
    formatted_value = this.format_dashboard_value(key, value)
    $("#{dashboard_selector} .value").html(formatted_value)
    
    # Decide which image to show as background.
    # Find the right step first.
    step = this.find_step_for_dashboard_item(key, value)
    
    # since we're doing everything through css classes, let's remove
    # the existing background-related classes
    classes_to_remove = '' # FIXME: ugly
    for i in [0..10]
      classes_to_remove += "#{key}_step_#{i} "
    class_to_add = "#{key}_step_#{step}"
    $("#{dashboard_selector} .gauge_icon").removeClass(classes_to_remove).addClass(class_to_add)
  
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
      when "mixer_co2_reduction_from_1990"
        out = "+" if (value > 0) 
        out += sprintf("%.1f", value * 100) + "%"
      when "mixer_bio_footprint"
        out = sprintf("%.2f", value) + "xNL"
      when "mixer_renewability", "mixer_net_energy_import"
        out = sprintf("%.1f", value * 100) + "%"
      else
        out = value
    return out
  
  # If we want to use a log function or a different scale
  transform_height: (x) ->
    return 0 if x <= 0
    Math.round(Math.log(x) * 20)
  
  # TODO: refactor
  update_bar_chart: ->
    current_sum = @mixer.gquery_results["mixer_total_costs"]
    charts_to_be_updated = $(".charts_container").not('.static')
    
    # update the score attribute.
    # DEBT: move to score exclusive method
    @app.score.values.mixer_total_costs.current = current_sum
    if (@app.questions.current_question == 2 && @app.score.values.mixer_total_costs.mark == null)
      @app.score.values.mixer_total_costs.mark = current_sum

    # main chart
    chart_max_height = 360
    max_amount = globals.chart_max_amount
    current_chart_height = current_sum / max_amount * chart_max_height
    for own code, ratio of @mixer.carriers_values
      new_height = this.transform_height(ratio * current_chart_height)
      item = charts_to_be_updated.find("li.#{code}")
      item.animate({"height": new_height}, "slow")
      # update the legend
      percentage = Math.round(ratio * 100)
      selector = ".legend tr.#{code} td.value"
      $(selector).html("#{percentage}%")
    
    # renewable subchart
    chart_max_height = 160
    total_renewables_ratio = @app.mixer.gquery_results.mixer_renewability
    for own code, ratio of @app.mixer.secondary_carriers_values
      new_height = Math.round(ratio / total_renewables_ratio * chart_max_height)
      item = charts_to_be_updated.find("ul.chart .#{code}")
      item.animate({"height": new_height}, "slow")
      # legend
      percentage = Math.round(ratio * 100)
      selector = ".legend tr.#{code} td.value"
      $(selector).html("#{percentage}%")

    
    # and top counter
    $(".chart header span.total_amount").html(sprintf("%.1f" ,current_sum / 1000000000))
    
    this.unblock_interface()
  
  update_etm_link: (url) ->
    $("footer a").click (e) =>
      if(confirm("Wil je meteen de gekozen instellingen zien in het Energietransitiemodel? (zo nee, dan ga je naar de homepage van het Energietransitiemodel)"))
        $(e.target).attr("href", url)

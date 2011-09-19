class @Chart
  constructor: (app) ->
    @app = app
    @dashboard_steps = window.globals.dashboard_steps
    @mixer = @app.mixer
  
  # Main entry point.
  # assumes results have been stored
  refresh: ->
    # dashboard items
    for own key, value of @mixer.dashboard_values
      this.update_dashboard_item(key, value)
    # colourful animated bar
    this.update_bar_chart()
  
  block_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy({img: '/images/spinner.gif'})
    @app.questions.hide_all_question_links();
  
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
    $(dashboard_selector).removeClass(classes_to_remove).addClass(class_to_add)
  
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
      when "co2_emission_percent_change_from_1990_corrected_for_electricity_import"
        out = "+" if (value > 0) 
        out += sprintf("%.1f", value * 100) + "%"
      when "area_footprint_per_nl"
        out = sprintf("%.2f", value) + "xNL"
      when "share_of_renewable_energy", "energy_dependence"
        out = sprintf("%.1f", value * 100) + "%"
      else
        out = value
    return out
  
  # TODO: refactor
  update_bar_chart: ->
    current_sum = @mixer.gquery_results["policy_total_energy_cost"] * 1000
    
    # update the score attribute. DEBT: move to score exclusive method
    @app.score.values.total_amount.current = current_sum
    if (@app.questions.current_question == 2 && @app.score.values.total_amount.mark == null)
      @app.score.values.total_amount.mark = current_sum

    # main chart
    chart_max_height     = 390
    max_amount           = globals.chart_max_amount / 1000000 # million euros
    current_chart_height = current_sum / max_amount * chart_max_height
    rounded_sum          = 0
    for own code, val of @mixer.carriers_values
      new_height = Math.round(val / current_sum * current_chart_height)
      rounded_sum += new_height
      active_charts = $("ul.chart").not('.static')
      item = active_charts.find(".#{code}")
      # selector = "ul.chart .#{code}"
      item.animate({"height": new_height}, "slow")
      # hide text if there's no room
      label = item.find(".label")
      if (new_height > 10) then label.show() else label.hide()
      # update the legend
      percentage = Math.round(val / current_sum * 100)
      selector = ".legend tr.#{code} td.value"
      $(selector).html("#{percentage}%")

    
    # renewable subchart
    renewable_subchart_height = 100
    total_renewable_amount = @app.mixer.carriers_values.costs_share_of_sustainable
    for own code, val of @app.mixer.secondary_carriers_values
      new_height = Math.round(val / total_renewable_amount * renewable_subchart_height)
      selector = "ul.chart .#{code}"
      $(selector).animate({"height": new_height}, "slow")
      label = $("#{selector} .label")
      if (new_height > 5) then label.show() else label.hide()
    
    # update money column
    new_money_height = rounded_sum + 4 * 2 # margin between layers
    $(".user_created .money").animate({"height" : new_money_height}, "slow")
    
    # and top counter
    $(".chart header span.total_amount").html(sprintf("%.1f" ,current_sum / 1000))
    
    this.unblock_interface()
  
  update_etm_link: (url) ->
    $("footer a").click (e) =>
      if(confirm("Wilt u meteen de gekozen instellingen zien in het Energietransitiemodel? (zo nee, dan gaat u naar de homepage van het Energietransitiemodel)"))
        $(e.target).attr("href", url)

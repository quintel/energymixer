class @Graph
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
    $("#dashboard .dashboard_item .value, .user_created .total_amount, #carriers").busy({img: '/images/spinner.gif'})
    @app.questions.hide_all_question_links();
  
  unblock_interface: ->
    $("#dashboard .dashboard_item .value, .user_created .total_amount, #carriers").busy("clear")
    @app.questions.update_question_links()
    
  # the following methods should not be called directly
  # You might only have to update the format_dashboard_value method
  update_dashboard_item: (key, value) ->
    dashboard_selector = "#dashboard ." + key
    formatted_value = this.format_dashboard_value(key, value)
    $(dashboard_selector + " .value").html(formatted_value)
    # we have now to decide which image to show as background
    # let's first find the right step
    step = this.find_step_for_dashboard_item(key, value)
    # since we're doing everything through css classes, let's remove
    # the existing background-related classes
    classes_to_remove = '' # FIXME: ugly
    for i in [0..10]
      classes_to_remove += key + "_step_" + i + " "
    class_to_add = key + "_step_" + step
    $(dashboard_selector).removeClass(classes_to_remove).addClass(class_to_add)
  
  find_step_for_dashboard_item: (key, value) ->
    # see DashboardItem#corresponding_step
    steps = @dashboard_steps[key];
    step = 0;
    for i in steps
      step = (parseInt(i) + 1) if(value > steps[i])
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

    # main graph
    graph_max_height     = 390
    max_amount           = globals.graph_max_amount / 1000000 # million euros
    current_graph_height = current_sum / max_amount * graph_max_height
    rounded_sum          = 0
    for own code, val of @mixer.carriers_values
      new_height = Math.round(val / current_sum * current_graph_height)
      rounded_sum += new_height
      selector = ".user_created ." + code
      $(selector).animate({"height": new_height}, "slow")
      # hide text if there's no room
      label = $(selector + " .label")
      if (new_height > 10) then label.show() else label.hide()
    
    # renewable subgraph
    renewable_subgraph_height = 100
    total_renewable_amount = @app.mixer.carriers_values.costs_share_of_sustainable
    for own code, val of @app.mixer.secondary_carriers_values
      new_height = Math.round(val / total_renewable_amount * renewable_subgraph_height)
      selector = ".user_created ." + code
      $(selector).animate({"height": new_height}, "slow")
      label = $(selector + " .label")
      if (new_height > 5) then label.show() else label.hide()
    
    # update money column
    new_money_height = rounded_sum + 4 * 2 # margin between layers
    $(".user_created .money").animate({"height" : new_money_height}, "slow")
    
    # and top counter
    $(".user_created .total_amount span").html(sprintf("%.1f" ,current_sum / 1000))
    
    this.unblock_interface()
  
  update_etm_link: ->
    $("footer a").click ->
      if(confirm("Wilt u meteen de gekozen instellingen zien in het Energietransitiemodel? (zo nee, dan gaat u naar de homepage van het Energietransitiemodel)"))
        $(this).attr("href", @mixer.etm_scenario_url)

class @Chart extends Backbone.View
  initialize: ->
    @dashboard_steps = globals.chart.dashboard_steps

  # Main entry point.
  # assumes results have been stored
  render: ->
    for own label, gquery of @model.gqueries.dashboard
      @update_dashboard_item(gquery, @model.gquery_results[gquery])
    @update_bar_chart()

  block_interface: ->
    $(".dashboard_item .value, .chart header, #carriers").busy({img: '/assets/spinner.gif'})
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
    if step = @find_step_for_dashboard_item key, value
      gauge_icon.addClass "#{key}_step_#{step}"

  find_step_for_dashboard_item: (key, value) ->
    # see DashboardItem#corresponding_step
    if steps = @dashboard_steps[key]
      step = 0
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
        out += "#{(value * 100).toFixed(1)}%"
      when "mixer_bio_footprint"
        out = "#{value.toFixed(2)}xNL"
      when "mixer_renewability", "mixer_net_energy_import"
        out = "#{(value * 100).toFixed(1)}%"
      else
        out = value
    return out

  update_bar_chart: =>
    current_sum = @model.gquery_results["mixer_total_costs"]

    # main chart
    chart_max_height = 360
    max_amount = globals.chart.max_amount
    current_chart_height = Math.sqrt(current_sum / max_amount) * chart_max_height
    for code, gquery of @model.gqueries.primary
      ratio = @model.gquery_results[gquery]
      new_height = ratio * current_chart_height
      @_animate_chart_item(code, new_height)
      @_update_legend_item(code, ratio)

    # renewable subchart
    chart_max_height = 160
    total_renewables_ratio = @model.gquery_results.mixer_renewability
    for code, gquery of @model.gqueries.secondary
      ratio = @model.gquery_results[gquery]
      new_height = Math.round(ratio / total_renewables_ratio * chart_max_height)
      @_animate_chart_item(code, new_height)
      @_update_legend_item(code, ratio)

    # and top counter. IE8 doesn't always update it or does it with a 10 sec
    # delay. Don't ask me why.
    tot = (current_sum / 1000000000).toFixed(1)
    $("header .total_amount").html(tot)

    @unblock_interface()

  _animate_chart_item: (code, height) ->
    charts_to_be_updated = $(".charts_container").not('.static')
    item = charts_to_be_updated.find("ul.chart .#{code}")
    item.animate({"height": height}, "slow")

  _update_legend_item: (code, ratio) ->
    percentage = Math.round(ratio * 100)
    selector = $ ".legend tr.#{code} td.value"
    selector.html("#{percentage}%")

  update_etm_link: (url) ->
    $("footer a.open_in_etm").click (e) =>
      if(confirm(window.globals.open_in_etm_link))
        $(e.target).attr("href", url)

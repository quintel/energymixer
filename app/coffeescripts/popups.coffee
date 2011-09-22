$ ->
  $("ul.chart li.renewable").hover(
    () -> $(this).parents(".charts_container").find(".renewables_float").show()
    ,
    () -> $(".renewables_float").hide()
  )

  # when the user clicks on the i icon on the dashboard
  $(".full_chart .dashboard_item .info_icon").click ->
    key = $(this).parent().attr('id')
    $(this).parents(".full_chart").find("#dashboard_popups .#{key}").toggle()
  $(".full_chart #dashboard_popups a.close_popup").click ->
    $(this).parent().hide()

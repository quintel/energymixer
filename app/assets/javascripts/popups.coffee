$ ->
  # blockUI options
  $.blockUI.defaults.overlayCSS.backgroundColor = "#ffffff"
  $.blockUI.defaults.overlayCSS.opacity = 0.6
  $.blockUI.defaults.baseZ = 500
  $.blockUI.defaults.message = null

  $("ul.chart li.renewables").hover(
    () -> $(this).parents(".charts_container").find(".renewables_float").show()
    ,
    () -> $(".renewables_float").hide()
  )

  #the user needs to be able to close the popup when he's using a touchscreen (iPad, iPhone, etc)
  $(".renewables_float").click ->
    $(this).hide()

  # when the user clicks on the i icon on the dashboard
  $(".full_chart .dashboard_item .info_icon").click (e) ->
    popup = $(this).parent().find(".popup").show()
    $(this).closest(".full_chart").block()
    e.preventDefault()

  $(".full_chart .dashboard_item .popup").click ->
    $(this).closest(".full_chart").unblock()
    $(this).hide()

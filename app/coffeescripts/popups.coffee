$ ->
  $("ul.chart li.renewables").hover(
    () -> $(this).parents(".charts_container").find(".renewables_float").show()
    ,
    () -> $(".renewables_float").hide()
  )
  
  #the user needs to be able to close the popup when he's using a touchscreen (iPad, iPhone, etc)
  $(".renewables_float").click( 
    () -> $(this).hide()
  )

  # when the user clicks on the i icon on the dashboard
  $(".full_chart .dashboard_item .info_icon").click ->
    popup = $(this).parent().find(".popup").toggle()
    $(this).closest(".full_chart").block({ overlayCSS: { backgroundColor: "#fff", opacity: 0.6}, baseZ: 900, message: null})
  $(".full_chart .dashboard_item a.close_popup").click ->
    $(this).parent().hide()
    $(this).closest(".full_chart").unblock()

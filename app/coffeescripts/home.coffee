class Home extends Backbone.Model
  initialize: ->
    @shares = window.globals.carriers

  price: =>
    current_sector = this.get("current_sector")
    if current_sector
      amount = @shares.sectors[current_sector].total * @shares.total.amount
    else
      amount = @shares.total.amount
    sprintf("%.1f", amount / 1000000000)

class HomeView extends Backbone.View
  initialize: ->
    @current_sector = false
    @max_height = 360
    @model = new Home()
    @model.bind("change:current_sector", @render)
    @render()

  model: Home
  
  el: "#map"
  
  events:
    "click #sector_icons a.description"     : "show_information"
    "mouseover #sector_links .sector a": "update_current_sector"
    "mouseover #sector_icons .sector"  : "update_current_sector"
    "mouseout #sector_links .sector a" : "reset_current_sector"
    "mouseout #sector_icons .sector"   : "reset_current_sector"

  render: =>
    sector_id = @model.get("current_sector")

    # popups
    if sector_id
      popup = $("#sector_icons .sector[rel=#{sector_id}] .popup")
      popup.show()
    else
      $(".popup").hide()
    
    # price
    $("#chart header span.amount").html @model.price()
    
    return @el
    
  show_information: (e) =>
    console.log "Yo"
    e.preventDefault()
    container = $(e.target).parent()
    container.find(".text").toggle()
    $(e.target).toggleClass("close_description")

  # _update_chart: ->
  #   if @current_sector
  #     ratios = @shares.sectors[@current_sector].carriers
  #   else
  #     ratios = @shares.total
  #   for own carrier, ratio of ratios
  #     new_height = @max_height * ratio
  #     carrier_li = $("ul.chart").find(".#{carrier}")
  #     carrier_li.stop(true).animate({"height": new_height}, 500)
  # 
  # _update_percentages: ->
  #   if @current_sector
  #     ratios = @shares.sectors[@current_sector].carriers
  #   else
  #     ratios = @shares.total
  #   for own carrier, ratio of ratios
  #     value = Math.round(ratio * 100)
  #     $("#chart tr.#{carrier} .value").html("#{value}%")
  # 
  # reset_map: ->
  #   @current_sector = false
  #   @update_map()
  # 
  # update_map: ->
  #   @_update_price()
  #   @_update_chart()
  #   @_update_percentages()
  
  reset_current_sector: =>
    @model.set({'current_sector': false})

  update_current_sector: (e) =>
    sector_id = $(e.target).attr("rel")
    @model.set({current_sector: sector_id})
  

$ ->
  window.h = new HomeView()

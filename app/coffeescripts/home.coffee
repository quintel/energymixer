class Home
  constructor: ->
    @shares = globals.carriers
    this._save_original_height()
    this.setup_callbacks()
  
  reset_carriers: ->
    this.update_carriers('total', 1000)
  
  update_carriers: (key, speed) ->
    speed = 350 if(typeof(speed) == "undefined")
    this._update_carriers(@shares[key], speed)
  
  _update_carriers: (carrier_values, speed) ->
    total_amount = 0
    money_bar_height = 0
    for own carrier, value of carrier_values
      total_amount += value
      original_height = @original_height[carrier]
      new_height = Math.round(value / @shares["total"][carrier] * original_height)
      
      carrier_li = $("ul.chart").find(".#{carrier}")
      carrier_li.stop(true).animate({"height": new_height}, speed)
      label = carrier_li.find(".label")
      if new_height > 11 then label.show() else label.hide()
      money_bar_height += new_height
    
    formatted_amount = sprintf("%.1f", total_amount / 1000000000)
    $(".total_amount span").html(formatted_amount)
    $("ul.chart li.money").stop(true).animate({"height": money_bar_height + 8}, speed)
  
  _save_original_height: ->
    @original_height =
      coal:      $("ul.chart li.coal").height()
      gas:       $("ul.chart li.gas").height()
      oil:       $("ul.chart li.oil").height()
      nuclear:   $("ul.chart li.nuclear").height()
      renewable: $("ul.chart li.renewable").height()
  
  setup_callbacks: ->
    $("#sectors .sector").hover(
      (e) => 
        sector_id = $(e.target).parent().attr("id")
        this.update_carriers(sector_id)
      ,
      () => this.reset_carriers()
    )

    $("#sector_icons .sector").hover(
      () ->
        $(this).find(".popup").show()
      ,
      () ->
        $(this).find(".popup").hide()
    )

    $("#sector_icons a").click (e) ->
      e.preventDefault()
      container = $(this).parent()
      container.find(".text").toggle()
      $(this).toggleClass("close_description")

$ ->
  h = new Home

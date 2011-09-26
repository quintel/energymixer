class Home
  constructor: ->
    @current_sector = false
    @max_height = 360
    @shares = globals.carriers
    this.setup_callbacks()
  
  _update_price: ->
    if @current_sector
      amount = @shares.sectors[@current_sector].total * @shares.total.amount
    else
      amount = @shares.total.amount
    formatted_amount = sprintf("%.1f", amount / 1000000000)
    $("#chart header span.amount").html(formatted_amount)


  _update_chart: ->
    if @current_sector
      ratios = @shares.sectors[@current_sector].carriers
    else
      ratios = @shares.total
    for own carrier, ratio of ratios
      new_height = @max_height * ratio
      carrier_li = $("ul.chart").find(".#{carrier}")
      carrier_li.stop(true).animate({"height": new_height}, 500)

  reset_map: ->
    @current_sector = false
    this.update_map()

  update_map: ->
    this._update_price()
    this._update_chart()

  setup_callbacks: ->
    $("#sector_links .sector a, #sector_icons .sector").hover(
      (e) =>
        sector_id = $(e.target).attr("rel")
        popup = $("#sector_icons .sector[rel=#{sector_id}] .popup")
        popup.show()
        @current_sector = sector_id
        this.update_map()
      ,
      (e) =>
        $(".popup").hide()
        this.reset_map()
    )
        
    $("#sector_icons a").click (e) =>
      e.preventDefault()
      container = $(e.target).parent()
      container.find(".text").toggle()
      $(e.target).toggleClass("close_description")

$ ->
  h = new Home

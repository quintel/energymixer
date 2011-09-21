class Home
  constructor: ->
    @shares = globals.carriers
    this._save_original_height()
    this.setup_callbacks()
  
  # reset_carriers: ->
  #   this.update_carriers('total', 1000)
  #
  # update_carriers: (key, speed) ->
  #   speed = 350 if(typeof(speed) == "undefined")
  #   this._update_carriers(@shares[key], speed)
  #
  # _update_carriers: (carrier_values, speed) ->
  #   total_amount = @shares.total.amount
    

    # for own carrier, value of carrier_values
    #   total_amount += value
    #   original_height = @original_height[carrier]
    #   new_height = Math.round(value / @shares["total"][carrier] * original_height)
    #
    #   carrier_li = $("ul.chart").find(".#{carrier}")
    #   carrier_li.stop(true).animate({"height": new_height}, speed)
    #
    # formatted_amount = sprintf("%.1f", total_amount / 1000000000)
    # $("#chart header span.amount").html(formatted_amount)
  
  _save_original_height: ->
    @original_height =
      coal:      $("ul.chart li.coal").height()
      gas:       $("ul.chart li.gas").height()
      oil:       $("ul.chart li.oil").height()
      nuclear:   $("ul.chart li.nuclear").height()
      renewable: $("ul.chart li.renewable").height()
  
  _set_price: (x) ->
    formatted_amount = sprintf("%.1f", x / 1000000000)
    $("#chart header span.amount").html(formatted_amount)


  update_price: ->
    amount = @shares.sectors[@current_sector].total * @shares.total.amount
    this._set_price(amount)

  update_chart: ->
    for own carrier, ratio of @shares.sectors[@current_sector].carriers
      console.log "#{carrier}: #{ratio}"
      new_height = @original_height[@current_sector] * ratio / 1
      carrier_li = $("ul.chart").find(".#{carrier}")
      carrier_li.stop(true).animate({"height": new_height}, 500)


  reset_map: ->
    @current_sector = null
    this._set_price(@shares.total.amount)

  update_map: ->
    this.update_price()
    this.update_chart()

  setup_callbacks: ->
    $("#sector_links .sector").hover(
      (e) => 
        sector_id = $(e.target).parent().attr("id")
        @current_sector = sector_id
        this.update_map()
      ,
      () => this.reset_map()
    )

    $("#sector_icons .sector").hover(
      (e) =>
        $(e.target).find(".popup").show()
        sector_id = $(e.target).attr("id")
        @current_sector = sector_id
        this.update_map()
      ,
      (e) =>
        $(".popup").hide()
        this.reset_map()
    )

    $("#sector_icons a").click (e) ->
      e.preventDefault()
      container = $(this).parent()
      container.find(".text").toggle()
      $(this).toggleClass("close_description")

$ ->
  h = new Home

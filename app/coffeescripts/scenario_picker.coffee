class ScenarioPicker
  constructor: ->
    this.setup_callbacks()
  
  setup_callbacks: ->
    # let's deal with the back button
    $(".selectable .scenario input").attr("checked", false)
    $("#selected .scenario input").attr("checked", true)
    
    # adding an element
    $(".selectable .scenario input").live 'change', (e) =>
      if this.selected_scenarios_count() >= 2
        $(e.target).attr('checked', false)
        alert("Je kunt maximaal 2 scenario's kiezen")
        return false
      $(e.target).attr('checked', true)
      element = $(e.target).closest("div.scenario")    
      # name = element.find(".name a").html()
      # $("#selected .compared").append(" " + name)
      element.appendTo("#selected_scenarios")
      
      element.find(".actions").hide()
      element.find(".remove_from_list").show()
      this.update_submit_link()
      
    # user must be able to remove a scenario, too
    $(".scenario .remove_from_list a").live 'click', (e) =>
      item = $(e.target).parents(".scenario")
      item.find(".actions").show()
      item.find(".remove_from_list").hide()
      item.find("input").attr('checked', false)
      item.appendTo('#user_scenarios')
      this.update_submit_link()
    
    # the new interface isn't using this anymore
    $("#compare_with_user_scenario").change (e) =>
      if this.selected_scenarios_count() >= 1
        $(e.target).attr('checked', false)
        alert("Je kunt maximaal 1 scenario's kiezen")
        return false
    
    $("a.submit_form").click (e) =>
      e.preventDefault()
      if this.selected_scenarios_count() == 2
        $("section#select form").submit()
    
    $("body").ajaxStart ->
      $("#user_scenarios").busy({img: '/images/spinner.gif'})    
  
  selected_scenarios_count: ->
    $("#selected_scenarios input:checked").length
  
  update_submit_link: ->
    if this.selected_scenarios_count() < 2
      $("a.submit_form").removeClass('enabled').addClass('disabled')
    else
      $("a.submit_form").removeClass('disabled').addClass('enabled')
  
$ ->
  new ScenarioPicker()

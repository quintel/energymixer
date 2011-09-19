$ ->
  # let's deal with the back button
  $(".selectable .scenario input").attr("checked", false)
  $("#selected .scenario input").attr("checked", true)
  
  # adding an element
  $(".selectable .scenario input").live 'change', ->
    if $("#selected_scenarios input:checked").length >= 2
      $(this).attr('checked', false)
      alert("Je kunt maximaal 2 scenario's kiezen")
      return false
    $(this).attr('checked', true)
    element = $(this).closest("div.scenario")    
    # name = element.find(".name a").html()
    # $("#selected .compared").append(" " + name)
    element.appendTo("#selected_scenarios")
    
    element.find(".actions").hide()
    element.find(".remove_from_list").show()
  
  # user must be able to remove a scenario, too
  $(".scenario .remove_from_list a").live 'click', ->
    item = $(this).parents(".scenario")
    item.find(".actions").show()
    item.find(".remove_from_list").hide()
    item.find("input").attr('checked', false)
    item.appendTo('#user_scenarios')
  
  $("#compare_with_user_scenario").change ->
    if($("#selected input:checked").length >= 1)
      $(this).attr('checked', false)
      alert("Je kunt maximaal 1 scenario's kiezen")
      return false
  
  $("a.submit_form").click (e) ->
    e.preventDefault()
    $("section#select form").submit()
  
  $("body").ajaxStart ->
    $("#user_scenarios").busy({img: '/images/spinner.gif'})
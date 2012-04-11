class ScenarioPicker extends Backbone.View
  el: 'body'
  
  initialize: ->
    @render()
  
  events:
    'change .selectable .scenario input'  : 'add_element'
    'click .scenario .remove_from_list a' : 'remove_element'
    'click a.submit_form'                 : 'submit_form'
    'click a.scenario_tab_picker'         : 'select_tab'
  
  render: =>
    # bootstrap
    $("body").ajaxStart -> $("#user_scenarios").busy({img: '/images/spinner.gif'})
  
    # let's deal with the back button
    $(".selectable .scenario input").attr("checked", false)
    $("#selected .scenario input").attr("checked", true)
  
  add_element: (e) =>  
    if @_selected_scenarios_count() >= 2
      $(e.target).attr('checked', false)
      alert("Je kunt maximaal 2 scenario's kiezen")
      return false
    $(e.target).attr('checked', true)
    element = $(e.target).closest("div.scenario")
    element.appendTo("#selected_scenarios")
    element.find(".actions").hide()
    element.find(".remove_from_list").show()
    @_update_submit_link()
  
  remove_element: (e) =>
    item = $(e.target).parents(".scenario")
    item.find(".actions").show()
    item.find(".remove_from_list").hide()
    item.find("input").attr('checked', false)
    item.appendTo('#user_scenarios')
    @_update_submit_link()
  
  submit_form: (e) =>
    e.preventDefault()
    $("section#select form").submit() if @_selected_scenarios_count() == 2
  
  select_tab: (e) =>
    e.preventDefault()
    tab_selector = $(e.target).attr('href')
    $("a.scenario_tab_picker").removeClass('active')
    $(e.target).addClass('active')
    $(".tab").hide()
    $(tab_selector).parent().show()
  
  _selected_scenarios_count: ->
    $("#selected_scenarios input:checked").length
  
  _update_submit_link: ->
    if @_selected_scenarios_count() < 2
      $("a.submit_form").removeClass('enabled').addClass('disabled')
    else
      $("a.submit_form").removeClass('disabled').addClass('enabled')
  
$ ->
  new ScenarioPicker()

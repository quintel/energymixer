$ ->
  $("ul.answers li label").on 'click', (e) ->
    $target = $(e.target).parents('li.answer')
    $target.find('input[type=radio]').prop('checked', true)
    app.questions.select_answer(e)

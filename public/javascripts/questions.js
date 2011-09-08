/* DO NOT MODIFY. This file was compiled Thu, 08 Sep 2011 15:06:31 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/questions.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty;
  this.Questions = (function() {
    function Questions(app) {
      this.app = app;
      this.current_question = 1;
      if ($(".field_with_errors").length > 0) {
        this.current_question = this.count_questions();
      } else {
        this.current_question = 1;
      }
      this.setup_callbacks();
      this.show_right_question();
      this.clear_the_form();
    }
    Questions.prototype.current_question_was_answered = function() {
      var answer, question_id;
      question_id = "#question_" + this.current_question;
      answer = $(question_id).find("input:checked");
      return answer.length > 0;
    };
    Questions.prototype.count_questions = function() {
      this.num_questions = this.num_questions || $(".question").size();
      return this.num_questions;
    };
    Questions.prototype.currently_selected_answers = function() {
      var answers;
      answers = [];
      $(".answers .active input[type=radio]").each(function() {
        return answers.push(parseInt($(this).val()));
      });
      return answers;
    };
    Questions.prototype.get_question_id_from_answer = function(answer_id) {
      this.answers2questions = {};
      $("div.question input:checked").each(function(el) {
        return this.answers2questions[$(this).val()] = $(this).data('question_number');
      });
      return this.answers2questions[answer_id];
    };
    Questions.prototype.check_conflicts = function() {
      var conflicting_questions, conflicts, text;
      conflicts = false;
      conflicting_questions = [];
      $.each(this.currently_selected_answers(), __bind(function(index, current_answer_id) {
        var conflicting_answer_id;
        if ((conflicting_answer_id = this.check_conflicting_answer(current_answer_id))) {
          conflicts = true;
          conflicting_questions.push(this.get_question_id_from_answer(current_answer_id));
          return conflicting_questions.push(this.get_question_id_from_answer(conflicting_answer_id));
        }
      }, this));
      if (conflicts) {
        text = unique(conflicting_questions).join(" en ");
        $("#questions #notice .conflicting_questions").html(text);
        return $("#questions #notice").show();
      } else {
        return $("#questions #notice").hide();
      }
    };
    Questions.prototype.check_conflicting_answer = function(selected_answer_id) {
      var answer_id, conflict, conflicting_answers, currently_selected_answers, index;
      conflict = false;
      currently_selected_answers = this.currently_selected_answers();
      for (index in currently_selected_answers) {
        if (!__hasProp.call(currently_selected_answers, index)) continue;
        answer_id = currently_selected_answers[index];
        conflicting_answers = globals.answers_conflicts[answer_id] || [];
        if ($.inArray(parseInt(selected_answer_id), conflicting_answers) !== -1) {
          conflict = selected_answer_id;
        }
      }
      return conflict;
    };
    Questions.prototype.hide_all_question_links = function() {
      $("#previous_question").hide();
      return $("#nex_question").hide();
    };
    Questions.prototype.update_question_links = function() {
      var first_question, last_question;
      first_question = this.current_question === 1;
      last_question = this.current_question === this.count_questions();
      if (first_question) {
        $("#previous_question").hide();
      } else {
        $("#previous_question").show();
        if (last_question) {
          $("#next_question").hide();
        }
      }
      if (this.current_question_was_answered() && !last_question) {
        return $("#next_question").show();
      } else {
        return $("#next_question").hide();
      }
    };
    Questions.prototype.show_right_question = function() {
      var event_label, question_id, question_text, tab_selector;
      $(".question").hide();
      question_id = "#question_" + this.current_question;
      $(question_id).show();
      $(".question_tab").removeClass('active');
      tab_selector = ".question_tab[data-question_id=" + this.current_question + "]";
      $(tab_selector).addClass('active');
      this.update_question_links();
      question_text = $.trim($(question_id).find("div.text").text());
      if (this.current_question === this.count_questions()) {
        question_text = "Saving scenario";
      }
      event_label = "" + this.current_question + " : " + question_text;
      return this.track_event('opens_question', question_text, this.current_question);
    };
    Questions.prototype.setup_navigation_callbacks = function() {
      $("#next_question").click(__bind(function() {
        var last_question;
        if (!this.current_question_was_answered()) {
          alert('Kies eerst een antwoord voor u verder gaat.');
        } else {
          this.current_question++;
          last_question = this.count_questions();
          if (this.current_question > last_question) {
            this.current_question = last_question;
          }
          this.show_right_question();
        }
        return false;
      }, this));
      $("#previous_question").click(__bind(function() {
        this.current_question--;
        if (this.current_question < 1) {
          this.current_question = 1;
        }
        this.show_right_question();
        return false;
      }, this));
      return $("#questions nav#up a, #admin_menu a").click(function() {
        var question_id;
        question_id = $(this).data('question_id');
        this.current_question = question_id;
        this.show_right_question();
        return false;
      });
    };
    Questions.prototype.setup_cosmetic_callbacks = function() {
      $(".question .information a, .answer .text a").not(".no_popup").not(".iframe").colorbox({
        width: 600,
        opacity: 0.6
      });
      $(".question .information a.iframe").colorbox({
        width: 600,
        height: 400,
        opacity: 0.6,
        iframe: true
      });
      $(".answers em").hover(function() {
        var key, text;
        if ($(this).attr('key')) {
          key = $(this).attr('key');
        } else {
          key = $(this).html();
        }
        text = globals.popups[key];
        $("#tooltip h3").html(text.title);
        $("#tooltip div").html(text.body);
        return $("#tooltip").show("fast");
      }, function() {
        return $("#tooltip").hide();
      });
      return $(".answers em").mousemove(function(e) {
        var offset, tipX, tipY;
        tipX = e.pageX - 0;
        tipY = e.pageY - 0;
        offset = $(this).offset();
        return $("#tooltip").css({
          "top": tipY + 20,
          "left": tipX
        });
      });
    };
    Questions.prototype.setup_callbacks = function() {
      this.setup_navigation_callbacks();
      this.setup_cosmetic_callbacks();
      $("input[type='radio']").change(__bind(function(e) {
        var element;
        element = $(e.target).closest("li.answer");
        element.parent().find("li.answer").removeClass('active');
        element.addClass('active');
        this.app.mixer.refresh();
        return this.check_conflicts();
      }, this));
      return $("form").submit(function() {
        return $("#scenario_etm_scenario_id").val(this.app.mixer.scenario_id);
      });
    };
    Questions.prototype.clear_the_form = function() {
      return $('form')[0].reset();
    };
    Questions.prototype.track_event = function(action, label, value) {
      if (typeof _gaq === "undefined") {
        return;
      }
      return _gaq.push(['_trackEvent', 'questions', action, label, value]);
    };
    return Questions;
  })();
}).call(this);

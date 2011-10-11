/* DO NOT MODIFY. This file was compiled Tue, 11 Oct 2011 14:01:53 GMT from
 * /Users/paozac/Sites/energymixer/app/coffeescripts/questions.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty;
  this.Questions = (function() {
    function Questions(app) {
      this.store_location = __bind(this.store_location, this);
      this.show_right_question = __bind(this.show_right_question, this);
      this.update_question_links = __bind(this.update_question_links, this);
      this.disable_all_question_links = __bind(this.disable_all_question_links, this);
      this._goto_prev_question = __bind(this._goto_prev_question, this);
      this._goto_next_question = __bind(this._goto_next_question, this);      this.app = app;
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
    Questions.prototype.reset_questions = function() {
      var el, _i, _len, _ref;
      _ref = $(".answers input:checked");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        el = _ref[_i];
        $(el).attr('checked', false);
        $(el).closest("li.answer").removeClass('active');
      }
      return app.mixer.refresh();
    };
    Questions.prototype.get_question_id_from_answer = function(answer_id) {
      var e, _i, _len, _ref;
      this.answers2questions = {};
      _ref = $("div.question input:checked");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        e = _ref[_i];
        this.answers2questions[$(e).val()] = $(e).data('question_number');
      }
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
        $("section#conflicts .conflicting_questions").html(text);
        return $("section#conflicts").show();
      } else {
        return $("section#conflicts").hide();
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
    Questions.prototype._goto_next_question = function() {
      var last_question;
      if (this.current_question_was_answered()) {
        this.current_question++;
        last_question = this.count_questions();
        if (this.current_question > last_question) {
          this.current_question = last_question;
        }
        return this.show_right_question();
      }
    };
    Questions.prototype._goto_prev_question = function() {
      this.current_question--;
      if (this.current_question < 1) {
        this.current_question = 1;
      }
      return this.show_right_question();
    };
    Questions.prototype.disable_prev_link = function() {
      $("#previous_question").addClass('link_disabled');
      return $("#previous_question").unbind('click');
    };
    Questions.prototype.enable_prev_link = function() {
      $("#previous_question").removeClass('link_disabled');
      $("#previous_question").unbind('click');
      return $("#previous_question").bind('click', this._goto_prev_question);
    };
    Questions.prototype.disable_next_link = function() {
      $("#next_question").addClass('link_disabled');
      return $("#next_question").unbind('click');
    };
    Questions.prototype.enable_next_link = function() {
      $("#next_question").removeClass('link_disabled');
      $("#next_question").unbind('click');
      return $("#next_question").bind('click', this._goto_next_question);
    };
    Questions.prototype.disable_all_question_links = function() {
      this.disable_next_link();
      return this.disable_prev_link();
    };
    Questions.prototype.update_question_links = function() {
      var first_question, last_question;
      first_question = this.current_question === 1;
      last_question = this.current_question === this.count_questions();
      if (first_question) {
        this.disable_prev_link();
      } else if (this.current_question <= 3 && this.app.score_enabled) {
        this.disable_prev_link();
      } else {
        this.enable_prev_link();
        if (last_question) {
          this.disable_next_link();
        }
      }
      if (this.current_question_was_answered() && !last_question) {
        return this.enable_next_link();
      } else {
        return this.disable_next_link();
      }
    };
    Questions.prototype.show_right_question = function() {
      var event_label, i, question_id, question_text, tab_selector, _ref;
      $(".question").hide();
      question_id = "#question_" + this.current_question;
      $(question_id).show();
      $(".question_tab").removeClass('active');
      for (i = 1, _ref = this.current_question; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
        tab_selector = ".question_tab[data-question_id=" + i + "]";
        $(tab_selector).addClass('active');
      }
      this.update_question_links();
      question_text = $.trim($(question_id).find("div.text").text());
      if (this.current_question === this.count_questions()) {
        question_text = "Saving scenario";
      }
      event_label = "" + this.current_question + " : " + question_text;
      return this.track_event('opens_question', question_text, this.current_question);
    };
    Questions.prototype.store_location = function() {
      return navigator.geolocation.getCurrentPosition(function(pos) {
        $("#scenario_longitude").val(pos.coords.longitude);
        return $("#scenario_latitude").val(pos.coords.latitude);
      });
    };
    Questions.prototype.setup_navigation_callbacks = function() {
      $("#previous_question, #next_question").click(function(e) {
        return e.preventDefault();
      });
      $("#next_question").click(this._goto_next_question);
      $("#prev_question").click(this._goto_prev_question);
      return $("#questions nav#up a, #admin_menu a").click(__bind(function(e) {
        var question_id;
        e.preventDefault();
        question_id = $(e.target).data('question_id');
        this.current_question = question_id;
        return this.show_right_question();
      }, this));
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
      $(".answers em").mousemove(function(e) {
        var offset, tipX, tipY;
        tipX = e.pageX - 0;
        tipY = e.pageY - 0;
        offset = $(this).offset();
        return $("#tooltip").css({
          "top": tipY + 20,
          "left": tipX
        });
      });
      $("section#questions .question a.close_info_popup").click(function(e) {
        e.preventDefault();
        $(this).closest(".information").hide();
        $(this).closest("#questions").unblock();
        $("nav#down").unblock();
        return false;
      });
      return $("section#questions .question a.show_info").click(function(e) {
        $(this).parent().find(".information").toggle();
        e.preventDefault();
        $(this).closest("#questions").block();
        return $("nav#down").block();
      });
    };
    Questions.prototype.setup_question_callbacks = function() {
      $("input[type='radio']").change(__bind(function(e) {
        var element;
        element = $(e.target).closest("li.answer");
        element.parent().find("li.answer").removeClass('active');
        element.addClass('active');
        this.app.mixer.refresh();
        return this.check_conflicts();
      }, this));
      return $("form").submit(__bind(function() {
        $("#scenario_etm_scenario_id").val(this.app.mixer.scenario_id);
        if (globals.geolocation_enabled) {
          return this.store_geolocation();
        }
      }, this));
    };
    Questions.prototype.setup_callbacks = function() {
      this.setup_navigation_callbacks();
      this.setup_question_callbacks();
      return this.setup_cosmetic_callbacks();
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

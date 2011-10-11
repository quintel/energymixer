
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  this.Questions = (function() {
    __extends(Questions, Backbone.View);
    function Questions() {
      this.store_location = __bind(this.store_location, this);
      this.show_right_question = __bind(this.show_right_question, this);
      this.update_question_links = __bind(this.update_question_links, this);
      this.disable_all_question_links = __bind(this.disable_all_question_links, this);
      this._goto_prev_question = __bind(this._goto_prev_question, this);
      this._goto_next_question = __bind(this._goto_next_question, this);
      this.select_answer = __bind(this.select_answer, this);
      this.submit_form = __bind(this.submit_form, this);
      this.open_question = __bind(this.open_question, this);
      Questions.__super__.constructor.apply(this, arguments);
    }
    Questions.prototype.initialize = function(app) {
      this.app = app;
      this.current_question = 1;
      if ($(".field_with_errors").length > 0) {
        this.current_question = this.count_questions();
      } else {
        this.current_question = 1;
      }
      this.show_right_question();
      this.setup_colorbox();
      return this.clear_the_form();
    };
    Questions.prototype.el = 'body';
    Questions.prototype.events = {
      "change input[type='radio']": "select_answer",
      "submit form": "submit_form",
      "click #next_question": "_goto_next_question",
      "click #prev_question": "_goto_prev_question",
      "click #questions nav#up a": "open_question",
      "click #admin_menu a": "open_question",
      "click section#questions .question a.show_info": "show_question_info_box",
      "click section#questions .question a.close_info_popup": "hide_question_info_box",
      "mouseover .answers em": "show_tooltip",
      "mouseout .answers em": "hide_tooltip",
      "mousemove .answers em": "move_tooltip"
    };
    Questions.prototype.setup_colorbox = function() {
      $(".question .information a, .answer .text a").not(".no_popup").not(".iframe").colorbox({
        width: 600,
        opacity: 0.6
      });
      return $(".question .information a.iframe").colorbox({
        width: 600,
        height: 400,
        opacity: 0.6,
        iframe: true
      });
    };
    Questions.prototype.show_tooltip = function() {
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
    };
    Questions.prototype.hide_tooltip = function() {
      return $("#tooltip").hide();
    };
    Questions.prototype.move_tooltip = function(e) {
      var offset, tipX, tipY;
      tipX = e.pageX - 0;
      tipY = e.pageY - 0;
      offset = $(this).offset();
      return $("#tooltip").css({
        "top": tipY + 20,
        "left": tipX
      });
    };
    Questions.prototype.hide_question_info_box = function(e) {
      e.preventDefault();
      $(e.target).closest(".information").hide();
      $(e.target).closest("#questions").unblock();
      return $("nav#down").unblock();
    };
    Questions.prototype.show_question_info_box = function(e) {
      $(e.target).parent().find(".information").toggle();
      e.preventDefault();
      $(e.target).closest("#questions").block();
      return $("nav#down").block();
    };
    Questions.prototype.open_question = function(e) {
      var question_id;
      e.preventDefault();
      question_id = $(e.target).data('question_id');
      this.current_question = question_id;
      return this.show_right_question();
    };
    Questions.prototype.submit_form = function() {
      $("#scenario_etm_scenario_id").val(this.app.mixer.scenario_id);
      if (globals.geolocation_enabled) {
        return this.store_geolocation();
      }
    };
    Questions.prototype.select_answer = function(e) {
      var element;
      element = $(e.target).closest("li.answer");
      element.parent().find("li.answer").removeClass('active');
      element.addClass('active');
      this.app.mixer.refresh();
      return this.check_conflicts();
    };
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
    Questions.prototype._goto_next_question = function(e) {
      var last_question;
      e.preventDefault();
      if (this.current_question_was_answered()) {
        this.current_question++;
        last_question = this.count_questions();
        if (this.current_question > last_question) {
          this.current_question = last_question;
        }
        return this.show_right_question();
      }
    };
    Questions.prototype._goto_prev_question = function(e) {
      e.preventDefault();
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
      return this.track_event("opens_question_" + this.current_question, question_text, this.current_question);
    };
    Questions.prototype.store_location = function() {
      return navigator.geolocation.getCurrentPosition(function(pos) {
        $("#scenario_longitude").val(pos.coords.longitude);
        return $("#scenario_latitude").val(pos.coords.latitude);
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

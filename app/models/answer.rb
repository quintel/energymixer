# == Schema Information
#
# Table name: answers
#
#  id             :integer(4)      not null, primary key
#  text_nl        :text
#  ordering       :integer(4)
#  question_id    :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#  description_nl :text
#  text_de        :text
#  description_de :text
#

class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :inputs,                   :dependent => :destroy
  has_many :scenario_answers,         :dependent => :destroy
  has_many :answer_conflicts,         :dependent => :destroy
  has_many :inverse_answer_conflicts, :dependent => :destroy, :class_name => 'AnswerConflict', :foreign_key => 'other_answer_id'

  accepts_nested_attributes_for :inputs, :allow_destroy => true, :reject_if => proc {|attr| attr['key'].blank? && attr['value'].blank? }

  validates :text_nl, :presence => true

  scope :ordered, order('ordering, id')

  attr_accessible :inputs_attributes, :ordering, :text_nl, :text_de,
    :description_nl, :description_de, :conflicting_answer_ids, :answer_conflicts,
    :text_en, :description_en

  def conflicting_answers
    Answer.find(conflicting_answer_ids)
  end

  def conflicting_answer_ids
    answer_conflicts.map(&:other_answer_id) + inverse_answer_conflicts.map(&:answer_id)
  end

  def conflicting_answer_ids=(ids)
    answer_conflicts.destroy_all
    inverse_answer_conflicts.destroy_all
    ids.each{|i| answer_conflicts.build(:other_answer_id => i)}
  end

  def conflicts_with?(ans)
    conflicting_answer_ids.include?(ans.id)
  end

  def text
    answer = send "text_#{I18n.locale}"
    answer = "No answer available in your language" if answer.nil?
    return answer
  end

  def description
    description_text = send "description_#{I18n.locale}"
    description_text = "No description  available in your language" if description_text.nil?
    return description_text
  end

  # how many times this answer has been chosen
  def votes
    scenario_answers.count
  end

  # as above, but limiting to an array of scenarios. This is used by the stats
  # page
  def votes_in_scenarios(scenarios)
    scenario_answers.for_scenarios(scenarios).count
  end

  # array of the slider ids affected
  def slider_keys
    @_slider_keys ||= inputs.map(&:key)
  end

  # returns the sibling questions that set the same inputs
  def questions_using_the_same_sliders
    return false unless question
    @sibling_questions ||= question.question_set.questions.where(['id != ?', question.id])
    @sibling_questions.select do |q|
      (q.answers.map(&:slider_keys).flatten & self.slider_keys).any?
    end
  end

  # returns the answers (of other questions) that set the same inputs
  def answers_using_the_same_sliders
    return false unless question
    @sibling_questions ||= question.question_set.questions.where(['id != ?', question.id])
    @sibling_questions.map(&:answers).flatten.uniq.select do |a|
      (a.slider_keys & self.slider_keys).any?
    end
  end
end

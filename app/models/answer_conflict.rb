# == Schema Information
#
# Table name: answer_conflicts
#
#  id              :integer(4)      not null, primary key
#  answer_id       :integer(4)
#  other_answer_id :integer(4)
#

class AnswerConflict < ActiveRecord::Base
  belongs_to :answer
  belongs_to :other_answer, :class_name => 'Answer'

  validates :answer_id,       :presence   => true
  validates :other_answer_id, :presence   => true
  validates :answer_id,       :uniqueness => { :scope => :other_answer_id }
  validates :other_answer_id, :uniqueness => { :scope => :answer_id }
  validate :no_duplicates
  validate :no_conflicts_with_the_same_question

  attr_accessible :answer_id, :other_answer_id

  private

  def no_duplicates
    if AnswerConflict.exists?(:answer_id => answer_id, :other_answer_id => other_answer_id) ||
      AnswerConflict.exists?(:other_answer_id => answer_id, :answer_id => other_answer_id)
      errors.add(:base, "Conflict already defined")
    end
  end

  def no_conflicts_with_the_same_question
    return unless answer && other_answer
    errors.add(:base, "Conflict within the same question") if answer.question_id == other_answer.question_id
  end
end

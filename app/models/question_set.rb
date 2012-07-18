# == Schema Information
#
# Table name: question_sets
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  enabled    :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#  end_year   :integer(4)
#

class QuestionSet < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :end_year, :numericality => { :only_integer => true }

  has_many :questions
  has_many :scenarios
  has_many :dashboard_items

  def combinations
    return [] if questions.count.zero?
    answers = questions.ordered.map{|q| q.answer_ids + [nil]}
    answers[0].compact!
    answers[0].product(*answers[1..-1]).select{|x| valid_combination?(x)}
  end

  private

  def valid_combination?(x)
    # if there's a nil in the middle I won't accept following not-nil values
    # 1/2/3/nil => OK
    # 1/nil => OK
    # 1/nil/2 => NO
    x[0...-1].none?(&:nil?)
  end
end

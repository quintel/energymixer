class QuestionSet < ActiveRecord::Base
  validates :name, :presence => true
  
  has_many :questions
  
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

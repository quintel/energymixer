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
      nil_found = false
      for i in 0..(x.size)
        if x[i].nil?
          nil_found = true 
        end
        # if there's a nil in the middle I won't accept following not-nil values
        # 1/2/3/nil => OK
        # 1/nil => OK
        # 1/nil/2 => NO
        return false if nil_found && x[i]
      end
      return true
      # DEBT: one-liner
      # x[0...-1].none?(&:nil?)
    end
end

class QuestionSet < ActiveRecord::Base
  validates :name, :presence => true
  
  has_many :questions
  
  def combinations
    qs = {}.tap{|x| questions.ordered.each{|q| x[q.id] = q.answer_ids + [nil] }}
    answers = qs.values.take(11)
    cartesian(*answers)
  end

  private

    def cartesian(*args)
      final_output= [[]]
      while [] != args
        t, final_output= final_output, []
        b, *args = args
        t.each do |a|
          b.each do |n|
            next if n.nil?
            final_output<< a + [n]
          end
        end
      end
      final_output
    end
end

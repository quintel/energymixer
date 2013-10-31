# == Schema Information
#
# Table name: questions
#
#  id              :integer(4)      not null, primary key
#  text_nl         :string(255)
#  ordering        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  description_nl  :text
#  question_set_id :integer(4)
#  text_de         :string(255)
#  description_de  :text
#

class Question < ActiveRecord::Base
  belongs_to :question_set
  has_many :answers, :dependent => :destroy

  accepts_nested_attributes_for :answers, :allow_destroy => true, :reject_if => proc {|attrs| attrs['text_nl'].blank? }

  validates :text_nl, :presence => true

  scope :ordered, order(['enabled DESC, ordering, id', true])
  scope :excluding, lambda {|ids| where('id NOT IN (?)', ids) }
  scope :enabled, where(:enabled => true)

  attr_accessible :question_set_id, :ordering, :answers_attributes, :text_nl,
    :text_de, :description_nl, :description_de, :text_en, :description_en, :enabled

  def number
    ordering + 1 rescue nil
  end

  def text
    question_text = send "text_#{I18n.locale}"
    question_text = "No description  available in your language" if question_text.nil?
    return question_text
  end

  def description
    description_text = send "description_#{I18n.locale}"
    description_text = "No description  available in your language" if description_text.nil?
    return description_text
  end

  def most_voted_answer
    answers.max_by{|a| a.votes}
  end

  # as above, but using the answers of an array of scenarios
  # See the stats page
  def most_voted_answer_for_scenarios(scenarios)
    answers.max_by{|a| a.votes_in_scenarios(scenarios)}
  end
end

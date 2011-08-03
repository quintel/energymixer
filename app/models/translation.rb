# == Schema Information
#
# Table name: translations
#
#  id             :integer(4)      not null, primary key
#  locale         :string(255)
#  key            :string(255)
#  value          :text
#  interpolations :text
#  is_proc        :boolean(1)      default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

class Translation < ActiveRecord::Base
end

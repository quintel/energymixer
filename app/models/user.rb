class User < ActiveRecord::Base

  devise :database_authenticatable,
    # :registerable,
    # :recoverable,
    # :rememberable,
    # :confirmable,
    :trackable,
    :validatable,
    :lockable,
    :timeoutable

  attr_accessible :email, :password, :password_confirmation

end

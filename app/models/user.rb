class User < ActiveRecord::Base
	has_many :groups
	has_many :assessments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    def name
    	"#{firstname} #{lastname}"
    end
end

class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles
  has_many :authors
  has_many :article_types
  has_one :user_profile

  private 
  
  def fullname
    if self.first_name.present?
      self.first_name + " " + self.last_name
    else
      self.username
    end 
  end

end

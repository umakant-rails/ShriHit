class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, : and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  has_many :articles, dependent: :nullify
  has_many :authors, dependent: :nullify
  has_many :article_types, dependent: :nullify
  has_many :themes
  has_many :theme_chapters
  has_one  :user_profile, dependent: :destroy, :foreign_key => "user_id"

  private 
  
  def fullname
    if self.first_name.present?
      self.first_name + " " + self.last_name
    else
      self.username
    end 
  end

end

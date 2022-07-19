class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, : and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  has_many :articles, dependent: :nullify
  has_many :authors, dependent: :nullify
  has_many :article_types, dependent: :nullify
  has_many :themes, dependent: :destroy
  has_many :contexts, dependent: :nullify
  has_many :theme_chapters
  has_one  :user_profile, dependent: :destroy, :foreign_key => "user_id"
  has_many :theme_articles
  has_many :suggestions
  belongs_to :role


  def is_admin
    self.role.name == "Admin"
  end
  
  def is_super_admin
    self.role.name == "Super Admin"
  end

  def is_contributer
    self.role.name == "Contributor"
  end

  private 

  def fullname
    if self.first_name.present?
      self.first_name + " " + self.last_name
    else
      self.username
    end 
  end

end

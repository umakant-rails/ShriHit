class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, : and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  validates_length_of :password, :within => 8..20, :if => :password_required?

  has_many :articles, dependent: :nullify
  has_many :authors, dependent: :nullify
  has_many :article_types, dependent: :nullify
  has_many :themes, dependent: :destroy
  has_many :contexts, dependent: :nullify
  has_many :theme_chapters
  has_one  :user_profile, dependent: :destroy, :foreign_key => "user_id"
  has_many :theme_articles
  has_many :suggestions
  has_many :comments
  has_many :tags
  has_many :themes
  belongs_to :role
  has_many :comment_reportings
  has_many :article_tags
  has_many :saint_bio_events
  has_many :scriptures
  has_many :stories

  scope :unblocked_users, ->(){ where(is_blocked: false, role_id: 3) }
  scope :blocked_users, ->(){ where(is_blocked: true) }

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

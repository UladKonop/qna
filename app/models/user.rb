class User < ApplicationRecord
  has_many :questions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  validates :email, presence: true

  def author_of?(resource)
    id == resource&.user_id
  end
end

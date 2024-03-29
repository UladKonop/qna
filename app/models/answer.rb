class Answer < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true

  def mark_as_best
		transaction do
			self.class.where(question_id: self.question_id).update_all(best: false)
			update(best: true)
		end
	end
end

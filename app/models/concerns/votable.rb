# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def upvote(user)
    votes.create(value: 1, user: user)
  end

  def downvote(user)
    votes.create(value: -1, user: user)
  end

  def votes_difference
    votes.sum(:value)
  end
end

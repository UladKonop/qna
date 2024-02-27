# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :delete_all
  end

  def comment(body, user)
    comments.create(body: body, user: user)
  end
end

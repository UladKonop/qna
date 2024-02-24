# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote]
    before_action :check_user_permission, only: %i[upvote downvote]
    before_action :check_user_voted, only: %i[upvote downvote]
  end

  def upvote
    @votable.upvote(current_user)

    render json: { status: 'Success', message: 'Upvoted successfully', votes_difference: @votable.votes_difference }
  end

  def downvote
    @votable.downvote(current_user)

    render json: { status: 'Success', message: 'Downvoted successfully', votes_difference: @votable.votes_difference }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def check_user_permission
    return unless @votable.user_id == current_user.id

    render json: { status: 'Error', message: 'You cannot vote for your own question or answer' },
           status: :unprocessable_entity
  end

  def check_user_voted
    @votable.votes.find_by(user: current_user)&.destroy
  end
end

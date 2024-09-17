# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
    after_action :publish_comment, only: [:comment]
  end

  def comment
    @commentable.comment(permited_params[:body], current_user)

    redirect_to @commentable, notice: 'Comment was successfully created.'
  end

  private

  def permited_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    ActionCable.server.broadcast(
      "#{controller_name.singularize}_#{@commentable.id}_comments",
      ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @commentable.comments.last }
      )
    )
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end

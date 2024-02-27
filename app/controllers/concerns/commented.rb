# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
  end

  def comment
    @commentable.comment(body, current_user)

    render json: { status: 'Success', message: 'Commented successfully' }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end

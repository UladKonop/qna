# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authorize_user(resource, destination)
    return if current_user&.author_of?(resource)

    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to destination
  end
end

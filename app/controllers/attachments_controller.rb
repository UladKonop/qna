class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource
  before_action -> { authorize_user(@resource, @resource) }, only: :destroy


  def destroy
    ActiveStorage::Blob.find(params[:id]).attachments.first.purge_later
  end

  private

  def set_resource
    resource_type = params[:resource_type]
    resource_id = params[:resource_id]

    @resource = resource_type.constantize.find(resource_id)
  end
end

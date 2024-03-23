# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:delete_all) }

  it { is_expected.to accept_nested_attributes_for :links }

  it { is_expected.to validate_presence_of(:body) }
end

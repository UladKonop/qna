# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to belong_to(:rewardable) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :question_title }

  it 'have one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end

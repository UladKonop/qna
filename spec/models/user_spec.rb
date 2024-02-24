# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'returns true if the user is the author of the resource' do
      expect(user.author_of?(question)).to eq(true)
      expect(user.author_of?(answer)).to eq(true)
    end

    it 'returns false if the user is not the author of the resource' do
      other_user = create(:user)
      other_question = create(:question, user: other_user)
      other_answer = create(:answer, user: other_user, question: other_question)

      expect(user.author_of?(other_question)).to eq(false)
      expect(user.author_of?(other_answer)).to eq(false)
    end

    it 'returns false if the resource is nil' do
      expect(user.author_of?(nil)).to eq(false)
    end
  end
end

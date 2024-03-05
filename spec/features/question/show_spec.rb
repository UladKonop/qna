# frozen_string_literal: true

require 'rails_helper'

describe 'User can view question and answers', "
  In order to see the details of a question and its answers
  As a user
  I'd like to be able to view a question and its answers
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, user: user, question: question) }

  it 'User views a question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'User can view list of questions', "
  In order to see existing questions
  As a user
  I'd like to be able to view the list of questions
" do
  let!(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3, user: user) }

  it 'Authenticated user views the list of questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'Questions:'

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  it 'Unauthenticated user views the list of questions' do
    visit questions_path

    expect(page).to have_content 'Questions:'

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end

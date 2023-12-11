require 'rails_helper'

feature 'User can view list of questions', %q{
  In order to see existing questions
  As a user
  I'd like to be able to view the list of questions
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'Authenticated user views the list of questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'Questions:'

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user views the list of questions' do
    visit questions_path

    expect(page).to have_content 'Questions:'

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end

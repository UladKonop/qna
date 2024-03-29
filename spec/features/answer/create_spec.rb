require 'rails_helper'

feature 'User can create answer', %q{
  In order to provide help to a community
  As an authenticated user
  I'd like to be able to answer a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers a question', js: true do
      fill_in 'new-answer-body', with: 'Test answer'
      click_on 'Answer'

      within('.answers') do
        expect(page).to have_content 'Test answer'
      end 
    end

    scenario 'answers a question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to answer a question' do
      visit question_path(question)
      fill_in 'new-answer-body', with: 'Test answer'
      click_on 'Answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end

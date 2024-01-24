require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove my answer
  As an authenticated user
  I'd like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'deletes own answer', js: true do
      within(".answers") do
        within(".answer-#{answer.id}") do
          click_on 'Delete'
        end
      end

      expect(page).not_to have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)

      visit question_path(question)

      within(".answer-#{another_answer.id}") do
        expect(page).not_to have_content 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_content 'Delete'
    end
  end
end

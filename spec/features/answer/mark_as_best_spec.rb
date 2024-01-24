require 'rails_helper'

feature 'User can mark answer as the best', %q{
  In order to recognize the best answer
  As an authenticated user and question author
  I'd like to be able to mark an answer as the best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given(:another_user) { create(:user) }
  given!(:another_answer) { create(:answer, question: question, user: another_user) }

  describe 'Authenticated user and question author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'marks an answer as the best', js: true do
      within(".answer-#{answer.id}") do
        click_on 'Set as Best'

        expect(page).to have_content '+'
        expect(page).to_not have_link 'Set as Best'
      end
    end

    scenario 'marks an answer as the best and it is displayed at the top', js: true do
      within(".answer-#{another_answer.id}") do
        click_on 'Set as Best'
      end

      within('.answers-table tbody tr:first-child') do
        expect(page).to have_content '+'
      end
    end
  end

  scenario 'Authenticated user, but not the question author, tries to mark an answer as the best', js: true do
    sign_in(another_user)

    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).to_not have_link 'Set as Best'
    end
  end

  scenario 'Unauthenticated user tries to mark an answer as the best' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).to_not have_link 'Set as Best'
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe 'User can mark answer as the best', "
  In order to recognize the best answer
  As an authenticated user and question author
  I'd like to be able to mark an answer as the best
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  let(:another_user) { create(:user) }
  let!(:another_answer) { create(:answer, question: question, user: another_user) }

  describe 'Authenticated user and question author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'marks an answer as the best', js: true do
      within(".answer-#{answer.id}") do
        click_on 'Set as Best'

        expect(page).to have_content '+'
        expect(page).not_to have_link 'Set as Best'
      end
    end

    it 'marks an answer as the best and it is displayed at the top', js: true do
      within(".answer-#{another_answer.id}") do
        click_on 'Set as Best'
      end

      within('.answers-table tbody tr:first-child') do
        expect(page).to have_content '+'
      end
    end
  end

  it 'Authenticated user, but not the question author, tries to mark an answer as the best', js: true do
    sign_in(another_user)

    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_link 'Set as Best'
    end
  end

  it 'Unauthenticated user tries to mark an answer as the best' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_link 'Set as Best'
    end
  end
end

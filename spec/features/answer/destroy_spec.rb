# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete answer', "
  In order to remove my answer
  As an authenticated user
  I'd like to be able to delete my answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'deletes own answer', js: true do
      within('.answers') do
        within(".answer-#{answer.id}") do
          click_on 'Delete'
        end
      end

      expect(page).not_to have_content answer.body
    end

    it "tries to delete someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)

      visit question_path(question)

      within(".answer-#{another_answer.id}") do
        expect(page).not_to have_content 'Delete'
      end
    end
  end

  it 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_content 'Delete'
    end
  end
end

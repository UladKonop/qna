# spec/features/answer_voting_spec.rb

require 'rails_helper'

feature 'User can upvotes and downvotes an answer', %q{
  In order to moke vote for the answer
  As an authenticated user and question author
  I'd like to be able to vote for the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given(:another_user) { create(:user) }
  given!(:another_answer) { create(:answer, question: question, user: another_user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user upvotes an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'

      expect(page).to_not have_content '0'
      expect(page).to have_content '1'
    end
  end

  scenario 'Authenticated user downvotes an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Downvote'

      expect(page).to_not have_content '0'
      expect(page).to have_content '-1'
    end
  end

  scenario "User cannot vote for their own answer", js: true do
    within(".answer-#{answer.id}") do
      expect(page).to_not have_link 'Upvote'
      expect(page).to_not have_link 'Downvote'
    end
  end

  scenario 'User can only vote once for an answer while upvote', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'
      click_on 'Upvote'

      expect(page).to_not have_content '2'
    end
  end

  scenario 'User can only vote once for an answer while downvote', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Downvote'
      click_on 'Downvote'

      expect(page).to_not have_content '-2'
    end
  end

  scenario 'User can change their vote for an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'
      click_on 'Downvote'

      expect(page).to have_content '-1'
    end
  end
end

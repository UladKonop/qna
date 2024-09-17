# frozen_string_literal: true

# spec/features/answer_voting_spec.rb

require 'rails_helper'

describe 'User can upvotes and downvotes an answer', "
  In order to moke vote for the answer
  As an authenticated user and question author
  I'd like to be able to vote for the answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  let(:another_user) { create(:user) }
  let!(:another_answer) { create(:answer, question: question, user: another_user) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  it 'Authenticated user upvotes an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'

      expect(page).not_to have_content '0'
      expect(page).to have_content '1'
    end
  end

  it 'Authenticated user downvotes an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Downvote'

      expect(page).not_to have_content '0'
      expect(page).to have_content '-1'
    end
  end

  it 'User cannot vote for their own answer', js: true do
    within(".answer-#{answer.id}") do
      expect(page).not_to have_link 'Upvote'
      expect(page).not_to have_link 'Downvote'
    end
  end

  it 'User can only vote once for an answer while upvote', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'
      click_on 'Upvote'

      expect(page).not_to have_content '2'
    end
  end

  it 'User can only vote once for an answer while downvote', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Downvote'
      click_on 'Downvote'

      expect(page).not_to have_content '-2'
    end
  end

  it 'User can change their vote for an answer', js: true do
    within(".answer-#{another_answer.id}") do
      click_on 'Upvote'
      click_on 'Downvote'

      expect(page).to have_content '-1'
    end
  end
end

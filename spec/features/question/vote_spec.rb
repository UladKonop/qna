# frozen_string_literal: true

# spec/features/answer_voting_spec.rb

require 'rails_helper'

describe 'User can upvotes and downvotes a question', "
  In order to moke vote for the question
  As an authenticated user and not question author
  I'd like to be able to vote for the question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:another_user) { create(:user) }
  let(:another_question) { create(:question, user: user) }

  before do
    sign_in(another_user)
    visit question_path(question)
  end

  it 'Authenticated user upvotes a question', js: true do
    click_on 'Upvote', class: "question_vote_buttons-#{question.id}"
    within(".question_votes_difference-#{question.id}") do
      expect(page).not_to have_content '0'
      expect(page).to have_content '1'
    end
  end

  it 'Authenticated user downvotes a question', js: true do
    click_on 'Downvote', class: "question_vote_buttons-#{question.id}"
    within(".question_votes_difference-#{question.id}") do
      expect(page).not_to have_content '0'
      expect(page).to have_content '-1'
    end
  end

  it 'User cannot vote for their own question', js: true do
    visit question_path(another_question)

    expect(page).not_to have_link 'Upvote', class: "question_vote_buttons-#{question.id}"
    expect(page).not_to have_link 'Downvote', class: "question_vote_buttons-#{question.id}"
  end

  it 'User can only vote once for a question while upvote', js: true do
    click_on 'Upvote', class: "question_vote_buttons-#{question.id}"
    click_on 'Upvote', class: "question_vote_buttons-#{question.id}"

    within(".question_votes_difference-#{question.id}") do
      expect(page).not_to have_content '2'
    end
  end

  it 'User can only vote once for a question while downvote', js: true do
    click_on 'Downvote', class: "question_vote_buttons-#{question.id}"
    click_on 'Downvote', class: "question_vote_buttons-#{question.id}"

    within(".question_votes_difference-#{question.id}") do
      expect(page).not_to have_content '-2'
    end
  end

  it 'User can change their vote for a question', js: true do
    click_on 'Upvote', class: "question_vote_buttons-#{question.id}"
    click_on 'Downvote', class: "question_vote_buttons-#{question.id}"

    within(".question_votes_difference-#{question.id}") do
      expect(page).to have_content '-1'
    end
  end
end

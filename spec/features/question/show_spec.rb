require 'rails_helper'

feature 'User can view question and answers', %q{
  In order to see the details of a question and its answers
  As a user
  I'd like to be able to view a question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, user: user, question: question) }

  scenario 'User views a question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end

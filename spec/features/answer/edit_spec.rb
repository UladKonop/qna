require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct my answer
  As an authenticated user
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits own answer', js: true do
      within(".answers") do
        within(".answer-#{answer.id}") do
          click_on 'Edit'

          fill_in 'answer-body', with: 'Updated answer'
          attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      
          click_on 'Update Answer'

          expect(page).to have_content 'Updated answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'edits own answer', js: true do
      within(".answers") do
        within(".answer-#{answer.id}") do
          click_on 'Edit'

          fill_in 'answer-body', with: 'Updated answer'
          attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      
          click_on 'Update Answer'

          click_on 'Edit'
          first('a', text: 'x').click
          click_on 'Update Answer'

          expect(page).to have_content 'Updated answer'
          expect(page).not_to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'edits own answer with errors', js: true do
      within(".answers") do
        within(".answer-#{answer.id}") do
          click_on 'Edit'
          fill_in 'answer-body', with: ''      
          click_on 'Update Answer'
        end
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)

      visit question_path(question)

      within(".answer-#{another_answer.id}") do
        expect(page).not_to have_content 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_content 'Edit'
    end
  end
end

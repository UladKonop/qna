# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit answer', "
  In order to correct my answer
  As an authenticated user
  I'd like to be able to edit my answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:url) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'edits own answer + attaches file', js: true do
      within('.answers') do
        within(".answer-#{answer.id}") do
          click_on 'Edit'

          fill_in 'answer-body', with: 'Updated answer'
          attach_file 'answer_files',
                      [Rails.root.join('spec/rails_helper.rb').to_s, Rails.root.join('spec/spec_helper.rb').to_s]

          click_on 'Update Answer'

          expect(page).to have_content 'Updated answer'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    it 'edits own answer + deletes file + removes link', js: true do
      within('.answers') do
        within(".answer-#{answer.id}") do
          click_on 'Edit'

          fill_in 'answer-body', with: 'Updated answer'
          attach_file 'answer_files',
                      [Rails.root.join('spec/rails_helper.rb').to_s, Rails.root.join('spec/spec_helper.rb').to_s]

          click_on 'Update Answer'

          click_on 'Edit'
          first('a', text: 'x').click

          click_on 'remove link'

          click_on 'Update Answer'

          expect(page).to have_content 'Updated answer'
          expect(page).not_to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).not_to have_link 'My url', href: url
        end
      end
    end

    it 'edits own answer with errors', js: true do
      within('.answers') do
        within(".answer-#{answer.id}") do
          click_on 'Edit'
          fill_in 'answer-body', with: ''
          click_on 'Update Answer'
        end
      end

      expect(page).to have_content "Body can't be blank"
    end

    it "tries to edit someone else's answer" do
      another_user = create(:user)
      another_answer = create(:answer, question: question, user: another_user)

      visit question_path(question)

      within(".answer-#{another_answer.id}") do
        expect(page).not_to have_content 'Edit'
      end
    end
  end

  it 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)

    within(".answer-#{answer.id}") do
      expect(page).not_to have_content 'Edit'
    end
  end
end

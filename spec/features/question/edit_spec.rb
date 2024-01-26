require 'rails_helper'

feature 'User can manage attachments for a question' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
  
    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
  
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
  
      click_on 'Update Question'
    end
  
    scenario 'author adds files while editing the question' do
      expect(page).to have_link 'rails_helper.rb'
    end
  
    scenario 'author removes a file while editing the question' do
      click_on 'Edit'
  
      within('.files') do
        click_on 'x'
      end
  
      expect(page).not_to have_link 'rails_helper.rb'
    end
  end

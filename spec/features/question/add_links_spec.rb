require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/UladKonop/14982f9a80122ce640d851bb94f4171b'}
  given!(:url) { 'http://www.example.com' }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds gist link as gist content when asks question', js: true do 
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'

    expect(page).to have_content 'test content test content 2'      
  end

  scenario 'User adds link when asks question', js: true do   
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Ask'

    expect(page).to have_link 'My url', href: url
  end
end

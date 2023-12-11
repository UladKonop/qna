# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', "
  In order to access the system
  As an unauthenticated user
  I'd like to be able to register
" do

  scenario 'User registers with valid information' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'user_password', with: 'password123'
    fill_in 'user_password_confirmation', with: 'password123'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to register with invalid information' do
    visit new_user_registration_path
    fill_in 'Email', with: 'invalid_email'
    fill_in 'user_password', with: 'short'
    fill_in 'user_password_confirmation', with: 'different_password'
    click_button 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end

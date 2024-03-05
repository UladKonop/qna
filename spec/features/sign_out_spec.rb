# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign out', "
  In order to protect my account
  As an authenticated user
  I'd like to be able to sign out
" do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  it 'Authenticated user signs out' do
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end

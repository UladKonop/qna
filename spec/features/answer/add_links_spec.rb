# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:gist_url) { 'https://gist.github.com/UladKonop/14982f9a80122ce640d851bb94f4171b' }
  let(:url) { 'http://www.example.com' }

  before do
    sign_in(user)
    visit question_path(question)
    click_on 'add link'
  end

  it 'User adds gist link as gist content when create answer', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    fill_in 'new-answer-body', with: 'Test answer'
    click_on 'Answer'

    within('.answers') do
      expect(page).to have_content 'test content test content 2'
    end
  end

  it 'User adds link when create answer', js: true do
    fill_in 'Link name', with: 'My url'
    fill_in 'Url', with: url

    fill_in 'new-answer-body', with: 'Test answer'
    click_on 'Answer'

    within('.answers') do
      expect(page).to have_link 'My url', href: url
    end
  end
end

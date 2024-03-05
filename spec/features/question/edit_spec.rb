# frozen_string_literal: true

require 'rails_helper'

describe 'User can manage attachments for a question' do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:url) { create(:link, linkable: question) }

  before do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit'

    attach_file 'File', [Rails.root.join('spec/rails_helper.rb').to_s]

    click_on 'Update Question'
  end

  it 'author adds file while editing the question' do
    expect(page).to have_link 'rails_helper.rb'
  end

  it 'author removes a file while editing the question' do
    click_on 'Edit'

    within('.files') do
      click_on 'x'
    end

    expect(page).not_to have_link 'rails_helper.rb'
  end

  it 'author removes a link while editing the question' do
    click_on 'Edit'

    first('a', text: 'remove link').click

    expect(page).not_to have_link 'My url', href: url
  end
end

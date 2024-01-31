require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'validates the format of URL' do
    user = create(:user)
    question = create(:question, user: user)

    invalid_link = build(:link, url: 'invalid_url', linkable: question)

    expect(invalid_link).to_not be_valid
    expect(invalid_link.errors[:url]).to include('is invalid')
  end

  it 'creates a link with valid URL' do
    user = create(:user)
    question = create(:question, user: user)

    valid_link = build(:link, url: 'http://www.example.com', linkable: question)

    expect(valid_link).to be_valid
  end

  describe '#is_a_gist?' do
    it 'returns true for gist link' do
      link = Link.new(url: 'https://gist.github.com/UladKonop/14982f9a80122ce640d851bb94f4171b')
      expect(link.is_a_gist?).to be_truthy
    end

    it 'returns false for non-gist link' do
      link = Link.new(url: 'https://example.com')
      expect(link.is_a_gist?).to be_falsy
    end
  end


  describe '#gist_content' do
    it 'returns gist content if link is a gist' do
      allow_any_instance_of(GistService).to receive(:call).and_return('Gist Content')
      link = Link.new(url: 'https://gist.github.com/UladKonop/14982f9a80122ce640d851bb94f4171b')
      expect(link.gist_content).to eq('Gist Content')
    end

    it 'returns nil if link is not a gist' do
      link = Link.new(url: 'https://example.com')
      expect(link.gist_content).to be_nil
    end
  end
end

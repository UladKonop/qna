# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'My url' }
    url { 'http://www.example.com' }
  end
end

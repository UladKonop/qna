# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { Faker::Lorem.word }
    question_title { Faker::Lorem.sentence }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "#{Faker::Lorem.sentence} #{n}" }
    body { Faker::Lorem.paragraph }

    trait :invalid do
      title { nil }
    end

    trait :with_answer do
      answer
    end

    trait :with_comment do
      comment
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }

    trait :invalid do
      body { nil }
    end

    trait :best do
      best { true }
    end

    trait :with_comment do
      comment
    end
  end
end

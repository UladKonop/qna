FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
  end

  trait :invalid do
    body { nil }
  end

  # association :question
end

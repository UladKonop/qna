FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }

    trait :invalid do
      body { nil }
    end
  end
end

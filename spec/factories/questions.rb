FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }

    trait :invalid do
      title { nil }
    end

    # association :user
  end
end

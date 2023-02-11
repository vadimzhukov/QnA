FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question #{n} Title" }
    sequence(:body) { |n| "Question #{n} Body" }

    trait :invalid do
      title { nil }
    end
  end
end

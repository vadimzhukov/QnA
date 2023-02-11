FactoryBot.define do
  factory :answer do
    question

    sequence(:body) { |n| "Test answer #{n} Body" }
    correct { false }

    trait :invalid do
      body { nil }
    end
  end
end

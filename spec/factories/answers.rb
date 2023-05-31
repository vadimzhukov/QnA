FactoryBot.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "Test answer #{n} body" }
    correct { false }

    trait :invalid do
      body { nil }
    end
  end
end

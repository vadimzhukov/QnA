FactoryBot.define do
  factory :answer do
    question
    body { "MyAnswerBody" }
    correct { false }

    trait :invalid do
      body { nil }
    end
  end
end

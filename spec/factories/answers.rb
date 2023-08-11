FactoryBot.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "Test answer #{n} body" }
    correct { false }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open(Rails.root.join('test', 'fixtures', 'files', 'nobel_medal.jpg')),
          filename: 'nobel_medal.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end

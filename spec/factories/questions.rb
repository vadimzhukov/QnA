FactoryBot.define do
  factory :question do
    user
    sequence(:title) { |n| "Question #{n} Title" }
    sequence(:body) { |n| "Question #{n} Body" }

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after(:build) do |question|
        question.files.attach(
          io: File.open(Rails.root.join('test', 'fixtures', 'files', 'nobel_medal.jpg')),
          filename: 'nobel_medal.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end

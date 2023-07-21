FactoryBot.define do
  factory :email_registration do
    email { "email@email.com" }
    oauth_provider { "provider" }
    oauth_uid { "123" }
    confirmation_token { "12345" }

    trait :invalid do    
      email { nil }
    end
  end
end

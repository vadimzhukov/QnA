FactoryBot.define do
  factory :identity do
    user
    provider { "MyString" }
    uid { "MyString" }
    reference { "" }
  end
end

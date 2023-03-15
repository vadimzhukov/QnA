FactoryBot.define do
  factory :reward do
    name { "MyString" }
    association :rewardable, factory: :question
    image { Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/files/nobel_medal.jpg", "image/jpg") }
  end
end

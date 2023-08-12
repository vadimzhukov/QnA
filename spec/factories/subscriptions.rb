FactoryBot.define do
  factory :subscription do
    user 
    association :subscriptable, factory: :question
  end
end

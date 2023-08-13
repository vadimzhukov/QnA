require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :subscriptable }

  it { should validate_presence_of :user_id }

  context "user subscribed to question" do
    let!(:user_author) { create(:user) }
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user_author) }
    let!(:subscription) { create(:subscription, subscriptable: question , user_id: user.id)}

    it "returns status of existing subscription on object for user" do
      expect(Subscription.exists?(user, question)).to be_truthy
    end
  end
end

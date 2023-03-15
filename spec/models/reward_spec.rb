require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :rewardable }
  it { should belong_to(:user).optional }

  it "Has attached one image" do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it { should validate_presence_of :name }
end

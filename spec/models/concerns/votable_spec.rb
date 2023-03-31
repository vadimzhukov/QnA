require "rails_helper"

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy)}

  let!(:user1) {create(:user)}
  let!(:user2) {create(:user)}
  let!(:votable) { create(described_class.to_s.underscore.to_sym, user: user1)}
  
  it "check voted_by_user?" do
    votable.votes.create(user: user2)
    expect(votable.voted_by_user?(user2)).to be_truthy
  end
end

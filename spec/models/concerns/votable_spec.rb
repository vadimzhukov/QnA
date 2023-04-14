require "rails_helper"

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:users) { create_list(:user, 6) }
  let!(:votable) { create(described_class.to_s.underscore.to_sym, user: users[0]) }

  it "check voted_by_user?" do
    votable.votes.create(user: users[1], direction: true)
    expect(votable.voted_by_user?(users[1])).to be_truthy
  end

  it "check votes_sum" do
    votable.votes.create(user: users[1], direction: true)
    votable.votes.create(user: users[2], direction: true)
    expect(votable.votes_sum).to eq(2)
    votable.votes.create(user: users[3], direction: false)
    votable.votes.create(user: users[4], direction: false)
    votable.votes.create(user: users[5], direction: false)
    expect(votable.votes_sum).to eq(-1)
  end

  it "checks user_liked?" do
    votable.votes.create(user: users[1], direction: true)
    expect(votable.user_liked?(users[1])).to be_truthy
  end

  it "checks user_disliked?" do
    votable.votes.create(user: users[1], direction: false)
    expect(votable.user_disliked?(users[1])).to be_truthy
  end
end

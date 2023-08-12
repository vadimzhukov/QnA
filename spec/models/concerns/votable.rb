require "rails_helper"

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:users) { create_list(:user, 6) }
  let!(:votable) { create(described_class.to_s.underscore.to_sym, user: users[0]) }

  it "check votes_sum_by_user" do
    expect(votable.votes_sum_by_user(users[1])).to eq 0
    votable.votes.create(user: users[1], direction: true)
    expect(votable.votes_sum_by_user(users[1])).to eq 1
    votable.votes.create(user: users[2], direction: false)
    expect(votable.votes_sum_by_user(users[2])).to eq -1
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

end

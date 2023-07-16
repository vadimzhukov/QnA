require 'rails_helper'

RSpec.describe User::FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'gihub', uid: '123') }
  subject { User::FindForOauth.new(auth) }

  context "user and identity are existed" do
    it "finds a user by identity" do
      identity = user.identities.create(provider: auth.provider, uid: auth.uid)
      expect(subject.call).to eq user
    end
  end

  context "user is existed, identity is not existed" do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'gihub', uid: '123', info: { email: user.email }) }
    it "does not create new user" do
      expect { subject.call }.not_to change(User, :count)
    end

    it "creates identity" do 
      expect { subject.call }.to change(Identity, :count).by(1)
    end
    
    it "creates identity with correct provider and uid" do
      user = subject.call
      identity = user.identities.first
      expect(identity.provider).to eq auth.provider
      expect(identity.uid).to eq auth.uid
    end
  end

  context "user is not existed" do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'gihub', uid: '123', info: { email: 'sample@email.com' }) }
    it "creates user" do
      expect { subject.call }.to change(User, :count).by(1)
    end

    it "creates identity with provider and uid for user" do
      user = subject.call
      identity = user.identities.first
      expect(identity.provider).to eq auth.provider
      expect(identity.uid).to eq auth.uid
    end
  end

end

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:reward1) { create(:reward) }
  let(:reward2) { create(:reward) }

  let!(:user) { create(:user, rewards: [reward1, reward2]) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index }
    it 'assigns user rewards to @rewards' do
      expect(assigns(:rewards)).to eq(user.rewards)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end
end

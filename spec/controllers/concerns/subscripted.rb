require "rails_helper"

shared_examples_for 'subscripted' do
  let(:user_author) { create(:user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:subscriptable) { create(described_class.controller_name.classify.constantize.name.downcase.to_sym, user: user_author) }

  describe '#add_subscription' do
    context 'when user has not subscribed yet' do
      before do
        sign_in user
      end

      it 'creates a subscription' do
        expect do 
          patch :add_subscription, params: { id: subscriptable.id, user_id: user.id }
        end.to change(subscriptable.subscriptions, :count).by(1)

        expect(Subscription.exists?(user, subscriptable)).to be_truthy
        expect(response).to redirect_to question_path(subscriptable)
      end
    end

    context 'when user already subscribed' do
      before do
        sign_in user
        patch :add_subscription, params: { id: subscriptable.id, user_id: user.id }
      end

      it 'does not create a subscription' do
        expect(Subscription.exists?(user, subscriptable)).to be_truthy
        expect do 
          patch :add_subscription, params: { id: subscriptable.id, user_id: user.id }
        end.to change(subscriptable.subscriptions, :count).by(0)
        expect(response).to redirect_to question_path(subscriptable)
      end
    end
  end

  describe '#delete_subscription' do
    context 'when user already subscribed' do
      before do
        sign_in user
        patch :add_subscription, params: { id: subscriptable.id, user_id: user.id }
      end

      it 'deletes the subscription' do
        expect(subscriptable.subscriptions.count).to eq(1)
        expect(Subscription.exists?(user, subscriptable)).to be_truthy
        puts "==== #{:delete_subscription} ======"
        delete :delete_subscription, params: { id: subscriptable.id }
        expect(subscriptable.subscriptions.count).to eq(0)
        expect(Subscription.exists?(user, subscriptable)).to be_falsey
        expect(response).to redirect_to question_path(subscriptable)
      end
    end
    
  end
end

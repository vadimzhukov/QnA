require "rails_helper"

shared_examples_for 'subscripted' do
  let!(:author) { create(:user) }
  let!(:subscribing_user) { create(:user) }
  
  let!(:subscriptable) { create(described_class.controller_name.classify.constantize.name.downcase.to_sym, user: author) }
  
  describe '#add_subscription' do
    context 'when user has not subscribed yet' do
      before do
        sign_in subscribing_user
      end

      it 'creates a subscription' do
        expect do 
          patch :add_subscription, params: { id: subscriptable.id }
        end.to change(subscriptable.subscriptions, :count).by(1)
       
        expect(Subscription.exists?(subscribing_user, subscriptable)).to be_truthy
        expect(response).to redirect_to question_path(subscriptable)
      end
    end

    context 'when user already subscribed' do
      before do
        sign_in subscribing_user
        patch :add_subscription, params: { id: subscriptable.id, user_id: subscribing_user.id }
      end

      it 'does not create a subscription' do
        expect(Subscription.exists?(subscribing_user, subscriptable)).to be_truthy
        
        expect do 
          patch :add_subscription, params: { id: subscriptable.id, user_id: subscribing_user.id }
        end.to change(subscriptable.subscriptions, :count).by(0)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#delete_subscription' do
    context 'when user already subscribed' do
      before do
        sign_in subscribing_user
      end

      let!(:subscription) { create(:subscription, subscriptable: subscriptable, user: subscribing_user) }

      it 'deletes the subscription' do
        expect(Subscription.exists?(subscribing_user, subscriptable)).to be_truthy
        delete :delete_subscription, params: { id: subscriptable.id }
        expect(Subscription.exists?(subscribing_user, subscriptable)).to be_falsey
        expect(response).to redirect_to question_path(subscriptable)
      end
    end
    
  end
end

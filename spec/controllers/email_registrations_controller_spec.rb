require 'rails_helper'

RSpec.describe EmailRegistrationsController, type: :controller do
  let(:email_registration) { create(:email_registration) }
  

  describe 'GET #new' do
    let(:user) { create(:user) }
    before { get :new }

    it 'assigns a new email_registration to @email_registration' do
      expect(assigns(:email_registration)).to be_a_new(EmailRegistration)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'user exists, but identity not' do
      let!(:user) { create(:user, email: email_registration.email) } 

      it 'creates identity for user and provider uid' do
        expect do
            post :create, params: { email_registration: attributes_for(:email_registration) }
          end.to change(Identity, :count).by(1)
      end
      it 'redirects to login view' do
        post :create, params: { email_registration: attributes_for(:email_registration) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'user not exists, identity not exists' do
      it 'creeates new email_registration' do
        expect do
          post :create, params: { email_registration: attributes_for(:email_registration) }
        end.to change(EmailRegistration, :count).by(1)
      end

      it 'sends the confirmation message to email' do
        expect {EmailRegistrationMailer.confirm_email_registration(email_registration).deliver}.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'redirects to login view' do
        post :create, params: { email_registration: attributes_for(:email_registration) }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'does not save email_registration if it is incorrect' do
        expect do
          post :create, params: { email_registration: attributes_for(:email_registration, :invalid) }
        end.not_to change(EmailRegistration, :count)
      end

      it 'renders new email_registration form if email_registration is incorrect' do
        post :create, params: { email_registration: attributes_for(:email_registration, :invalid) }
        expect(response).to render_template :new
      end
    end

  end

  describe "GET #confirm" do
    context "confirmation parameters correspond to email_registration, user exists" do
      let!(:user) { create(:user) }
      let!(:email_registration) { create(:email_registration, email: user.email) }

      it "updates email registration status and confirmation date" do
        get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        email_registration.reload
        expect(email_registration.confirmed).to be true
        expect(email_registration.confirmed_at.utc).to be_within(1.second).of Time.now 
      end

      it "creates identity for user" do
        expect do
          get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        end.to change(Identity, :count).by(1)
        expect(Identity.last.user_id).to eq user.id
      end

      it "redirects to login page" do
        get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        expect(response).to redirect_to new_user_session_path
      end

    end

    context "confirmation parameters are ok, user not exists" do
      it "updates email registration status and confirmation date" do
        get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        email_registration.reload
        expect(email_registration.confirmed).to be true
        expect(email_registration.confirmed_at.utc).to be_within(1.second).of Time.now 
      end

      it "creates user by email" do
        expect do
          get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        end.to change(User, :count).by(1)
        expect(User.last.email).to eq email_registration.email
      end

      it "creates identity for user" do
        expect do
          get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        end.to change(Identity, :count).by(1)
        expect(Identity.last.user_id).to eq User.last.id
      end

      it "redirects to login page" do
        get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: email_registration.confirmation_token }
        expect(response).to redirect_to new_user_session_path
      end

    end

    context "confirmation parameters are invalid" do
      it "redirects to login page" do 
        get :confirm, params: { id: email_registration.id, email: email_registration.email, confirmation_token: nil }
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end

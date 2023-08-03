require 'rails_helper'

describe 'Profiles API', type: :request do
  describe 'GET /api/v1/profiles/me' do
    let!(:api_path) { "/api/v1/profiles/me" }
      
    it_behaves_like "API authorizable" do
      let(:method) { :get }
    end

    # let(:headers) { { 'CONTEXT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
    # context 'when user unauthorized' do
    #   it 'and has no access token it returns 401' do
    #     get('/api/v1/profiles/me', headers:)
    #     expect(response.status).to eq 401
    #   end
    #   it 'and access token is invalid it returns 401' do
    #     get('/api/v1/profiles/me', params: { access_token: '123' }, headers:)
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'when user authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: }

      it 'it returns 200' do
        expect(response).to be_successful
      end

      it 'it returns public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(api_response_json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'it does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(api_response_json).not_to have_key(attr)
        end
      end
    end
  end
end

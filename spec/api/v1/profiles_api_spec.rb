require "rails_helper"

describe "Profiles API", type: :request do
  describe "GET /api/v1/profiles/me" do
    let!(:api_path) { "/api/v1/profiles/me" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns public fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(api_response_json["user"][attr]).to eq me[attr].as_json
        end
      end

      it "it does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(api_response_json["user"]).not_to have_key(attr)
        end
      end
    end
  end

  describe "GET /api/v1/profiles/others" do
    let!(:api_path) { "/api/v1/profiles/others" }
    
    context "and user unauthorized" do
      it_behaves_like "API unauthorized"
    end

    context "and user authorized" do
      let!(:me) { create(:user, admin: true) }
      let!(:users) { create_list(:user, 3) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns array of users" do
        expect(api_response_json["users"].size).to eq 3
      end

      it "it does not return my profile" do
        api_response_json["users"].each do |returned_user|
          expect(returned_user["id"]).to_not eq me.id
        end
      end

      it "it returns public fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(api_response_json["users"].first[attr]).to eq users.first[attr].as_json
        end
      end

      it "it does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(api_response_json["users"].first).not_to have_key(attr)
        end
      end
    end
  end
end


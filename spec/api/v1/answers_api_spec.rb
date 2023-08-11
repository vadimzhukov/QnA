require "rails_helper"

describe "Answers API", type: :request do
  describe "GET /api/v1/questions/:id/answers" do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      let!(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns array of answers" do
        expect(api_response_json["answers"].size).to eq 3
      end

      it "it returns public fields" do
        [:id, :body, :user_id, :created_at, :updated_at].each do |attr|
          expect(api_response_json["answers"].first[attr.to_s]).to eq answers.first[attr].as_json
        end
      end

      it "it does not return private fields" do
        [:rating, :files, :links].each do |attr|
          expect(api_response_json["answers"].first).not_to have_key(attr.to_s)
        end
      end
    end
  end

  describe "GET /api/v1/answers/:id" do
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:answer) { create(:answer, :with_file, user: me) }
    let!(:links) { create_list(:link, 3, linkable: answer)}
    let!(:comments) { create_list(:comment, 5, commentable: answer, user_id: me.id)}
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      
      
      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns one answer" do
        expect(api_response_json.size).to eq 1
      end

      it "it returns public fields" do
        [:id, :body, :created_at, :updated_at].each do |attr|
          expect(api_response_json["answer"][attr.to_s]).to eq answer[attr.to_s].as_json
        end
      end

      it "it returns comments of answer" do
        expect(api_response_json["answer"]["commments"]).to eq answer["comments"].as_json
      end

      it "it returns files of answer with correct filenames" do
        filename_from_api_json = api_response_json['answer']['files'].first['filename']
        filename_from_factory_object = answer.files.map { |file| { 'filename' => file.filename.to_s}}.first['filename']
        expect(filename_from_api_json).to eq filename_from_factory_object
      end

      it "it returns links of answer with correct name and url" do
        expect(api_response_json["answer"]["links"].first["name"]).to eq answer.links.first["name"]
        expect(api_response_json["answer"]["links"].first["url"]).to eq answer.links.first["url"]
      end

      it "it returns public fields of user created answer" do
        [:id, :email, :admin, :created_at, :updated_at].each do |attr|
          expect(api_response_json["answer"]["user"][attr.to_s]).to eq me[attr].as_json
        end
      end

      it "it does not return private fields" do
        [:user_id].each do |attr|
          expect(api_response_json["answer"]).not_to have_key(attr.to_s)
        end
      end
    end
  end

  describe "POST /api/v1/questions/:id/answers" do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
    
      context "with valid attributes" do
        it "it returns status 200" do
          post api_path, params: { access_token: access_token.token, body: "test answer body" }
          expect(response.status).to eq 200
        end

        it 'saves answer to database' do
          expect do
            post api_path, params: { access_token: access_token.token, body: "test answer body" }
          end.to change(Answer, :count).by(1)
        end

        it "it responses with saved answer attributes json" do
          post api_path, params: { access_token: access_token.token, body: "test answer body" }
          expect(api_response_json["answer"]["body"]).to eq "test answer body"
        end
      end

      context 'with invalid attributes' do
        it 'not save answer to database' do
          expect do
            post api_path, params: { access_token: access_token.token, body: "" }
          end.not_to change(Answer, :count)
          end

        it "it returns status 400 with error Bad request" do
          post api_path, params: { access_token: access_token.token, body: "" }
          expect(response.status).to eq 400
          expect(api_response_json["error"]).to eq "Bad request"
        end
      end
    end
  end

  describe "PATCH /api/v1/answers/:id" do
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:answer) { create(:answer, user_id: me.id)}
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      before { patch api_path, params: { access_token: access_token.token, body: "changed answer body" } }
      
      it "it returns status 200" do
        expect(response.status).to eq 200
      end

      context "with valid attributes" do
        it "change attributes of answer in db" do
          answer.reload
          expect(answer.body).to eq "changed answer body"
        end

        it "responses with new attributes of answer" do
          expect(api_response_json["answer"]["body"]).to eq "changed answer body"
        end
      end

      context 'with invalid attributes', format: :js do
        before { patch api_path, params: { access_token: access_token.token, body: "" } }
        
        it 'does not change attributes of answer' do
          answer.reload  
          expect(answer.body).to eq answer.body
        end

        it "it returns status 400" do
          expect(response.status).to eq 400
        end

        it "it response with error Bad request" do
          expect(api_response_json["error"]).to eq "Bad request"
        end
      end

      context "other's answer" do
        let!(:others_answer) { create(:answer)}
        let(:api_path_others_answer) { "/api/v1/answers/#{others_answer.id}" }
    
        it 'does not change answer attributes' do
          patch api_path_others_answer, params: { access_token: access_token.token, body: "changed answer body" }
          answer.reload
          expect(answer.body).to eq answer.body
        end
      end
    end
  end

  describe "DELETE /api/v1/answers/:id" do
    let!(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:answer) { create(:answer, user_id: me.id)}
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      context "self answer" do
        it "it returns status 200" do
          delete api_path, params: { access_token: access_token.token }
          expect(response.status).to eq 200
        end

      
        it "deleted from db " do
          expect do
            delete api_path, params: { access_token: access_token.token }
          end.to change(Answer, :count).by(-1)
        end
      end

      context "other's answer" do
        let!(:others_answer) { create(:answer)}
        let(:api_path_others_answer) { "/api/v1/answers/#{others_answer.id}" }
    
        it 'does not delete answer from db' do
          expect do
            delete api_path_others_answer, params: { access_token: access_token.token }
          end.to change(Answer, :count).by(0)
        end
      end
    end
  end
end

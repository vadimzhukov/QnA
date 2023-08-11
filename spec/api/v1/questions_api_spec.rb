require "rails_helper"

describe "Questions API", type: :request do
  describe "GET /api/v1/questions" do
    let(:api_path) { "/api/v1/questions" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      let!(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:questions) { create_list(:question, 3) }

      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns array of questions" do
        expect(api_response_json["questions"].size).to eq 3
      end

      it "it returns public fields" do
        [:id, :title, :body, :user_id, :created_at, :updated_at].each do |attr|
          expect(api_response_json["questions"].first[attr.to_s]).to eq questions.first[attr].as_json
        end
      end

      it "it does not return private fields" do
        [:rating, :files, :links].each do |attr|
          expect(api_response_json["questions"].first).not_to have_key(attr.to_s)
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:question) { create(:question, :with_file, user: me) }
    let!(:links) { create_list(:link, 3, linkable: question)}
    let!(:comments) { create_list(:comment, 5, commentable: question, user_id: me.id)}
    let!(:answers) { create_list(:answer, 4, question: question, user_id: me.id)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      
      
      before { get api_path, params: { access_token: access_token.token } }

      it_behaves_like "API authorized"

      it "it returns one question" do
        expect(api_response_json.size).to eq 1
      end

      it "it returns public fields" do
        [:id, :title, :body, :created_at, :updated_at].each do |attr|
          expect(api_response_json["question"][attr.to_s]).to eq question[attr.to_s].as_json
        end
      end

      it "it returns comments of question" do
        expect(api_response_json["question"]["commments"]).to eq question["comments"].as_json
      end

      it "it returns answers of question" do
        expect(api_response_json["question"]["answers"]).to eq question["answers"].as_json
      end

      it "it returns files of question with correct filenames" do
        filename_from_api_json = api_response_json['question']['files'].first['filename']
        filename_from_factory_object = question.files.map { |file| { 'filename' => file.filename.to_s}}.first['filename']
        expect(filename_from_api_json).to eq filename_from_factory_object
      end

      it "it returns links of question with correct name and url" do
        expect(api_response_json["question"]["links"].first["name"]).to eq question.links.first["name"]
        expect(api_response_json["question"]["links"].first["url"]).to eq question.links.first["url"]
      end

      it "it returns public fields of user created question" do
        [:id, :email, :admin, :created_at, :updated_at].each do |attr|
          expect(api_response_json["question"]["user"][attr.to_s]).to eq me[attr].as_json
        end
      end

      it "it does not return private fields" do
        [:user_id].each do |attr|
          expect(api_response_json["question"]).not_to have_key(attr.to_s)
        end
      end
    end
  end

  describe "POST /api/v1/questions" do
    let(:api_path) { "/api/v1/questions" }
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
    
      context "with valid attributes" do
        it "it returns status 200" do
          post api_path, params: { access_token: access_token.token, title: "test question title", body: "test question body" }
          expect(response.status).to eq 200
        end

        it 'saves question to database' do
          expect do
            post api_path, params: { access_token: access_token.token, title: "test question title", body: "test question body" }
          end.to change(Question, :count).by(1)
        end

        it "it responses with saved question attributes json" do
          post api_path, params: { access_token: access_token.token, title: "test question title", body: "test question body" }
          expect(api_response_json["question"]["title"]).to eq "test question title"
          expect(api_response_json["question"]["body"]).to eq "test question body"
        end
      end

      context 'with invalid attributes' do
        it 'not save question to database' do
          expect do
            post api_path, params: { access_token: access_token.token, title: "", body: "test question body" }
          end.not_to change(Question, :count)
          end

        it "it returns status 400 with error Bad request" do
          post api_path, params: { access_token: access_token.token, title: "", body: "changed question body" }
          expect(response.status).to eq 400
          expect(api_response_json["error"]).to eq "Bad request"
        end
      end
    end
  end

  describe "PATCH /api/v1/questions/:id" do
    let(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:question) { create(:question, user_id: me.id)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      before { patch api_path, params: { access_token: access_token.token, title: "changed question title", body: "changed question body" } }
      
      it "it returns status 200" do
        expect(response.status).to eq 200
      end

      context "with valid attributes" do
        it "change attributes of question in db" do
          question.reload
          expect(question.title).to eq "changed question title"
          expect(question.body).to eq "changed question body"
        end

        it "responses with new attributes of question" do
          expect(api_response_json["question"]["title"]).to eq "changed question title"
          expect(api_response_json["question"]["body"]).to eq "changed question body"
        end
      end

      context 'with invalid attributes', format: :js do
        before { patch api_path, params: { access_token: access_token.token, title: "", body: "changed question body" } }
        
        it 'does not change attributes of question' do
          question.reload  
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it "it returns status 400" do
          expect(response.status).to eq 400
        end

        it "it response with error Bad request" do
          expect(api_response_json["error"]).to eq "Bad request"
        end
      end

      context "other's question" do
        let!(:others_question) { create(:question)}
        let(:api_path_others_question) { "/api/v1/questions/#{others_question.id}" }
    
        it 'does not change question attributes' do
          patch api_path_others_question, params: { access_token: access_token.token, title: "changed question title", body: "changed question body" }
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
      end
    end
  end

  describe "DELETE /api/v1/questions/:id" do
    let!(:me) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let!(:question) { create(:question, user_id: me.id)}
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    
    it_behaves_like "API unauthorized"

    context "and user authorized" do
      context "self question" do
        it "it returns status 200" do
          delete api_path, params: { access_token: access_token.token }
          expect(response.status).to eq 200
        end

      
        it "deleted from db " do
          expect do
            delete api_path, params: { access_token: access_token.token }
          end.to change(Question, :count).by(-1)
        end
      end

      context "other's question" do
        let!(:others_question) { create(:question)}
        let(:api_path_others_question) { "/api/v1/questions/#{others_question.id}" }
    
        it 'does not delete question from db' do
          expect do
            delete api_path_others_question, params: { access_token: access_token.token }
          end.to change(Question, :count).by(0)
        end
      end
    end
  end
end

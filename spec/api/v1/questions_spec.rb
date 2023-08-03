require "rails_helper"

describe "Questions API", type: :request do
  describe "GET /api/v1/questions" do
    let(:method) { :get }
    
    it_behaves_like "API authorizable" do
      let(:api_path) { "/api/v1/questions" }
    end

    let(:headers) { { "CONTEXT-TYPE" => "application/json", "ACCEPT" => "application/json" } }

    # context "when user unauthorized" do
    #   it "and has no access token it returns 401" do
    #     get("/api/v1/questions", headers:) 
    #     expect(response.status).to eq 401
    #   end
    #   it "and access token is invalid it returns 401" do
    #     get("/api/v1/questions", params: { access_token: "123" }, headers:)
    #     expect(response.status).to eq 401
    #   end
    # end
    context "when user authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_from_response) { api_response_json["questions"].first }

      # answers of question
      let!(:answers) { create_list(:answer, 3, question:) }

      before { get api_path, params: { access_token: access_token.token }, headers: }


      #  --------- checking questions and question attributes -------
      it "it returns 200" do
        expect(response).to be_successful
      end

      it "it returns list of questions" do
        expect(api_response_json["questions"].size).to eq 2
      end

      it "it returns public fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_from_response[attr]).to eq question.send(attr).as_json
        end
      end

      it "it returns user object" do
        expect(question_from_response["user"]["id"]).to eq question.user.id
      end

      # -------- checking answers of question ------------

      describe "answers" do
        let(:answer) { answers.first }
        let(:answer_from_response) { question_from_response["answers"].first }

        it "it returns list of answers" do
          expect(question_from_response["answers"].size).to eq 3
        end

        it "it returns public fields" do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_from_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end

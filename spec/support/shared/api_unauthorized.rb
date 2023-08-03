shared_examples_for "API unauthorized" do
  context "and user unauthorized" do
    it "he has no access_code" do
      get(api_path)
      expect(response.status).to eq 401
    end

    it "his access_token is invalid" do
      get(api_path, params: { access_token: "1234" } )
      expect(response.status).to eq 401
    end
  end
end

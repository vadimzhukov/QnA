shared_examples_for "API authorized" do
  it "it responds with status 200" do
    expect(response.status).to eq 200
  end
end

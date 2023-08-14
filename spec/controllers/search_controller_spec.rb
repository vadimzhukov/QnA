require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #find' do
    let!(:questions) { create_list(:question, 3) }
    

    it 'controller receives find method' do
      expect(subject).to receive(:find)
      get :find, params: { query: "Test", entity: "all" }
    end

    it "ThinkingSphinx receives #search with search query" do
      thinking_sphinx = double("TinkingSphinx")
      allow(thinking_sphinx).to receive(:search).with("Title")
      get :find, params: { query: "Title", entity: "all" }
    end
  end
end

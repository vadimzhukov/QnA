shared_examples_for "API authorizable" do
  let(:headers) { { 'CONTEXT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  context 'when user unauthorized' do
    it 'and has no access token it returns 401' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'and access token is invalid it returns 401' do
      do_request(method, api_path, params: { access_token: '123' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

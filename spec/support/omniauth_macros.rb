module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "provider" => "github",
      "uid" => "123",
      "info" => {
        "email" => "test@email.com"
      },
      "credentials" => {
        "token" => "token123",
        "secret" => "secret123"
      }
    })
  end
end

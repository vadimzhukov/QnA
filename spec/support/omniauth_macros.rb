module OmniauthMacros
  def mock_auth_hash_with_email(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      "provider" => provider.to_s,
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

  def mock_auth_hash_without_email(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      "provider" => provider.to_s,
      "uid" => "123",
      "info" => {
      "email" => nil
      },
      "credentials" => {
        "token" => "token123",
        "secret" => "secret123"
      }
    })
  end
end

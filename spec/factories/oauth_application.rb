FactoryBot.define do
  factory "oauth_application", class: "Doorkeeper::Application" do
    name { "Rspec oauth application" }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    uid { "11223344" }
    secret { "123456" }
  end
end

require 'rails_helper'
require 'validate_url/rspec_matcher'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_presence_of :url }
  it { is_expected.to validate_url_of(:url) }
  it { expect(Link.new(name: "name", url: "abc").gist?).to be_falsy }
  it { expect(Link.new(name: "name", url: "https://gist.github.com").gist?).to be_truthy }
end

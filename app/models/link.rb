class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: {no_local: true}

  def gist?
    url.start_with? "https://gist.github.com"
  end

end

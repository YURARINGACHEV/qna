class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def gist_id
    URI.parse(url).path.split('/').last
  end
end

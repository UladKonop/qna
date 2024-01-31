class Link < ApplicationRecord
  URL_REGEX = %r{((https|http)?:?(//))?(www\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_+.~#?&/=]*)}

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates :url, format: { with: URL_REGEX }

  def is_a_gist?
    url.match?(/gist\.github\.com/)
  end

  def gist_content
    if is_a_gist?
      GistService.new(url.match('gist.github.com\/\w+\/(?<gist_id>\w+)\z')[:gist_id])
                 .call
    end
  end
end

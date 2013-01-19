class Post
  include Mongoid::Document

  def youtube_id
    CGI.parse(URI.parse(self.link).query)['v'].first
  end

  def youtube_info
    {
      name: self.name,
      id: youtube_id
    }
  end
end

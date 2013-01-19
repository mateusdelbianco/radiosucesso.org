class WelcomeController < ApplicationController

  def index
    PostFetcher.synchronize_if_needed
    @page = PostFetcher.page
    @posts = Post.where(:type => 'video').order_by(:created_time.desc)
  end

  def next_id
    post = Post.only(:link, :name).sample
    render json: {
      title: post.name,
      id: CGI.parse(URI.parse(post.link).query)['v'].first
    }
  end
end

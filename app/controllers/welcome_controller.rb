class WelcomeController < ApplicationController
  def index
    PostFetcher.synchronize_if_needed
    @page = PostFetcher.page
  end

  def videos
    @posts = Post.where(:type => 'video').order_by(:created_time.desc)
  end

  def next_id
    post = Post.only(:link, :name).sample
    render json: post.youtube_info
  end
end

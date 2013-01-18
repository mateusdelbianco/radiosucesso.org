class WelcomeController < ApplicationController

  def index
    PostFetcher.synchronize_if_needed
    @posts = Post.where(:type => 'video').order_by(:created_time.desc)
  end
end

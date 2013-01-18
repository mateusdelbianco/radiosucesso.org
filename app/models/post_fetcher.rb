class PostFetcher
  include Mongoid::Document

  class << self
    def document
      (first || new)
    end

    def facebook
      return @facebook if @facebook
      Koala.http_service.http_options = { :ssl => { :verify_mode => OpenSSL::SSL::VERIFY_NONE } }
      @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], '')
      @facebook = Koala::Facebook::API.new(@oauth.get_app_access_token)
      @page = @facebook.get_object('radiosucesso.org')
      @facebook
    end

    def page
      facebook
      @page
    end

    def get_new_posts
      posts = facebook.get_connections('radiosucesso.org', 'posts')
      @known_posts = posts.collect{|l| l['id']}

      posts.each do |post|
        Post.find_or_initialize_by(:fb_id => post['id']).update_attributes(post)
      end
    end

    def remove_old_posts
      Post.where(:fb_id.nin => @known_posts).each do |post|
        begin
          object = facebook.get_object(post['fb_id'])
          if object.try(:[], "from").try(:[], "id") != @page['id']
            post.destroy
          end
        rescue Koala::Facebook::ClientError
          post.destroy
        end
      end
    end

    def synchronize
      get_new_posts
      remove_old_posts
      document.update_attribute(:last_sync, Time.now)
    end

    def synchronization_needed
      if document.respond_to?(:last_sync)
        document.last_sync < Time.now - 1.minutes
      else
        true
      end
    end

    def synchronize_if_needed
      synchronize if synchronization_needed
    end
  end
end

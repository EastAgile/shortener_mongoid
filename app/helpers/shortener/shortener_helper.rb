module Shortener::ShortenerHelper

  # generate a url from a url string
  def short_url(url, owner=nil, root_url=nil)
    short_url = Shortener::ShortenedUrl.generate(url, owner)
    if short_url
      url_hash = {}
      if root_url
        uri = URI.parse(root_url)
        url_hash[:host] = uri.host
        url_hash[:port] = uri.port == 80 ? nil : uri.port
      end
      url_for({ :controller => :"shortener/shortened_urls", :action => :show, :id => short_url.unique_key, :only_path => false }.merge(url_hash))
    else
      url
    end
  end

  # Get the full URL from a short URL
  def full_url(short_url)
    begin
      short_url = Shortener::ShortenedUrl.where(unique_key: short_url[-5..-1]).first
    rescue Mongoid::Errors::DocumentNotFound => e
      nil
    end
    return short_url.nil? ? nil : short_url.url
  end

end

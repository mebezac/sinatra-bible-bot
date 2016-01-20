require 'sinatra'
require 'json'

class BibleSearcher
  def initialize(text = '')
    @text = text
  end

  def search
    @url = "https://www.biblegateway.com/passage/?search=#{search_text}#{'&version=' + version if version != ''}"
  end

  def split_text
    @split_text ||= @text.split(' ')
  end

  def version
    return '' if split_text.count < 3
    last_string = split_text[-1]
    return '' if /\d/.match(last_string)
    last_string
  end

  def search_text
    if version != ''
      split_text[0..-2].join('%20')
    else
      split_text.join('%20')
    end
  end
end

get '/' do
  content_type :json
  JSON::dump({text: BibleSearcher.new(params[:text]).search, response_type: "in_channel", unfurl_links: true})
end

require 'mandrill'
require 'mandrill_template/client'

module MandrillClient
  def self.client
    Mandrill::API.new ENV['MANDRILL_APIKEY']
  end
end

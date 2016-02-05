require 'mandrill'
require 'mandrill_template/client'

module MandrillClient
  def self.templates_directory
    ENV['MANDRILL_TEMPLATES_DIR'] || "templates"
  end

  def self.client
    Mandrill::API.new ENV['MANDRILL_APIKEY']
  end
end

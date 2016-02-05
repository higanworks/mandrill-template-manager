require 'mandrill'
require 'yaml'

module MandrillTemplate
  class Local < Hash
    attr_reader :name, :avail

    def initialize(name)
      @name       = name
      meta, code, text = load_data(name)

      self['name']       = name
      self['slug']       = meta['slug']       ||= name
      self['from_email'] = meta['from_email'] ||= nil
      self['from_name']  = meta['from_name']  ||= nil
      self['subject']    = meta['subject']    ||= nil
      self['labels']     = meta['labels']     ||= []

      self['code']       = code               ||= nil
      self['text']       = text               ||= nil
    end

    def templates_directory
      MandrillClient.templates_directory
    end

    def load_data(name)
      if Dir.exists?(File.join(templates_directory, name))
        @avail = true
        code = File.read(File.join(templates_directory, name, "code"))
        text = File.read(File.join(templates_directory, name, "text"))
        [
          YAML.load_file(File.join(templates_directory, name, "metadata.yml")),
          code.empty? ? nil : code,
          text.empty? ? nil : text
        ]
      else
        [{}, nil, nil]
      end
    end
  end
end

require 'mandrill'
require 'yaml'

module MandrillTemplate
  class Local < Hash
    attr_reader :slug, :avail

    def initialize(slug)
      @slug = slug
      meta, code, text = load_data(slug)

      self['name']       = meta['name']       ||= slug
      self['slug']       = meta['slug']       ||= slug
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

    def load_data(slug)
      if Dir.exists?(File.join(templates_directory, slug))
        @avail = true
        code = File.read(File.join(templates_directory, slug, "code"))
        text = File.read(File.join(templates_directory, slug, "text"))
        [
          YAML.load_file(File.join(templates_directory, slug, "metadata.yml")),
          code.empty? ? nil : code,
          text.empty? ? nil : text
        ]
      else
        [{}, nil, nil]
      end
    end
  end
end

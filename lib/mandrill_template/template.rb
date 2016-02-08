require 'mandrill'
require 'yaml'
require 'fileutils'

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
        code = File.read(File.join(templates_directory, slug, "code.html"))
        text = File.read(File.join(templates_directory, slug, "text.txt"))
        [
          YAML.load_file(File.join(templates_directory, slug, "metadata.yml")),
          code.empty? ? nil : code,
          text.empty? ? nil : text
        ]
      else
        [{}, nil, nil]
      end
    end

    def delete!
      dir_name = File.join(templates_directory, slug)
      puts dir_name
      if Dir.exists?(dir_name)
        FileUtils.rm_rf(dir_name)
      end
    end
  end
end

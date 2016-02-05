require 'mandrill'
require 'mandrill_template/client'
require 'mandrill_template/template'
require 'formatador'
require 'unicode' unless ['jruby'].include?(RbConfig::CONFIG['ruby_install_name'])
require 'yaml'
require "mandrill_template/monkey_create_file"
autoload "Handlebars", 'handlebars'

class MandrillTemplateManager < Thor
  include Thor::Actions
  VERSION = "0.2.2"

  desc "export_all", "export all templates from remote to local files."
  def export_all
    remote_templates = MandrillClient.client.templates.list
    remote_templates.each do |template|
      export(template["slug"])
    end
  end

  desc "export NAME", "export template from remote to local files."
  def export(name)
    template = MandrillClient.client.templates.info(name)
    meta, code, text  = build_template_for_export(template)
    save_as_local_template(name, meta, code, text)
  end

  desc "upload NAME", "upload template to remote as draft."
  def upload(name)
    template = MandrillTemplate::Local.new(name)
    if template.avail
      upload_template(template)
    else
      puts "Template data not found #{name}. Please generate first."
    end
  end

  desc "delete NAME", "delete template from remote."
  def delete(name)
    begin
      result = MandrillClient.client.templates.delete(name)
      puts result.to_yaml
    rescue Mandrill::UnknownTemplateError => e
      puts e.message
    end
  end

  desc "generate NAME", "generate new template files."
  def generate(name)
    new_template = MandrillTemplate::Local.new(name)
    puts new_template.class
    meta, code, text = build_template_for_export(new_template)
    save_as_local_template(name, meta, code, text)
  end

  desc "publish NAME", "publish template from draft."
  def publish(name)
    puts MandrillClient.client.templates.publish(name).to_yaml
  end

  desc "render NAME [PARAMS_FILE]", "render mailbody from local template data. File should be Array. see https://mandrillapp.com/api/docs/templates.JSON.html#method=render."
  option :handlebars, type: :boolean, default: false
  def render(name, params = nil)
    merge_vars =  params ? JSON.parse(File.read(params)) : []
    template = MandrillTemplate::Local.new(name)
    if template.avail
      if options[:handlebars]
        handlebars = Handlebars::Context.new
        h_template = handlebars.compile(template['code'])
        puts h_template.call(localize_merge_vars(merge_vars))
      else
        result = MandrillClient.client.templates.render template.name,
          [{"content"=>template["code"], "name"=>template.name}],
          merge_vars
        puts result["html"]
      end
    else
      puts "Template data not found #{name}. Please generate first."
    end
  end

  desc "list", "show template list both of remote and local."
  option :verbose, type: :boolean, default: false, aliases: :v
  def list
    puts "Remote Templates"
    puts "----------------------"
    remote_templates = MandrillClient.client.templates.list
    remote_templates.map! do |template|
      template["has_diff"] = has_diff_between_draft_and_published?(template)
      template
    end

    if options[:verbose]
    Formatador.display_compact_table(
      remote_templates,
      ["has_diff",
       "name",
       "slug",
       "publish_name",
       "draft_updated_at",
       "published_at",
       "labels",
       "subject",
       "publish_subject",
       "from_email",
       "publish_from_email",
       "from_name",
       "publish_from_name"]
    )
    else
      Formatador.display_compact_table(
        remote_templates,
        ["has_diff",
         "name",
         "slug",
         "from_email",
         "from_name",
         "subject",
         "labels",
         "from_name"]
      )
    end

    puts "Local Templates"
    puts "----------------------"
    Formatador.display_compact_table(
      collect_local_templates,
      [
        "name",
        "slug",
        "from_email",
        "from_name",
        "subject",
        "labels"
      ]
    )
  end

  private

  def has_diff_between_draft_and_published?(t)
    %w[name code text subject].each do |key|
      return true if t[key] != t["publish_#{key}"]
    end
    return true unless t['published_at']
    false
  end

  def build_template_for_export(t)
    [
      {
        "slug"       => t['slug'],
        "labels"     => t['labels'],
        "subject"    => t['subject'],
        "from_email" => t['from_email'],
        "from_name"  => t['from_name']
      },
      t['code'],
      t['text']
    ]
  end

  def templates_directory
    MandrillClient.templates_directory
  end

  def save_as_local_template(name, meta, code, text)
    empty_directory File.join(templates_directory, name)
    create_file File.join(templates_directory, name, "metadata.yml"), meta.to_yaml
    create_file File.join(templates_directory, name, "code"), code
    create_file File.join(templates_directory, name, "text"), text
  end

  def collect_local_templates
    local_templates = []
    dirs = Dir.glob("#{ templates_directory }/*").map {|path| path.split(File::SEPARATOR).last}
    dirs.map do |dir|
      begin
      local_templates << MandrillTemplate::Local.new(dir)
      rescue
        next
      end
    end
    local_templates
  end

  def upload_template(t)
    if remote_template_exists?(t.name)
      method = :update
    else
      method = :add
    end
    result = MandrillClient.client.templates.send(method, t.name,
      t['from_email'],
      t['from_name'],
      t['subject'],
      t['code'],
      t['text'],
      false, # publish
      t['labels']
    )
    puts result.to_yaml
  end

  def remote_template_exists?(name)
    begin
      MandrillClient.client.templates.info(name)
      true
    rescue Mandrill::UnknownTemplateError
      false
    end
  end

  def localize_merge_vars(merge_vars)
    h = {}
    merge_vars.each {|kv| h[kv["name"]] = kv["content"] }
    h
  end
end

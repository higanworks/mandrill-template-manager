# Mandrill Template Manager (CLI)

Manage [Mandrill Templates](https://mandrillapp.com/api/docs/templates.ruby.html) by CLI.

## Install

Add Gemfile and bundle.

```
gem 'mandrill-template-manager'

## Recommend for using multibyte language.
gem 'formatador', github: 'geemus/formatador'
gem 'unicode'
```

```
$ bundle install
```

```
$ bundle exec mandrilltemplate
Commands:
  mandrilltemplate delete SLUG                # delete template from remote.
  mandrilltemplate export SLUG                # export template from remote to local files.
  mandrilltemplate export_all                 # export all templates from remote to local files.
  mandrilltemplate generate SLUG              # generate new template files.
  mandrilltemplate help [COMMAND]             # Describe available commands or one specific command
  mandrilltemplate list                       # show template list both of remote and local.
  mandrilltemplate publish SLUG               # publish template from draft.
  mandrilltemplate render SLUG [PARAMS_FILE]  # render mailbody from local template data. File should be Array. see https://mandrillapp.com/api/docs/templates.JSON.html#method=render.
  mandrilltemplate upload ALL                 # upload all template to remote as draft.
  mandrilltemplate upload SLUG                # upload template to remote as draft.

```

## Workflow

1. generate new or export exist template as local files.
2. modify and manage under version control system.
3. upload template.
4. publish it.


## Setup

APIKEY is read from environment variable.

```
export MANDRILL_APIKEY='your api key'
```


## List templates

```
$ mandrilltemplate list

Remote Templates
----------------------
  +----------+----------+----------+--------------+---------------------+---------------------+--------+---------------+-----------------+------------------+--------------------+-----------+-------------------+
  | has_diff | name     | slug     | publish_name | draft_updated_at    | published_at        | labels | subject       | publish_subject | from_email       | publish_from_email | from_name | publish_from_name |
  +----------+----------+----------+--------------+---------------------+---------------------+--------+---------------+-----------------+------------------+--------------------+-----------+-------------------+
  ... remote templates ...

Local Templates
----------------------
  +----------+----------+------------------+-----------+--------------------+------------------------+
  | name     | slug     | from_email       | from_name | subject            | labels                 |
  +----------+----------+------------------+-----------+--------------------+------------------------+
  ... local templates ...

```

you can also specify a label to filter this list:

```
$ mandrilltemplate list LABEL
```


## Downloading templates from Mandrill

```
$ mandrilltemplate export SLUG
```

or

```
$ mandrilltemplate export_all
```



## Uploading and publishing templates

```
$ mandrilltemplate upload SLUG
```

```
$ mandrilltemplate publish SLUG
```

or, both at once:

```
$ mandrilltemplate upload SLUG --publish
```


## Deleting templates

```
$ mandrilltemplate delete SLUG
```

will delete from server only.

```
$ mandrilltemplate upload SLUG --delete_local
```

will also delete local files.



## Template local files

Templates are stored by defualt into `templates/` directory.

You can control this by setting the MANDRILL_TEMPLATES_DIR environment variable.

```
export MANDRILL_TEMPLATES_DIR=mandrill_templates
```

```
templates/
├── ${template_slug1}
│   ├── code.html    # code contents
│   ├── metadata.yml # metadata of template
│   └── text.txt     # text contents
├── ${template_slug2}
│   ├── code.html
│   ├── metadata.yml
│   └── text.txt
└── ${template_slug3}
    ├── code.html
    ├── metadata.yml
    └── text.txt
```

example of metadata.yml

```
---
slug: mission
labels: []
subject: "Today's your mission"
from_email: test@example.com
from_name: Boss
```

## Optional: render supports Handlebars preview.

If you would like to use handlebars template.
You should add handlebars rubygem to Gemfile.

```
gem 'mandrill-template-manager'
gem 'handlebars'
# if fails on OSX to install Handlebars, try below.
# bundle config build.libv8 --with-system-v8
```

And, pass `--handlebars` option to render subcommand.
It will be compiled as Handlebars Template.

```
Usage:
  mandrilltemplate render SLUG [PARAMS_FILE]

Options:
  [--handlebars], [--no-handlebars]
```

> Note: This feature provides without api call.
> I can't guarantee that this will work same as send api.

Json example. This is same format when using send api.

```
[
  {
    "name": "UserName",
    "content": "ExampleUser"
  },
  {
    "name": "ImpossibleMissions",
    "content": [
      "Mission A",
      "Mission B",
      "Mission C"
    ]
  }
]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


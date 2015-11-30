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
  mandrilltemplate delete NAME                # delete template from remote.
  mandrilltemplate export NAME                # export template from remote to local files.
  mandrilltemplate generate NAME              # generate new template files.
  mandrilltemplate help [COMMAND]             # Describe available commands or one specific command
  mandrilltemplate list                       # show template list both of remote and local.
  mandrilltemplate publish NAME               # publish template from draft.
  mandrilltemplate render NAME [PARAMS_FILE]  # render mailbody from local template data. File should be Array. see https://mandrillapp.com/api/docs/templates.JSON.html#method=render.
  mandrilltemplate upload NAME                # upload template to remote as draft.

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

Next, check by list subcommand.

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


## Template local files

Templates are stored into `templates/` directory.

```
templates/
├── ${template_name1}
│   ├── code         # code contents
│   ├── metadata.yml # metadata of template
│   └── text         # text contents
├── ${template_name2}
│   ├── code
│   ├── metadata.yml
│   └── text
└── ${template_name3}
    ├── code
    ├── metadata.yml
    └── text
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
  mandrilltemplate render NAME [PARAMS_FILE]

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


# Mandrill Template Manager(CLI)

Manage [Mandrill Templates](https://mandrillapp.com/api/docs/templates.ruby.html) by CLI.

```
$ ./bin/mandrilltemplate 
Commands:
  mandrilltemplate delete NAME     # delete template from remote.
  mandrilltemplate export NAME     # export template from remote to local files.
  mandrilltemplate generate NAME   # generate new template files.
  mandrilltemplate help [COMMAND]  # Describe available commands or one specific command
  mandrilltemplate list            # show template list both of remote and local.
  mandrilltemplate publish NAME    # publish template from draft.
  mandrilltemplate upload NAME     # upload template to remote as draft.
```

## Workflow

1. generate new or export exist template as local files.
2. modify and manage under version controle system.
3. upload template.
4. publish it.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


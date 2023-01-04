import argparse

var res:string


template envAndTopic() =
    arg("env")
    arg("topic")

var p = newParser:
  help("A demonstration of this library in a program named {prog}")
  flag("-v", "--verbose", help = "Verbose output, show the underlying commands")
  flag("-n", "--dryrun")
  option("--name", default=some("bob"), help = "Name to use")
  command("cat"):
    envAndTopic()
    # arg("env")
    # arg("topic")
    help("cat a topic")
    run:
      res = "cat " & opts.parentOpts.name
  command("run"):
    option("-c", "--command")
    run:
      let name = opts.parentOpts.name
      if opts.parentOpts.dryrun:
        res = "would have run: " & opts.command & " " & name
      else:
        res = "ran " & opts.command & " " & name



when isMainModule:
    try:
        p.run()
        echo res
        echo $p
    except UsageError as ue:
        stderr.writeLine ue.msg
        stderr.writeLine p.help
        quit(1)
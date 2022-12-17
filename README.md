# Nim Scratch

A repo for playing around with [Nim](https://nim-lang.org/).


Install `choosenim` with:

    curl https://nim-lang.org/choosenim/init.sh -sSf | sh

# Set up VSCode Plugins:

set up [Nim VSCode Plugin](https://marketplace.visualstudio.com/items?itemName=nimsaem.nimvscode)
and [CodeLLDB plugin](https://open-vsx.org/extension/vadimcn/vscode-lldb) for debugging

details on nimvscode plugin are solid and show how to create launch.json and tasks.json files in your project

also want to have "execute build task from tasks.json on save" checked, nim compiliation is quick

Should be able to set breakpoints in the gutter and step debug

# TODO

- command line arg parser

- homebrew get osx mac working
  - https://github.com/tednaleid/homebrew-ganda/blob/master/Formula/ganda.rb

- how do we capture stdout of a command line app we ran
  - save to string
  - stream of it that we react to

- tests with https://nim-lang.org/docs/unittest.html
  - set up code so that we're building the string commands to run and that's what we test
  - glue code is actually running it
  - can we mock out the running of the exec command?
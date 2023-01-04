import strformat

# staticExec at compile time, easy to get build information into your code
const 
  BuildGitSha = staticExec("git rev-parse --short HEAD")
  BuildHost = staticExec("uname -v")

when isMainModule:
  echo fmt"""

git: {BuildGitSha}
host: {BuildHost}

"""
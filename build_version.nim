import strformat

# staticExec at compile time
const 
    BuildGitSha = staticExec("git rev-parse --short HEAD")
    BuildHost = staticExec("uname -v")

when isMainModule:
    echo fmt"""

git: {BuildGitSha}
host: {BuildHost}

"""
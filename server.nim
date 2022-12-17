import std/[asynchttpserver, asyncfutures, asyncdispatch, json, uri, os, strutils]

# from: https://www.youtube.com/watch?v=d2VRuZo2pdA

# curl -sL "localhost:8000/foobar"

proc handle(request:Request):Future[void] =
    # JSON format message response
    let msg = %* { "result" : request.url.path.splitFile.name.toUpperAscii }
    request.respond(Http200, $msg & "\n")

waitFor newAsyncHttpServer().serve(Port(8000), handle)
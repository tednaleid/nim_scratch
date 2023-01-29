import parsetoml, json

let table1 = parsetoml.parseString("""
[input]
file_name = "test.txt"

[output]
verbose = true
""")


# Get the value, or fail if it is not found
let verboseFlag = table1["output"]["verbose"].getBool()

echo verboseFlag
echo table1["input"]["file_name"]
echo typeof(table1["input"]["file_name"])
echo table1["input"]["file_name"].getStr()
echo typeof(table1["input"]["file_name"].getStr())



# default for something that doesn't exist
# echo table1["input"]["missing"].getStr("default value")


echo table1.toJson.pretty()


# can dump the TOML ast, will echo on stdout
parsetoml.dump(table1.getTable())

# let table2 = parsetoml.parseFile(f)
# let table3 = parsetoml.parseFile("test.toml")


let toml = parsetoml.parseString("""
# This is a TOML document

title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }

# this is not required with the servers.alpha/servers.beta below
[servers]

[servers.alpha]
ip = "10.0.0.1"
role = "frontend"

[servers.beta]
ip = "10.0.0.2"
role = "backend"
""")

parsetoml.dump(toml.getTable())


parsetoml.dump(toml["servers"].getTable())


echo ""

# check formatting with https://toolkit.site/format.html
let config1 = parsetoml.parseString("""
[env.local]
broker = "127.0.0.1"
port = 9092

[env.dev]
broker = "kafka.company.com"
port = 9092 # optional, will default to 9092 if no cert, otherwise 9093
filter = "myteam-*"

[env.dev."my-topic"]
alias = "topic-prime"

# can we inherit the broker from the env above?
broker = "kafka.company.com"
port = 9093
#  holds security stuff
config = "/path/to/my-topic.conf"

# example contents, valid for kcat/confluent CLI tooling
# external as it'll have a password

    # security.protocol=ssl
    # ssl.ca.location=/path/to/client.pem
    # ssl.certificate.location=/path/to/client.pem
    # ssl.key.location=/path/to/client.pem
    # ssl.key.password=THEPASSWORD

# could also have the PEM certificate directly in it with
    # ssl.key.pem
""")

parsetoml.dump(config1.getTable())

echo ""
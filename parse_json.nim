# edited from: https://glenngillen.com/learning-nim/parse-nested-json/

import json

type
  Address = object
    line: string
    state: string
    country: string

  Person = object
    first_name: string
    last_name: string
    address: Address

let jsonObject = parseJson("""{
  "first_name": "Ted", 
  "last_name": "Naleid",
  "address": {
    "line": "123 Main St",
    "state": "MN",
    "country": "US"
  }
}""")

echo $jsonObject

let person = to(jsonObject, Person)

echo person.first_name
echo person.address.state

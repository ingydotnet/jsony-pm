
DJSON
=====

Degenerate JSON

0. Provide a structured config syntax that's pleasant for humans to write but will also accept JSON
0. Provide the ability to format as CLI arguments the same information in as similar a fashion as possible
0. Provide a human readable logging syntax that parses into a JSON structure unequivocally



The Spec
--------

    use TestML -run,
        -require_or_skip => 'JSON',
        -require_or_skip => 'YAML';
    
    use DJSON;
    use JSON;
    use YAML;
    # $Pegex::Parser::Debug = 1;
    
    sub djson_decode {
        decode_djson $_[0]->value;
    }
    
    sub json_decode {
        decode_json $_[0]->value;
    }
    
    sub yaml {
        my $yaml = YAML::Dump $_[0]->value;
        $yaml =~
            s{!!perl/scalar:JSON::XS::Boolean}
            {!!perl/scalar:boolean}g;
        return $yaml;
    }
    
    __DATA__
    %TestML 1.0
    
    # Make sure the djson parses to what we expect:
    *djson.djson_decode.yaml == *json.json_decode.yaml;
    
    # Make sure DJSON parses the JSON form the same as a JSON parser:
    *json.djson_decode.yaml == *json.json_decode.yaml;
    
    === String splitting 1
    --- djson: foo bar baz
    --- json: [ "foo", "bar", "baz" ]
    
    === String splitting 2
    --- djson
    foo bar
    baz
    --- json: [ "foo", "bar", "baz" ]
    
    === String splitting 3
    --- djson: foo "bar baz"
    --- json: [ "foo", "bar baz" ]
    
    === Number conversion
    --- djson: foo 3 bar
    --- json: [ "foo", 3, "bar" ]
    
    === Specials
    --- djson: one true two false three null
    --- json: [ "one", true, "two", false, "three", null ]
    
    === Object 1
    --- djson
    { foo bar baz 1 }
    --- json
    {
      "foo": "bar",
      "baz": 1
    }
    
    === Object 2
    --- djson
    plugin Server {
      host example.com
      port 8080
    }
    plugin Frobnicator {
      harder true
    }
    --- json
    [
      "plugin", "Server", {
        "host": "example.com",
        "port": 8080
      },
      "plugin", "Frobnicator", {
        "harder": true
      }
    ]
    
    === Log line example
    --- djson
    2012-09-10T17:00:34 /users/bob/edit { user admin }
    --- json
    [ "2012-09-10T17:00:34", "/users/bob/edit", { "user": "admin" } ]
    
    === Config file example
    --- djson
    plugin Server {
      host example.com
      port 8080
    }
    dsn "dbi:SQLite:filename=my.db"
    allow hosts [ jules sherlock kitty ]
    
    --- json
    [
      "plugin", "Server", {
        "host": "example.com",
        "port": 8080
      },
      "dsn", "dbi:SQLite:filename=my.db",
      "allow", "hosts", [ "jules", "sherlock", "kitty" ]
    ]
    
    === activitystrea.ms example
    --- djson
    {
    published 2011-02-10T15:04:55Z
      actor {
        url http://example.org/martin
        objectType person
        id 'tag:example.org,2011:martin'
        image {
          url http://example.org/martin/image
          width 250
          height 250
        }
        displayName "Martin Smith"
      }
      verb post
      object {
        url http://example.org/blog/2011/02/entry
        id 'tag:example.org,2011:abc123/xyz'
      }
      target {
        url http://example.org/blog/
        objectType blog
        id 'tag:example.org,2011:abc123'
        displayName "Martin's Blog"
      }
    }
    
    --- json
    {
      "published": "2011-02-10T15:04:55Z",
      "actor": {
        "url": "http://example.org/martin",
        "objectType" : "person",
        "id": "tag:example.org,2011:martin",
        "image": {
          "url": "http://example.org/martin/image",
          "width": 250,
          "height": 250
        },
        "displayName": "Martin Smith"
      },
      "verb": "post",
      "object" : {
        "url": "http://example.org/blog/2011/02/entry",
        "id": "tag:example.org,2011:abc123/xyz"
      },
      "target" : {
        "url": "http://example.org/blog/",
        "objectType": "blog",
        "id": "tag:example.org,2011:abc123",
        "displayName": "Martin's Blog"
      }
    }
    
    === Comments
    --- djson
    foo bar     # comment
    \# Comment
    url http://xyz.com#not_comment
    --- json
    [
        "foo",
        "bar",
        "url",
        "http://xyz.com#not_comment"
    ]
    

Edge Cases
----------

    use TestML -run,
        -require_or_skip => 'JSON',
        -require_or_skip => 'YAML';
    
    use DJSON;
    use JSON;
    use YAML;
    # $Pegex::Parser::Debug = 1;
    
    sub djson_decode {
        decode_djson $_[0]->value;
    }
    
    sub json_decode {
        decode_json $_[0]->value;
    }
    
    sub yaml {
        my $yaml = YAML::Dump $_[0]->value;
        $yaml =~
            s{!!perl/scalar:JSON::XS::Boolean}
            {!!perl/scalar:boolean}g;
        return $yaml;
    }
    
    __DATA__
    %TestML 1.0
    
    # Make sure the djson parses to what we expect:
    *djson.djson_decode.yaml == *json.json_decode.yaml;
    
    # Make sure DJSON parses the JSON form the same as a JSON parser:
    *json.djson_decode.yaml == *json.json_decode.yaml;
    
    === String splitting 1
    --- djson: foo bar baz
    --- json: [ "foo", "bar", "baz" ]
    
    === String splitting 2
    --- djson
    foo bar
    baz
    --- json: [ "foo", "bar", "baz" ]
    
    === String splitting 3
    --- djson: foo "bar baz"
    --- json: [ "foo", "bar baz" ]
    
    === Number conversion
    --- djson: foo 3 bar
    --- json: [ "foo", 3, "bar" ]
    
    === Specials
    --- djson: one true two false three null
    --- json: [ "one", true, "two", false, "three", null ]
    
    === Object 1
    --- djson
    { foo bar baz 1 }
    --- json
    {
      "foo": "bar",
      "baz": 1
    }
    
    === Object 2
    --- djson
    plugin Server {
      host example.com
      port 8080
    }
    plugin Frobnicator {
      harder true
    }
    --- json
    [
      "plugin", "Server", {
        "host": "example.com",
        "port": 8080
      },
      "plugin", "Frobnicator", {
        "harder": true
      }
    ]
    
    === Log line example
    --- djson
    2012-09-10T17:00:34 /users/bob/edit { user admin }
    --- json
    [ "2012-09-10T17:00:34", "/users/bob/edit", { "user": "admin" } ]
    
    === Config file example
    --- djson
    plugin Server {
      host example.com
      port 8080
    }
    dsn "dbi:SQLite:filename=my.db"
    allow hosts [ jules sherlock kitty ]
    
    --- json
    [
      "plugin", "Server", {
        "host": "example.com",
        "port": 8080
      },
      "dsn", "dbi:SQLite:filename=my.db",
      "allow", "hosts", [ "jules", "sherlock", "kitty" ]
    ]
    
    === activitystrea.ms example
    --- djson
    {
    published 2011-02-10T15:04:55Z
      actor {
        url http://example.org/martin
        objectType person
        id 'tag:example.org,2011:martin'
        image {
          url http://example.org/martin/image
          width 250
          height 250
        }
        displayName "Martin Smith"
      }
      verb post
      object {
        url http://example.org/blog/2011/02/entry
        id 'tag:example.org,2011:abc123/xyz'
      }
      target {
        url http://example.org/blog/
        objectType blog
        id 'tag:example.org,2011:abc123'
        displayName "Martin's Blog"
      }
    }
    
    --- json
    {
      "published": "2011-02-10T15:04:55Z",
      "actor": {
        "url": "http://example.org/martin",
        "objectType" : "person",
        "id": "tag:example.org,2011:martin",
        "image": {
          "url": "http://example.org/martin/image",
          "width": 250,
          "height": 250
        },
        "displayName": "Martin Smith"
      },
      "verb": "post",
      "object" : {
        "url": "http://example.org/blog/2011/02/entry",
        "id": "tag:example.org,2011:abc123/xyz"
      },
      "target" : {
        "url": "http://example.org/blog/",
        "objectType": "blog",
        "id": "tag:example.org,2011:abc123",
        "displayName": "Martin's Blog"
      }
    }
    
    === Comments
    --- djson
    foo bar     # comment
    \# Comment
    url http://xyz.com#not_comment
    --- json
    [
        "foo",
        "bar",
        "url",
        "http://xyz.com#not_comment"
    ]
    

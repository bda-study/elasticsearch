# Chapter02 script
# p71
curl -s -XPUT 'localhost:9200/get-together/group/1' -H'Content-Type: application/json' -d '{
"name": "Elasticsearch Denver",
"organizer": "Lee"
}' | jq '.'


# p73
curl -s 'localhost:9200/get-together/_mapping/group' | jq '.'

# p76
curl -s "localhost:9200/get-together/group,event,_doc/_search\
?q=elasticsearch" | jq '.'

# p82
curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"query": {
	"query_string": {
		"query": "elasticsearch"
	}
  }
}'| jq '.'

# p83
curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"query": {
	"query_string": {
		"query": "elasticsearch",
		"default_field": "name",
		"default_operator": "AND"
	}
  }
}'| jq '.'

curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"query": {
	"query_string": {
		"query": "name:elasticsearch AND name:san AND name:francisco"
	}
  }
}'| jq '.'

# p84
curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"query": {
	"term": {
		"name": "elasticsearch"
	}
  }
}'| jq '.'

# p.85
curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"query": {
	"bool": {
		"filter": {
			"term": {
				"name": "elasticsearch"
		}
	  }
	}
  }
}'| jq '.'

# p85
curl "localhost:9200/get-together/_mapping/_doc" | jq '.'

curl -XPOST "localhost:9200/get-together/_mapping/_doc" -H'Content-Type: application/json' -d '{
"properties": {
  "organizer": {
    "type": "text",
    "fielddata": true
    }
  }
}'  | jq '.'

curl -s "localhost:9200/get-together/_doc/_search" -H'Content-Type: application/json' -d '{
"aggregations": {
	"organizers": {
		"terms": {"field": "organizer"}
	}
  }
}'| jq '.'

# p87
curl -s "localhost:9200/get-together/_doc/1" | jq '.'

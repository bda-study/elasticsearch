 # Chapter03. 데이타를 인덱싱, 업데이팅 그리고 삭제하기 
- 매핑타입들을 사용하여 같은 인덱스내 다양한 타입들의 도큐먼트들을 정의
- 매핑들 내에서 사용할 수 있는 필드들의 타입들
- 미리정해진 필드들과 그 옵션들을 사용하기
- 위의 내용으로 인덱싱하고, 데이타를 업데이팅 그리고 삭제하기

이 장은 엘라스틱서치로 데이타를 넣고(updating) 빼내고(deleting) 관리하는 것(indexing)에 대한 내용이다. 
엘라스틱 서치는 도큐먼트 베이스이고, 도큐먼트들은 필드들과 필드들의 값으로 구성되어 있으며, 이런 구성이 도규먼트 자체내에 포함되어져있다 
마치 테이블내에 로우들이 있고 각 row가 컬럼이름들을 가지는 것처럼 말이다. 

필드들에 대한 3가지 타입들
- Core : string(text), numbers 
- Arrays 와 multi-fields : 
- Predefined : 메타데이타  ex) _ttl, _timestamp  (_ttl : 일정시간 후 도큐먼트들을 삭제) 
               이런필드들은 엘라스틱 서치에 의해서 자동적으로 관리되어질 수 있는 메타데이타로 생각하면 된다.

(
  Single type : text, keyword, date, long, double, boolean or ip
  Json의 계층적인 속성 : object, nested
  특별한 타입 : geo_point, geo_shape, completion
)

## 3.1 매핑들을 사용해서 다양한 종류의 도큐먼트들을 정의하라
각 document은 type에 속해 있고, 이들은 각각의 index에 속해있다  (type은 7.0 이상 상위버전부터 deprecated)
인덱스들은 데이타베이스들로 생각할 수 있다. 예를 들어 2장에서 봤던 get-together 인덱스에는 Group 와 events 의 타입이 있고 각각의 타입내 도큐먼트는 
다른 구조를 가지고 있다. type은 논리적인 구분으로만 사용되어지는데, 
mapping내에서 각 필드의 정의를 포함하고, mapping은 도큐먼트내의 모든 필드들을 포함하고, type은 엘라스틱서치에게 어떻게 도큐먼트네에서 필드들을 인덱스해야하는지 말해준다.

그림.

  ## 3.1.1 mapping들을 구하고 정의하기
  - 현재매핑을 얻기
  ````
  GET get-together/_mapping
  ````

  - 새로은 매핑을 정의하기
  (새로운 매핑은 인덱스를 생성한 후, 그리고, 그 타입으로 어떠한 도큐먼트를 인서트하기전에 정의를 할 수 있다)
  ````
  PUT get-together/_mapping/
  {
      "properties": {
        "host" : {
          "type" : "text"
        }
      }
  }
  ````

  ## 3.1.2 기존 매핑을 확장하기
  이미 매핑이 있다면 머지한다. 
    하지만, 기존 필드의 데이타 타입을 변경할 수 없다 (MergeMappingException). 즉, 필드에 대해 인덱스 되어지는 방식을 변경할 수 없다
    MergeMappingException를 해결하는 유일한 방법은 재인덱스 하는 방식으로 해결할 수 있다. 
    즉, 새로운 매핑을 가지고 새롭게 인덱스를 생성해야 한다. 그리고, 이전 데이타들을 새로운 인덱스로 재인덱스한다. 

## 3.2 core types
  필드는 코어타입들 또는 복합적인 타입(예, 배열), nested type(도큐먼트내 도큐먼트) or geo_point (지구상의 위도경도위치, 내장된 필드) type

  ## 3.2.1 string  - text로 사용
  Analysis 는 관련된 서치를 만들기 위해 엘레먼트들을 쪼개고 텍스트를 파싱하는 과정이다. Term 이라는 용어는 서칭하기 위해 가장 기본적인 단위이며 
  텍스트에서 추출된 단어를 말한다.


  그림. 
  Analysis 프로세스는 매핑안에서 분석하기 위해 여러가지 옵션들로 구성된다. 그리고, 용어들의 동의어를 만들어 낼 수 있게 분석방법을 설정할 수도 있다. 

  Index 옵션에 analyzed , not analyzed, no 로 셋팅할 수 있다.  (6.x 이후부터는 다르게 사용됨. index = true/false로)
  Index 옵션이 analyzed 로 셋팅되면 , Analyzer 가 소문자로 모든 문자들을 단어별로 쪼갠다. 
  ex.
  * if index = analyzed (디폴트값)
    “Elasticsearch” 라고 searching 하면 “Late night with Elasticsearch” 를 결과로 기대할 것임

  * if index = not_analyzed - 전체 용어가 매칭되어야지만 서칭이 된다. (대소문자도 구분해서 서칭함)
    “Big data”, 1. Data 로 서치 2, Big data 로 서칭 시 결과는 다름.

  * if index = no 
    인덱싱이 스킵되고 어떠한 terms 도 만들어지지 않고, 특정필드 서칭이 불가하다. 이는 인덱스하고 서치하는 데 필요한 공간을 절약하고 시간을 줄여준다. 물론, 
    생각하고 사용해야하며, 이후버전에서는 없음
    
 
## 3.2.2 numeric
  Byte, short, integer, long, double : 자바의 primitive data type 과 동일

## 3.2.3  date
  루슨 인덱스내에서 Date 타입은 string으로 파싱하고+long 타입으로 저장. 
  Date string의 데이트 포맷은 포맷옵션으로 정해지고 디폴트로 iso 8601

  ex. 
  * predefiend date format : 2019-02-22
  * Custom format ex. MMM YYYY : Jul 2001

## 3.2.4 Boolean
  true/false

## 3.3 arrays and mult-fields
  ## 3.3.1 arrays
  필드내 다중 값들을 인덱스 하기 위해, [] 를 사용해서 값들을 열거한다.
  Array 필드는 스트링처럼 필드를 정의하고, 특별히 배열로 정의되는 방식은 없다
  String 의 싱글필드가 하는 것처럼 Tags: { “type” : “string” } 하고, 값을 [] 를 이용해서 동일 데이타 타입으로 열거하는 방식. 
  ````
  PUT blog/posts1/1
    {
      "tags" : ["first","initial"]
    }
  ````

  ## 3.3.2 
  멀티필드는 같은 데이타를 다른 방식으로 여러번 인덱싱하는 방식이다. 
  
  string들은 text 와 keyword로 인덱스 되어지는데 즉, 같은 string을 여러번 인덱스함. 이를 멀티필드라고 함. 
  예를 들어, title : cloud elastic service 라고 하면
  text 필드타입을 사용하면, analysed가 되고, 대소문자 구분을 하지 않는다. (디폴트 analyzer 사용시)
  keyword는 full text searching을 함. 필드는 analysed가 안되고, 대소문자 구분하여 정확한 매칭을 요구함. 풀매칭을 원하거나,
  sorting or aggregations를 원할때 사용
  string을 인덱싱하지 않고 다른 방식으로 사용할수 있기때문에 멀티필드를 지원한다. 이것이 멀티 필드들의 목적이다. 
  엘라스틱서치는 사용자가 무슨 용도로 인덱싱할려는 지 모르기때문에, text 타입으로 string을 분석하고, keyword 멀티필드를 생성한다 
  대부분 데이타타입들은 멀티필드들을 지원한다
   
  ````
  PUT test
  
  PUT test/_doc/1
  {
    "name": "first Elasticsearch",
    "date": "2013-11-25T19:00"
  }
  ````
  결과 : 
  ````
  {
    "test" : {
      "mappings" : {
        "properties" : {
          "date" : {
            "type" : "date"
          },
          "name" : {
            "type" : "text",
            "fields" : {
              "keyword" : {
                "type" : "keyword",
                "ignore_above" : 256
              }
            }
          }
        }
      }
   }
 }
  ````
## 3.4 predefined fields 를 사용하라
  _ 로 시작하는 필드이름들, 도큐먼트들에 대한 새로운 메타데이타이다. 
  _timestamp : 도큐먼트가 인덱스되어졌을때 date를 기록하는 필드
  _ttl  : 특정 시간 후에 도큐먼트들을 제거하는 필드
  _source : 인덱스하는 json 도큐먼트들을 저장되어있는 필드
  _uid, _id, _type, _index : 도큐먼트들을  identify 하는 필드들 
  _size : 원 json 사이즈
  _routing : 스케일링에 관련되는 필드
  _parent : 도큐먼트들간의 관계
  _all field : 도큐먼트내에 함계 인덱스 되어지는 모든 필드들 


## 3.4.1  도큐먼트들을 저장하고 서치하는 방법을 제어하기
  _all : 싱글 필드내에 모든 내용들을 인덱스하게 함
  _source : 인덱스시 패스되어지는 json doc body이고, 그 자체는 index 와 서칭이 안되지만, 이는 저장되고, fetch request , get, search 같은, 
            실행되어질 때 리턴되어진다. 스토리지 과부하를 초래할 수도 있지만,  disable 하게 된다면, update, update_by_query, reindex 등 
            많은 기능들이 지원되지 않는다. 
           _source 로 부터 필드들을 including/excluding 가능하다. 소스필터링이 가능하다. 

  _index : 여러 인덱스들에서 쿼리들을 실행할 경우, 쿼리 절을 추가하여 어떤 특정 인덱스들의 도큐먼트들과 함께 수행할 수 있다. 
          _index 의 값은 소팅시 또는 스크립팅시, 어떤 쿼리들 과 aggregations 에서 접근이 가능하다 

## 3.4.2 documents를 식별하기
  _type : ex."_type" : "_doc"
  _id : 각 도큐는 식별하기 위해 _id를 가지고, 이는 인덱스되어진다. 그래서 도큐먼트들은 GET API 또는 ids 쿼리를 통해 검색되어진다.
      _id 의 값은 term, terms,match, query_string, simple_query_string 같은 쿼리들에 의해 찾을 수 있다. 
  ex.
  ````
  GET get-together/_search
  {
    "query": { "match": { "name": "late" } }
  }
  ````
  결과. 
  ```` 
  {
      "took" : 0,
      "timed_out" : false,
      "_shards" : {
        "total" : 1,
        "successful" : 1,
        "skipped" : 0,
        "failed" : 0
      },
      "hits" : {
        "total" : {
          "value" : 1,
          "relation" : "eq"
        },
        "max_score" : 0.9808292,
        "hits" : [
          {
            "_index" : "get-together",
            "_type" : "new-events",
            "_id" : "2",
            "_score" : 0.9808292,
            "_source" : {
              "name" : "late Night with Elasticsearch",
              "date" : "2019-11-12T19:00",
              "index_test1" : "hi"
            }
          }
        ]
      }
    }
  ````
  _uid :상위버전에서 삭제됨
  
  - 수동적으로 id를 제공하기 위해서 auto_id 를 사용
  - document내에 인덱스 이름을 저장하기 
  
  ex. auto_id
  ````
  POST auto_id_index1/auto_id
  {
    "msg" : "second time try"
  }

  GET auto_id_index1/_search/
  ````
  결과 : 
  ````
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 1.0,
      "hits" : [
        {
          "_index" : "auto_id_index1",
          "_type" : "auto_id",
          "_id" : "RcAPkm4BSODxiOfna7L3",
          "_score" : 1.0,
          "_source" : {
            "msg" : "fourth time try"
          }
        }
      ]
    }
  }


  GET auto_id_index1/_doc/RcAPkm4BSODxiOfna7L3

  POST auto_id_index1/_update/RcAPkm4BSODxiOfna7L3
  {
    "script" : 
    {
      "source": "ctx._source.msg += params.msg",
      "lang": "painless",
      "params" : {
        "msg" : "third time try"
      }
    }
  }
  ````

  ex. _source
  ````
  PUT logs
  {
    "mappings": {
      "_source": {
        "includes": [
          "*.count",
          "meta.*"
        ],
        "excludes": [
          "meta.description",
          "meta.other.*"
        ]
      }
    }
  }

  PUT logs/_doc/1
  {
    "requests": {
      "count": 10,
      "foo": "bar" 
    },
    "meta": {
      "name": "Some metric",
      "description": "Some metric description", 
      "other": {
        "foo": "one", 
        "baz": "two" 
      }
    }
  }

  GET logs/_doc/1
  ````
  결과 :
  ````
  {
    "_index" : "logs",
    "_type" : "_doc",
    "_id" : "1",
    "_version" : 1,
    "_seq_no" : 0,
    "_primary_term" : 1,
    "found" : true,
    "_source" : {
      "meta" : {
        "other" : { },
        "name" : "Some metric"
      },
      "requests" : {
        "count" : 10
      }
    }
  }

  GET logs/_search
  {
    "query": {
      "match": {
        "meta.description": "metric"
      }
    }
  }
  ````
  결과 :
  ````
  {
    "took" : 0,
    "timed_out" : false,
    "_shards" : {
      "total" : 1,
      "successful" : 1,
      "skipped" : 0,
      "failed" : 0
    },
    "hits" : {
      "total" : {
        "value" : 1,
        "relation" : "eq"
      },
      "max_score" : 0.2876821,
      "hits" : [
        {
          "_index" : "logs",
          "_type" : "_doc",
          "_id" : "1",
          "_score" : 0.2876821,
          "_source" : {
            "meta" : {
              "other" : { },
              "name" : "Some metric"
            },
            "requests" : {
              "count" : 10
            }
          }
        }
      ]
    }
  }
  ````
## 3.5 update api

```
POST /<index>/_update/<_id>
```

1. 기존문서의 필드값을 변경할 수 있고, 
2. 스크립트를 사용해서 변경
3. Upserting


우선, 데이타를 생성한다. 
```
PUT test/_doc/1
{
    "counter" : 1,
    "tags" : ["red"]
}
```

- 문서에서 일부분을 업데이트 하기
```
POST test/_update/1
{
    "doc" : {
        "name" : "new_name"
    }
}
```
이는 업데이트 된 결과가 없을 경우, 업데이트시 결과에 noop을  발견할 수 있다 .

noop 이 안나오게 disable가능하다
```
POST test/_update/1
{
    "doc" : {
        "name" : "new_name"
    },
    "detect_noop": false
}
```

- Upsert
* doc 의 내용을 upsert 할 수 있다
```
POST test/_update/1
{
    "doc" : {
        "name" : "new_name"
    },
    "doc_as_upsert" : true
}

POST test/_update/1
{
    "script" : {
        "source": "ctx._source.counter += params.count",
        "lang": "painless",
        "params" : {
            "count" : 4
        }
    },
    "upsert" : {
        "counter" : 1
    }
}
```

- 특정스크립트를 사용하여 doc을 업데이트한다


스크립트로 update, delete 또는 skip 가능하다. 
* 기존 존재하는 doc에 머징기능이 가능하고, 기존문서를 완전히 변경가능하다. 

동작방법
1. 인덱스로 도큐먼트를 가져온다
2. 지정된 스크립트를 실행시킨다
3. 결과를 인덱스한다. 
_source 필드는 update사용을 가능하게 하고, ctx 맵을 사용하여, _index, _type, _id, _version, _routing, _now 변수에 접근가능하다


* 스크립트를 사용하여 update 하는 방법 
```
POST test/_update/1
{
    "script" : {
        "source": "ctx._source.counter += params.count",
        "lang": "painless",
        "params" : {
            "count" : 4
        }
    }
}

POST test/_update/1
{
    "script" : {
        "source": "ctx._source.tags.add(params.tag)",
        "lang": "painless",
        "params" : {
            "tag" : "blue"
        }
    }
}
```

* 도큐먼트에 있는 필드들을 스크립트를 통해서 더하고 지울수 있다 
```
POST test/_update/1
{
    "script" : "ctx._source.new_field = 'value_of_new_field'"
}

POST test/_update/1
{
    "script" : "ctx._source.remove('new_field')"
}
```



* 스크립트로 upsert 하기 (문서가 존재하던 말던 여부에 상관없이 - scripted_upsert:true)
```
POST sessions/_update/dh3sgudg8gsrgl
{
    "scripted_upsert":true,
    "script" : {
        "id": "my_web_session_summariser",
        "params" : {
            "pageViewEvent" : {
                "url":"foo.com/bar",
                "response":404,
                "time":"2014-01-01 12:32"
            }
        }
    },
    "upsert" : {}
}
```



* concurrency control
  그림 3.5
  
  optimistic concurrency control
  - 도큐먼트에 마지막 변경내용이 if_seq_no, if_primary_term 파라미터들에 의해 지정된 시퀀스 번호와 primary term으로 할당되어있다.
    mismatch가 발견되면 VersionConflictException, 409
    (오직, 이 시퀀스 번호가 존재하고 primary term을 가진다면 동작을 수행한다. )
  "_seq_no" : 4,
  "_primary_term" : 1,


  해결방법 : 
  1. 버전충돌시, 업데이트를 다시 하던지 또는 자동으로 재시도하는 옵션을 사용 retry_on_conflict
  ````
  % SHIRTS="localhost:9200/online-shop/shirts"
  % curl -XPOST "$SHIRTS/1/_update?retry_on_conflict=3" -d '{
      "script": "ctx._source.price = 2"
  }'
  ````
  2. 버젼을 명시하고 버젼이 맞으면 업데이트를 하도록 한다. 
  ````
  % curl -XPUT 'localhost:9200/online-shop/shirts/1?version=3' -d 
  '{ "caption": "I Know about Elasticsearch Versioning",
  "price": 5
  }'
  ````


## 3.6 delete api
- 특정 index로 json doc을 지운다. 
```
delete /<index>/_doc/<_id>
```
DELETE /twitter/_doc/1

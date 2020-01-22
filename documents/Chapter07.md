# Chapter07 집계로 데이터 살펴보기

- 특정 결과에 관심이 없는 많은 사용 사례 : 그들은 문서의 통계 정보 얻고 싶어 한다.
  - ex) 화젯거리, 제품 동향, 방문자 수 등
  - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig01.jpg)
- 인기 있는 태그 목록을 얻으려면 집계를 사용하면 된다.
  - 텀즈 집계를 태그 필드에 사용하여, 단어수 계산하고, 가장 많이 반복되는 단어 보내면 됨.
- 집계 종류 2가지
  - 지표 집계
    - 문서 그룹의 통계 분석. 최솟값, 최댓값, 표준 편차 등
    - ex) 상품의 평균 가격, 로그인한 순 방문자 수
  - 버킷 집합
    - 하나 또는 여러 개의 버킷에 일치하는 문서를 나눈 다음, 각 버킷의 문서 수 반환
- 중첩
  - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig02_alt.jpg)

## 7.1 집계의 내부 이해하기
  - 규칙
    - 질의 요청에 aggregations 또는 aggs로 표시
      - 이름, 유형, 옵션 지정
    - 집계는 질의 결과에 실행. (global 집계는 예외)
      - 질의에 일치하지 않는 문서는 처리 불가
    - 집계에 영향 주지 않고 질의 결과 필터 가능 : 포스트 필터
      - ex) 온라인 상점에서 키워드 검색시 모든 아이템에 대한 통계 보이고, 결과는 재고있는 경우에만 보이고 싶을 때.

### 7.1.1 집계 요청의 구조

- 요청
```json
GET get-together/_search
{
  "aggs": { //집계 위한 키
    "top_tags": { // 집계 이름
      "terms": { // 집계 타입
        "field": "tags.verbatim" // not_analyized 필드인 verbatim 필드
      } 
    },
    "xyz": {
      "terms": {
        "field": "tags.verbatim"
      }
    }
  }
}
```

- 결과
  - aggs 키
```json
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 20,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Elasticsearch San Francisco",
          "organizer" : "Mik",
          "description" : "Elasticsearch group for ES users of all knowledge levels",
          "created_on" : "2012-08-07",
          "tags" : [
            "elasticsearch",
            "big data",
            "lucene",
            "open source"
          ],
          "members" : [
            "Lee",
            "Igor"
          ],
          "location_group" : "San Francisco, California, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "5",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Enterprise search London get-together",
          "organizer" : "Tyler",
          "description" : "Enterprise search get-togethers are an opportunity to get together with other people doing search.",
          "created_on" : "2009-11-25",
          "tags" : [
            "enterprise search",
            "apache lucene",
            "solr",
            "open source",
            "text analytics"
          ],
          "members" : [
            "Clint",
            "James"
          ],
          "location_group" : "London, England, UK"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "100",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "1"
          },
          "host" : [
            "Lee",
            "Troy"
          ],
          "title" : "Liberator and Immutant",
          "description" : "We will discuss two different frameworks in Clojure for doing different things. Liberator is a ring-compatible web framework based on Erlang Webmachine. Immutant is an all-in-one enterprise application based on JBoss.",
          "attendees" : [
            "Lee",
            "Troy",
            "Daniel",
            "Tom"
          ],
          "date" : "2013-09-05T18:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 4
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "101",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "1"
          },
          "host" : "Sean",
          "title" : "Sunday, Surly Sunday",
          "description" : "Sort out any setup issues and work on Surlybird issues. We can use the EC2 node as a bounce point for pairing.",
          "attendees" : [
            "Daniel",
            "Michael",
            "Sean"
          ],
          "date" : "2013-07-21T18:30",
          "location_event" : {
            "name" : "IRC, #denofclojure"
          },
          "reviews" : 2
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "102",
        "_score" : 1.0,
        "_routing" : "1",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "1"
          },
          "host" : "Daniel",
          "title" : "10 Clojure coding techniques you should know, and project openbike",
          "description" : "What are ten Clojure coding techniques that you wish everyone knew? We will also check on the status of Project Openbike.",
          "attendees" : [
            "Lee",
            "Tyler",
            "Daniel",
            "Stuart",
            "Lance"
          ],
          "date" : "2013-07-11T18:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 3
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "103",
        "_score" : 1.0,
        "_routing" : "2",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "2"
          },
          "host" : "Lee",
          "title" : "Introduction to Elasticsearch",
          "description" : "An introduction to ES and each other. We can meet and greet and I will present on some Elasticsearch basics and how we use it.",
          "attendees" : [
            "Lee",
            "Martin",
            "Greg",
            "Mike"
          ],
          "date" : "2013-04-17T19:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 5
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "104",
        "_score" : 1.0,
        "_routing" : "2",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "2"
          },
          "host" : "Lee",
          "title" : "Queries and Filters",
          "description" : "A get together to talk about different ways to query Elasticsearch, what works best for different kinds of applications.",
          "attendees" : [
            "Lee",
            "Greg",
            "Richard"
          ],
          "date" : "2013-06-17T18:00",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : 1
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "105",
        "_score" : 1.0,
        "_routing" : "2",
        "_source" : {
          "relationship_type" : {
            "name" : "event",
            "parent" : "2"
          },
          "host" : "Lee",
          "title" : "Elasticsearch and Logstash",
          "description" : "We can get together and talk about Logstash - http://logstash.net with a sneak peek at Kibana",
          "attendees" : [
            "Lee",
            "Greg",
            "Mike",
            "Delilah"
          ],
          "date" : "2013-07-17T18:30",
          "location_event" : {
            "name" : "Stoneys Full Steam Tavern",
            "geolocation" : "39.752337,-105.00083"
          },
          "reviews" : null
        }
      }
    ]
  },
  "aggregations" : { // 집계 시작
    "xyz" : { // 집계 이름
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [
        {
          "key" : "big data", // 버킷의 유일한 텀
          "doc_count" : 3 // 얼마나 나타났는지
        },
        {
          "key" : "open source",
          "doc_count" : 3
        },
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2
        },
        {
          "key" : "lucene",
          "doc_count" : 2
        },
        {
          "key" : "solr",
          "doc_count" : 2
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1
        },
        {
          "key" : "data visualization",
          "doc_count" : 1
        }
      ]
    },
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [
        {
          "key" : "big data",
          "doc_count" : 3
        },
        {
          "key" : "open source",
          "doc_count" : 3
        },
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2
        },
        {
          "key" : "lucene",
          "doc_count" : 2
        },
        {
          "key" : "solr",
          "doc_count" : 2
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1
        },
        {
          "key" : "data visualization",
          "doc_count" : 1
        }
      ]
    }
  }
}
```

### 7.1.2 질의 결과에 실행하는 집계

- 전체 데이터 집합에 대해 지표를 계산
- ex) Denver 검색시, 그중 가장 인기있는 태그는?

- 요청
```json
GET get-together/_search
{
  "query": {
    "match": {
      "location_group": "Denver"
    }
  },
  "aggs": {
    "top_tags": {
      "terms": {
        "field": "tags.verbatim"
      }
    }
  }
}
```
- 결과
```json
{
  "took" : 15,
  "timed_out" : false,
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.7156682,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.7156682,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.7156682,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "big data",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 1
        },
        {
          "key" : "functional programming",
          "doc_count" : 1
        },
        {
          "key" : "java",
          "doc_count" : 1
        },
        {
          "key" : "jvm",
          "doc_count" : 1
        },
        {
          "key" : "lucene",
          "doc_count" : 1
        },
        {
          "key" : "solr",
          "doc_count" : 1
        }
      ]
    }
  }
}
```

- 질의에 from과 size 파라미터를 이용하여 질의 결과를 페이지별로 가지고 올 수 있다. 
  - 파라미터는 질의에 영향 미치지 않는다.
  - 집계는 질의에 일치하는 문서에만 동작한다.

### 필터와 집계

- 필터는 점수를 계산하지 않고 캐시 가능
- 필터와 유사한 질의보다 빠름. 전체 질의 성능에 좋다. 처음에 실행되기 때문에.
- 질의는 오직 필터에 일치되는 문서에만 동작. 집계는 질의에 의해 걸러진 결과에 동작.

- 요청
```json
GET get-together/_search
{
  "query": {
    "bool": {  // filtered deprecated
      "filter": {
        "term" : {
          "location_group": "denver"   
        }
      }
    }
  },
  "aggs": {
    "top_tags": {
      "terms": {
        "field": "tags.verbatim"
      }
    }
  }
}
```
- 결과
```json
{
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 0.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 0.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [ // 필터 후 처리
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "big data",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 1
        },
        {
          "key" : "functional programming",
          "doc_count" : 1
        },
        {
          "key" : "java",
          "doc_count" : 1
        },
        {
          "key" : "jvm",
          "doc_count" : 1
        },
        {
          "key" : "lucene",
          "doc_count" : 1
        },
        {
          "key" : "solr",
          "doc_count" : 1
        }
      ]
    }
  }
}

```

- 요청
```json
GET get-together/_search
{
  "post_filter": {
    "term" : {  
      "location_group": "denver"   
    }
  },
  "aggs": {
    "top_tags": {
      "terms": {
        "field": "tags.verbatim"
      }
    }
  }
}
```
- 결과
```json
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 2,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Denver Clojure",
          "organizer" : [
            "Daniel",
            "Lee"
          ],
          "description" : "Group of Clojure enthusiasts from Denver who want to hack on code together and learn more about Clojure",
          "created_on" : "2012-06-15",
          "tags" : [
            "clojure",
            "denver",
            "functional programming",
            "jvm",
            "java"
          ],
          "members" : [
            "Lee",
            "Daniel",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      },
      {
        "_index" : "get-together",
        "_type" : "_doc",
        "_id" : "2",
        "_score" : 1.0,
        "_source" : {
          "relationship_type" : "group",
          "name" : "Elasticsearch Denver",
          "organizer" : "Lee",
          "description" : "Get together to learn more about using Elasticsearch, the applications and neat things you can do with ES!",
          "created_on" : "2013-03-15",
          "tags" : [
            "denver",
            "elasticsearch",
            "big data",
            "lucene",
            "solr"
          ],
          "members" : [
            "Lee",
            "Mike"
          ],
          "location_group" : "Denver, Colorado, USA"
        }
      }
    ]
  },
  "aggregations" : {
    "top_tags" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 6,
      "buckets" : [ // 처리 후 필터
        {
          "key" : "big data",
          "doc_count" : 3
        },
        {
          "key" : "open source",
          "doc_count" : 3
        },
        {
          "key" : "denver",
          "doc_count" : 2
        },
        {
          "key" : "elasticsearch",
          "doc_count" : 2
        },
        {
          "key" : "lucene",
          "doc_count" : 2
        },
        {
          "key" : "solr",
          "doc_count" : 2
        },
        {
          "key" : "apache lucene",
          "doc_count" : 1
        },
        {
          "key" : "clojure",
          "doc_count" : 1
        },
        {
          "key" : "cloud computing",
          "doc_count" : 1
        },
        {
          "key" : "data visualization",
          "doc_count" : 1
        }
      ]
    }
  }
}
```

## 7.2 지표 집계

- 문서의 집합에서 통계 정보 추출
- 다른 집계에서 나온 문서의 버킷 분석
- 일반적으로 숫자 필드에 수행. 최소, 평균 등
- 통계값 각각 얻기. stats 이용해 여러 통계값 한번에 얻기, extended_stat 이용하기 등의 방법

### 7.2.1 통계

- 문서 수정하기 위해 스크립트 사용 가능
- 질의에 각 문서의 값을 반환하는 작은 스크립트 사용 가능

- 여러 stats
```json
# rumtime error
GET get-together/_search?size=0
{
  "aggs": {
    "att_stats": {
      "stats": { // count, min, max, avg, sum 동시 계산
        "script": "doc['attendees'].values.length"
      }
    }
  }
}
```

- 특정 stats : avg
  - 필요없는 stats가 있다면 분리하는 게 성능상 좋음 ㅇ
```json
# rumtime error
GET get-together/_search
{
  "size": 0,
  "aggs": {
    "att_stats": {
      "avg": { // 평균
        "script": "doc['attendees'].values.length"
      }
    }
  }
}
```

### 7.2.2 고급 통계

- 제곱의 합, 분산, 표준 편차 제공

- extended_stats
```json
# rumtime error
GET get-together/_search
{
  "size": 0,
  "aggs": {
    "att_stats": {
      "extended_stats": { // sum_of_squares, variance, std_deviation
        "script": "doc['attendees'].values.length"
      }
    }
  }
}
```


### 7.2.3 근사치 통계

- 지금까지의 통계는 모든 문서의 값을 찾아 계산하여, 매번 100% 정확
- 정확성은 낮지만 적은 메모리 사용하여 빠르게 조회하는 것도 가능

- percentiles
  - X% 이하인 값 구하기
  - ex) 상위 10% 사용자가 구매하는 상품 수
- cardinality
  - 필드의 유일한 값의 개수
  - ex) 웹사이트에 접근한 유일한 IP 수

#### - 백분위수 percentiles

- 예시
  - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/189fig01.jpg)
  - 99%에 해당하는 수 : 5명
  - 80%에 해당하는 수 : 4명

- 50에 까까울수록 정확도 떨어짐. 0과 100에 가까울수록 좋음
- compression 값에 비례하여 메모리 소비량 증가 (기본 100)

- percentile_ranks
  - 값의 집합을 명시하고, 명시한 값까지 일치하는 백분위 구하기
```bash
% curl "$URI?pretty&search_type=count" -d '{
"aggregations": {
  "attendees_percentile_ranks": {
    "percentile_ranks": {
      "script": "doc['"'attendees'"'].values.length",
      "values": [4, 5]
    }
  }
}}'
```

#### - 카디널리티 cardinality

- 근사치
- 메모리(모든 단어 적재), CPU(정렬), 네트워크(하나의 배열로 모으기) 사용 많음

```bash
URI=localhost:9200/get-together/group/_search
curl "$URI?pretty&search_type=count" -d '{
"aggregations": {
  "members_cardinality": {
    "cardinality": {
      "field": "members"
    }
  }
}}'
### reply
  "aggregations" : {
    "members_cardinality" : {
      "value" : 8
    }
  }
```

## 7.3 다중 버킷 집계

- 다중 버킷 집계는 각 태그에 일치하는 문서의 그룹을 버킷에 넣는다.
- 그리고 각 버킷에 있는 태그의 그룹 수를 집계한 하나 이상의 값을 갖는다.

- 종류
  - 텀즈
    - 빈도 계산
    - 단어별 버킷
  - 범위
    - 숫자, 날짜, IP 주소등
    - 범위를 버킷으로
  - 히스토그램
    - 숫자형, 날짜형 둘 중 하나를 사용
    - 간격을 버킷으로
  - 중첩
  - 지리 정보

### 7.3.1 텀즈 집계

  - 문서에서 자주 발생하는 상위 X개 정보를 가지고 올 때 사용
    - X : 문서의 필드. ex) 사용자명, 태그, 카테고리 등
  - 각 단어에 대한 계산
  - 이벤트의 설명처럼 분석된 필드에서 가장 많이 사용된 단어를 뽑아 낼 때 사용 가능
  - 문서에 많은 단어를 포함하고 있다면, 메모리 많이 필요함
  - 정렬은 단어수의 내림차순. 정렬 기준 변경 가능
    - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/194fig01.jpg)

#### - 응답에 포함할 단어

- 기본적으로 텀즈 집계는 상위 10개 반환
- size 파라미터 통해 조절 가능. 0으로 하면 모든 단어 반환
- 높은 cardinality를 가진 필드에서 사용할 경우 리소스 많이 사용

- shard_size = 2
  - 누락 가능성 있음
  - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig07_alt.jpg)

- shard_size = 3
  - ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig08_alt.jpg)

- 집계 결과 시작 부분
  - 최악의 오차 범위
  - 상위 개수에 포함되지 않는 텀의 전체 발생 수
```json
"tags" : {
  "doc_count_error_upper_bound" : 0,
  "sum_other_doc_count" : 6,
  ...
}
```

- 특정 단어 포함 여부
  - include, exclude 을 정규표현식으로 제어
  - 동시 적용시, exclude 후 include
```bash
URI=localhost:9200/get-together/group/_search
curl "$URI?pretty&search_type=count" -d '{
"aggregations": {
  "tags": {
    "terms": {
      "field": "tags.verbatim",
      "include": ".*search.*"

    }
  }
}}'
### reply
  "aggregations" : {
    "tags" : {
      "buckets" : [ {
        "key" : "elasticsearch",
        "doc_count" : 2
      }, {
        "key" : "enterprise search",
        "doc_count" : 1
```

#### - 중요한 단어 significant_terms

- 평균보다 더 자주 나타나는 단어 조회할 때 유용
  - 포그라운드 문서와 백그라운드 문서의 백분율 차이로 매긴 점수 기준
  - 백그라운드 문서 : ex) clojure 단어가 전체 문서에서 발견될 횟수. 0.001%
  - 포그라운드 문서 : ex) Denver 검색시 clojure가 해당 결과 문서에서 발견될 횟수. 0.07%

- 예시 : Lee 사용자와 유사한 성향의 사용자 찾기
- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex10-0.jpg)
- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex10-1.jpg)

### 7.3.2 범위 집계

- 범위 지정하여 버킷 만들기
- 범위의 최소값은 버킷에 포함 : 최소값 <= X
- 범위의 최대값은 버킷에 미포함 : X < 최대값
- 범위의 겹침, 완전 분리 모두 가능

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex11-0.jpg)
  - X < 4 , 4 <= X < 6, 6 <= X
- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex11-1.jpg)

#### - 날짜 범위 집계

- 날짜도 long 타입 저장이라 범위 지정 가능
- 날짜 형식 정의 필요

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex12-0.jpg)
- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex12-1.jpg)

### 7.3.3 히스토그램 집계

- 고정된 간격으로 범위 지정

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/202fig01.jpg)

#### - 날짜 히스토그램 집계

- 1M, 1.5h 가능
- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/203fig01_alt.jpg)



## 7.4 중첩 집계

- 다중 버킷 집계는 일반적으로 집계를 중첩하는 시작 지점이다.

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig10_alt.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig11_alt.jpg)

### 7.4.1 다중 버킷 집계 중첩

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex15-0.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex15-1.jpg)


### 7.4.2 결과를 그룹 지어 가지고 오는 중첩 집계

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex16-0.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex16-1.jpg)


### 7.4.3 단일 버킷 집계 사용하기

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig12.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex17-0.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex17-1.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/07fig13.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex18-0.jpg)

- ![](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/ch07ex18-1.jpg)

```bash
% curl "$URI?pretty&search_type=count" -d '{
"aggregations": {
  "event_dates": {
    "date_histogram": {
      "field": "date",
      "interval": "1M"
    }
  },
  "missing_date": {
    "missing": {
      "field": "date"
    }
  }
}}'
```
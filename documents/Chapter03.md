 Chapter03. 데이타를 인덱싱, 업데이팅 그리고 삭제하기 
- 매핑타입들을 사용하여 같은 인덱스내 다양한 타입들의 도큐먼트들을 정의
- 매핑들 내에서 사용할 수 있는 필드들의 타입들
- 미리정해진 필드들과 그 옵션들을 사용하기
- 위의 내용으로 인덱싱하고, 데이타를 업데이팅 그리고 삭제하기

이장은 엘라스틱서치로 데이타를 넣고(updating) 빼내고(deleting) 관리하는 것(indexing)에 대한 내용이다. 
엘라스틱 서치는 도큐먼트 베이스이고, 도큐먼트들은 필드들과 필드들의 값으로 구성되어있고, 이런 구성이 도규먼트 자체내에 담겨져있다 
마치 테이블내에 로우들 내에서 컬럼이름들을 가지는 것처럼 말이다. 

필드들에 대한 3가지 타입들
- Core : string, numbers(text, keyword)
- Arrays 와 multi-fields : 
- Predefined : 메타데이타  ex) _ttl, _timestamp  (_ttl : 일정시간 후 도큐먼트들을 삭제) - 이런필드들은 엘라스틱 서치에 의해서 자동적으로 관리되어질 수 있는 메타데이타로 생각하면 된다.


3.1 매핑들을 사용해서 다양한 종류의 도큐먼트들을 정의하라
각 도규먼트는 타입에 속해 있고, 이는 각각의 인덱스에 속해있다  (type은. 7.0 이상 상위버전부터 deprecated)
인덱스들은 데이타베이스들로 생각할 수 있다. 예를 들어 2장에서 봤던 get-together 인덱스에는ㅠGroup 와 events 의 타입이 있고 그 타입내 각각의 도큐먼트는 
각각의 다른 구조를 가지고 있다. 즉, 다른 타입으로 유지하기를 원할 것이다. 
타입은 논리적인 구분으로만 사용되어지는데, 
매핑내에서 각 필드의 정의를 포함하고, mapping은 도큐먼트내의 모든 필드들을 포함하고, 타입은 엘라스틱서치에게 어떻게 도큐먼트네에서 필드들을 인덱스해야하는지 말해준다.

그림.

3.1.1 매핑들을 구하고 정의하기
현재매핑을 얻기


새로은 매핑을 정의하기
(새로운 매핑은 인덱스를 생성한 후, 그리고, 그 타입으로 어떠한 도큐먼트를 인서트하기전에 정의를 할 수 있다)


3.2 기존 매핑을 확장하기
이미 매핑이 있다면 머지한다. 
하지만, 기존 필드의 데이타 타입을 변경할 수 없다 (MergeMappingException). 즉, 필드에 대해 인덱스 되어지는 방식을 변경할 수 없다
이는 재인덱스 하는 방식으로 해결할 수 있다. 
1. new_events type에 있는 모든 데이타들 지운다. 데이타를 제거하는 것은 현재매핑을 지운다.
2. 새로은 매핑을 넣는다
3. 다시 모든 데이타를 인덱스한다. 


3.2 core types
필드는 코어타입들 또는 복합적인 타입(예, 배열), nested type(도큐먼트내 도큐먼트) or geo_point (지구상의 위도경도위치, 내장된 필드) type


3.2.1 string  (text, keyword로 사용됨)
Analysis 는 관련된 서치를 만들기 위해 엘레먼트들을 쪼개고 텍스트를 파싱하는 과정이다. 
Term 이라는 용어는 서칭하기 위해 가장 기본적인 단위이며 텍스트에서 추출된 용어이다. 


3.2 그림. 그리고, 용어들의 동의어를 만들어 낼 수 있게 분석방법을 설정할 수 있다. 
  Analysis 프로세스는 매핑안에서 분석하기 위해 여러가지 옵션들로 구성된다. 

  Index 옵션에 analyzed , not analyzed, no 로 셋팅할 수 있다.  (6.x 이후부터는 다르게 사용됨)
  Index 옵션이 analyzed 로 셋팅되면 , Analyzer 가 소문자로 모든 문자들을 단어별로 쪼갠다. 
  ex. “Elasticsearch” 라고 searching 하면 “Late night with Elasticsearch” 를 결과로 기대할 것임

  Not_analyzed 는 전체 용어가 매칭되어야지만 서칭이 된다. (대소문자도 구분해서 서칭함)
  ex. “Big data”, 1. Data 로 서치 2, Big data 로 서칭

  No 라고 셋팅되면, 인덱싱이 스킵되고 어떠한 terms 도 만들어지지 않고, 특정필드 서칭이 불가하다. 이는
  인덱스하고 서치하는 데 필요한 공간을 절약하고 시간을 줄여준다.

3.2.2 numeric
  Byte, short, integer, long, double : 자바의 primitive data type 과 동일

3.2.3  date
  루슨 인덱스내에서 Date 타입은 string으로 파싱하고+ long 타입으로 저장. 
  Date string의 데이트 포맷은 포맷옵션으로 정해지고 디폴트로 iso 8601

  ex. 포맷옵션 : predefiend date format 2019-02-22
      Custom format : MMM YYYY : Jul 2001

3.2.4 Boolean
  true/false

3.2.5 arrays and mult-fields
  필드내 다중 값들을 인덱스 하기 위해, [] 를 사용해서 값들을 열거한다.
  Array 필드는 스트링처럼 필드를 정의하고, 특별히 배열로 정의되는 방식은 없다
  String 의 싱글필드가 하는 것처럼
  Tags: { “type” : “string” } 하고, 값을 [] 를 이용해서 동일 데이타 타입으로 열거하는 방식. 

3.3.2 
  멀티필드는 같은 데이타를 다른 방식으로 여러번 인덱싱하는 방식이다. 
  
  
3.4 predefined fields 를 사용하라
  _ 로 시작하는 필드이름들, 도큐먼트들에 대한 새로운 메타데이타이다. 
  _timestamp : 도큐먼트가 인덱스되어졌을때 date를 기록하는 필드
  _ttl  : 특정 시간 후에 도큐먼트들을 제거하는 필드
  _source : 인덱스하는 json 도큐먼트들을 저장하도록 하는 필드
  _uid, _id, _type, _index : 도큐먼트들을  identify 하는 필드들 
  _size : 원 json 사이즈
  _routing : 스케일링에 관련되는 필드
  _parent : 도큐먼트들간의 관계
  _all field : 도큐먼트내에 함계 인덱스 되어지는 모든 필드들 


3.4.1  도큐먼트들을 저장하고 서치하는 방법을 제어하기
  _all : 싱글 필드내에 모든 내용들을 인덱스하게 함
  _source : 인덱스시 패스되어지는 json doc body이고, 그 자체는 index 와 서칭이 안되지만, 이는 저장되고, fetch request , get, search 같은, 
            실행되어질 때 리턴되어진다. 스토리지 과부하를 초래할 수도 있지만,  disable 하게 된다면, update, update_by_query, reindex 등 
            많은 기능들이 지원되지 않는다. 
           _source 로 부터 필드들을 including/excluding 가능하다. 소스필터링이 가능하다. 

  _index : 여러 인덱스들에서 쿼리들을 실행할 경우, 쿼리 절을 추가하여 어떤 특정 인덱스들의 도큐먼트들과 함께 수행할 수 있다. 
  _index 의 값은 소팅시 또는 스크립팅시, 어떤 쿼리들 과 aggregations 에서 접근이 가능하다 

  _type
  _id : 각 도큐는 식별하기 위해 _id를 가지고, 이는 인덱스되어진다. 그래서 도큐먼트들은 GET API 또는 ids 쿼리를 통해 검색되어진다.
  _id 의 값은 term, terms,match, query_string, simple_query_string 같은 쿼리들에 의해 찾을 수 있다. 

  _uid :상위버전에서 삭제됨

  수동적으로 id를 제공하기 위해서 auto_id 를 사용

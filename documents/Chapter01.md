# Chapter01 일래스틱서치 소개

- 오픈소스 분산시스템
- 검색 라이브러리인 Apache Lucene 기반
  - Lucene : 자바 애플리케이션에 검색 기능을 구현
  - Elasticsearch : Lucene 기능을 가지고 와서 좀 더 빠르고 쉽게 데이터를 저장하고, 색인을 만들고, 검색할 수 있게 확장
- 확장 가능
- REST API 제공

## 1.1 일래스틱서치로 검색 문제 해결

- 단순 키워드 **검색**을 넘어,
- 결과가 **빠르게** 나와야 하고,
- **관련**된 것이어야 하며,
- 찾고자 하는 정확한 단어를 **모를** 때 도와주고,
  - **오타**를 찾고,
  - **추천**을 제공하며,
  - 결과를 **Category**로 나누는 것을 포함

### 1.1.1 빠른 검색 제공

- 모든 데이터를 색인하기 위해 고성능 검색엔진 라이브러리인 Lucene 이용
  - Lucene은 역 색인(Inverted Indexing) 사용 : 각각의 단어가 어디에 속해 있는지 목록을 유지하는 자료 구조
  
    | 미가공 데이터 | | 색인 데이터 | |
    | ---------- | ---------- | --------- | --------- |
    | 블로그 글 ID | 태그 | 태그 | 블로그글 ID |
    | 1 | 투표 | 투표 | 1, 3 |
    | 2 | 평화 | 평화 | 2, 3, 4 |
    | 3 | 투표, 평화 | | |
    | 4 | 평화 | | |

  - 역 색인을 통해 빠른 검색 가능
  - 역 색인이 관련성 확인에 도움
    - 일치하는 문서의 개수도 얻을 수 있어 ( elasticsearch in action )
    - 대부분의 문서에 해당 단어가 있다면 관련성이 적다는 의미 ( in )
    - 적당한 수의 문서에 단어가 포함되어 있다면 잘 검색하고 있다는 의미 ( elasticsearch , action )
  - 검색 성능 , 관련성 균형 중요
    - 색인은 디스크 공간 차지. 글 추가 느려짐. 추가시마다 색인 갱신해야 해서.

### 1.1.2 관련 결과 보장

- 관련성 점수 : "**키워드가 단순 포함**"된 글 보다는 "**키워드와 관련**"된 글이 더 중요
- 관련성 점수용 알고리즘 중 하나 tf-idf
  - 단어 빈도 term frequency : 문서에 찾고자 하는 단어가 많이 나올수록, 문서에 높은 점수
  - 역 문서 빈도 inverse document frequency : 단어가 다른 문서들 간에 흔치 않으면, 단어에 가중치
- 그외
  - 글의 제목 등 특정 필드에
  - 정확한 일치
  - 사용자 선호도
  - 새로운 글
  

### 1.1.3 완전 일치를 뛰어넘어 검색하기

- 직관적인 검색을 위해 완전 일치 수준을 넘기기
- 오타, 동의어, 파생어 등으로 검색 가능하게

- 오타 처리
  - 정확한 일치가 아닌 변형된 것들 찾기 가능
  - 퍼지 fuzzy 질의를 사용하면 "bicycel"로 검색 가능

- 파생어 지원
  - 분석 analysis 사용하면 "bicycle" 에 대해 "bicyclist", "cycling"을 포함한 질의와 일치하도록 할 수 있음

- 통계 사용
  - 무엇을 검색할지 모를 때, 집계 aggregation 을 통해, 통계로 도움을 줄 수 있음
  - 질의의 결과로 수치가 나옴
  - ex. 주제별, 범주별 좋아요 수, 공유 수 등

- 제안 제공
  - 사용자 입력이 시작될 때, 인기 있는 검색과 결과를 찾도록 도움. 검색 예측
  - 접두어, 와일드카드, 정규표현식등의 특별한 질의 형태 가능

---
## 1.2 일반적인 일래스틱서치 사용 사례

- 일래스틱서치는 검색엔진일뿐, 그것 자체만 사용하지 않음
- 데이터를 집어 넣을 방법이 필요
- 데이터 검색을 위한 인터페이스가 필요

- 전형적 시나리오 3개
  - 웹사이트의 기본 백엔드로 : ES를 이용하면 모든 글을 저장하고 질의할 수 있음
  - 기존 시스템에 추가 : 대량의 데이터를 고속으로 처리하는 시스템 존재시. 검색 기능만 추가
  - 기존 시스템의 백엔드로 : 로그 수집 용도 등. 이미 만들어진 도구 활용

---
## # 활용 방법

### 1.2.1 ES를 기본 백엔드로

![그림1-2](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig02.jpg)

- 전통적으로 데이터 저장소 위에 배포
- 과거에는 검색엔진이 내구성 있는 저장소나 통계 같은 기능을 제공하지 않았음
- 일래스틱서치는 내구성 있는 저장소와 통계, 그외 많은 기능을 제공
- 단일 데이터 저장소로 사용 가능 (NoSQL 저장소)
- 업데이트 많은 경우에는 부적합
- 트랜잭션 미지원
- 서버가 내려가면, 다른 서버에 데이터를 복제하여 내고장성 확보 가능

### 1.2.2 기존 시스템에 ES 추가

![그림1-3](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig03.jpg)

- 데이터 저장소로써의 모든 기능 없기 때문에, 다른 저장소에 검색 기능을 부가적으로 추가
- 두 저장소간 동기화 필요. 플러그인을 배포해 동기화하거나 직접 서비스를 만들 수 있음
  - 각각의 상품과 일치하는 모든 데이터를 가져와서,
  - 일래스틱서치에 색인할 수 있고,
  - 각각의 상품은 하나의 문서로 저장

### 1.2.3 기존 도구와 ES 함께 사용

![그림1-4](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig04_alt.jpg)

- 많은 도구가 제공됨
- 경우에 따라 한 줄의 코드도 작성하지 않고 일래스틱서치 사용 가능


![이벤트 색인](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/012fig01_alt.jpg)

![검색 요청](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/012fig02_alt.jpg)

- JAVA API외에 REST API 제공. 기본적으로 요청/응답에 JSON 활용. YAML도 지원
- 보통 HTTP 통신에 JSON, 설정에 YAML 사용

---
## # 특징 소개

### 1.2.4 주요 특징

- 데이터를 색인하고, 검색하는 Lucene의 기능들에 쉽게 접근 가능
  - 색인 측면에서 어떻게 문서를 처리하고, 저장할지 많은 선택 존재. ES의 REST API로 가능
  - 검색 시에 여러 질의와 필터들에 대한 선택 존재. ES의 REST API로 가능
- 고수준 기능
  -  (루씬이 제공하는 것에 기반으로) 캐시부터 실시간 분석까지 고수준 기능이 추가
- 문서 구조화
  - 여러 색인을 분리하거나 함께 검색 가능
  - 하나의 색인에 다른 타입의 문서 넣기 가능
- 신축성
  - 서버 추가, 제거 가능

### 1.2.5 루씬의 기능 확장

- 여러 가지 방법으로 다른 형태의 질의를 조합하기 위한 질의 JSON 구성 가능
- JSON 검색은 질의, 필터, 집계를 포함해서 일치한 문서들로부터 통계 생성 가능
- REST API를 통해 설정, 문서 색인하는 방법도 읽거나 변경 가능
- 일래스틱서치terms : 분석analysis 을 통해 색인하는 문서에서 추출된 단어words
  ex. "bicycle race" -> "bicycle", "race", "cycling", "racing"
- 분석기
  - 공통 단어 분리기(공백, 쉽표등) 등 많은 분석기 존재하고 직접 만들 수 있음

![그림1-5](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig05_alt.jpg)

- 일래스틱서치는 문서를 있는 그대로 저장하고,
- 분석을 통해 파생된 텀들을 역 색인에 넣어서 빠른 검색 가능

### 1.2.6 데이터 구조화하기

- RDB : ROWS (레코드나 행)에 데이터 저장. 각 "열은 행마다" 값을 가진다.
- 일래스틱서치 : "문서" 단위 저장. 문서마다 "키"와 값을 가진다.
- 문서는 계층적 구성 가능. 좀더 유연함
  - ex1. 배열 : "tags" : ["cycling", "cicycles"]
  - ex2. 키와 값 쌍 : "author" : { "first_name" : "Joe", "last_name" : "Smith" }
- RDB는 엔티티 분리하여 JOIN
- 일래스틱서치는 문서 내에 관련 데이터 저장. JOIN 미지원

---
## # 설치 방법

### 1.2.7 자바 설치

- JRE 필요
- 1.7 이후에는 어떤 JRE든 동작 가능

### 1.2.8 ES 내려 받기

- 제공 형태
  - 압축 파일 : tar.gz , ZIP
  - 패키지 : brew, rpm, deb

- 기본 로그 위치
  - 압축 파일 : $ES_HOME/logs
  - 패키지 : /var/log/elasticsearch

### 1.2.9 동작 확인

1) 시작한 노드에 관한 상태 정보.
  - 노드 이름 확인 : 임의의 이름을 노드에 할당. 설정 가능
  - JVM의 pid 확인 가능
```bash
[node] [Karkas] version[1.4.0], pid[6011], build[bc94bd8/2014-11-05T14:26:12Z]
```

2) 플러그인 로드
  - 시작 시점에 플러그인 로드
  - 기본으로는 아무 것도 없음
```bash
[plugins] [Karkas] loaded [], sites []
```

3) 노드간 통신 포트
  - 트랜스포트를 위한 포트
  - JAVA API 사용시 이 포트 사용
  - 기본값 :9300
```bash
[transport] [Karkas] bound_address {inet[/0.0.0.0:9300]}, publish_address {inet[/192.168.1.8:9300]}
```

4) 마스터 노드 선출
  - 어떤 노드가 클러스터에 있고,
  - 어디에 모든 샤드들이 있는지 알고 있는 노드
  - 유효하지 않으면 새 노드가 선출
```bash
[cluster.service] [Karkas] new_master [Karkas][YPHC_vWiQVuSX-ZIJIlMhg][inet[/192.168.1.8:9300]], reason: zen-disco-join (elected_as_master)
```

5) HTTP 통신 포트
  - REST API 포트
  - 기본값 : 9200
```bash
[http] [Karkas] bound_address {inet[/0.0.0.0:9200]}, publish_address {inet[/192.168.1.8:9200]}
```

6) 노드 시작 메시지
```bash
[node] [Karkas] started
```

7) 게이트웨이
  - 데이터를 디스크에 기록하는 일래스틱서치 구성 요소
  - 노드가 내려가도 데이터를 잃지 않도록 함
```bash
[gateway] [Karkas] recovered [0] indices into cluster_state
```




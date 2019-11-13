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

- 관련성 점수 : **"키워드가 단순 포함"**된 글 보다는 **"키워드와 관련"**된 글이 더 중요
- 관련성 점수용 알고리즘 중 하나 tf-idf
  - 단어 빈도 term frequency : 문서에 찾고자 하는 단어가 많이 나올수록, 문서에 높은 점수
  - 역 문서 빈도 inverse document frequency : 단어가 다른 문서들 간에 흔치 않으면, 단어에 가중치
- 그외
  - 글의 제목 등 특정 필드에
  - 정확한 일치
  - 사용자 선호도
  - 새로운 글
  


### 1.1.3 완전 일치를 뛰어넘어 검색하기


---
## 1.2 일반적인 일래스틱서치 사용 사례

---
## 조합 방법

### 1.2.1 ES를 기본 백엔드로

![그림1-2](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig02.jpg)

### 1.2.2 기존 시스템에 ES 추가

![그림1-3](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig03.jpg)


### 1.2.3 기존 도구와 ES 함께 사용

![그림1-4](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig04_alt.jpg)

![이벤트 색인](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/012fig01_alt.jpg)

![검색 요청](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/012fig02_alt.jpg)


---
## 특징 소개

### 1.2.4 주요 특징

### 1.2.5 루씬의 기능 확장

![그림1-5](https://dpzbhybb2pdcj.cloudfront.net/hinman/Figures/01fig05_alt.jpg)


### 1.2.6 데이터 구조화하기

---
## 설치

### 1.2.7 자바 설치

### 1.2.8 ES 내려 받기

### 1.2.9 동작 확인

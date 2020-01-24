# Elasticsearch Study

엘라스틱서치의 스터디 내용을 정리합니다.

책은 Elasticsearch in Action (ISBN: 9788960779105)을 활용합니다.

## Run Elasticsearch-Kibana using Docker

로컬 연습 환경을 구성하기 위해 아래와 같이 진행합니다. ([docker-compose를 이용한 ElasticSearch Cluster구성](https://jistol.github.io/docker/2019/03/27/docker-compose-elasticsearch-cluster/) 참고)

엘라스틱서치, 키바나 각각 *7.5.2* 버전을 사용합니다.

1. 해당 repository로 이동

    ```bash
    git clone https://github.com/bda-study/elasticsearchhttps://github.com/bda-study/elasticsearch
    cd elasticsearch
    ```

2. docker-compose 실행

    ```bash
    docker-compose up -d
    ```

3. 키바나 접속 (localhost:5601)
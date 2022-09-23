#!/usr/bin/env just --justfile

export PREFIX := env_var_or_default('PREFIX','llsem-')
export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','jammy-20220815')
export JAVA_VER_DISTRO_8 := env_var_or_default('JAVA_VER_DISTRO_8','8.0.345-zulu')
export JAVA_VER_DISTRO_11 := env_var_or_default('JAVA_VER_DISTRO_11','11.0.16.1-zulu')
export JAVA_VER_DISTRO_17 := env_var_or_default('JAVA_VER_DISTRO_17','17.0.4.1-zulu')
export JAVA_VER_DISTRO_18 := env_var_or_default('JAVA_VER_DISTRO_18','18.0.2.1-zulu')
export JAVA_VER_DISTRO_19 := env_var_or_default('JAVA_VER_DISTRO_19','19-zulu')
export KOTLIN_VER := env_var_or_default('KOTLIN_VER','1.7.10')
export KSCRIPT_VER := env_var_or_default('KSCRIPT_VER','4.1.1')
export SCALA_VER := env_var_or_default('SCALA_VER','3.2.0')
export ANT_VER := env_var_or_default('ANT_VER','1.10.12')
export MAVEN_VER := env_var_or_default('MAVEN_VER','3.8.6')
export SBT_VER := env_var_or_default('SBT_VER','1.7.1')
export BLAZEGRAPH_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_GIT_COMMIT_ID','2bd33dca')
export BLAZEGRAPH_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_DISTRO_VERSION','2.1.6-SNAPSHOT')
export CASSANDRA_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_GIT_COMMIT_ID','7adfdc85')
export CASSANDRA_DISTRO_VERSION := env_var_or_default('CASSANDRA_DISTRO_VERSION','4.2')
export JENA_GIT_COMMIT_ID := env_var_or_default('JENA_GIT_COMMIT_ID','6139e6b7')
export JENA_DISTRO_VERSION := env_var_or_default('JENA_DISTRO_VERSION','4.7.0-SNAPSHOT')


all: build-ubuntu build-zulu build-kotlin build-scala build-ant build-maven build-sbt build-blazegraph build-cassandra build-jena


# Ubuntu recipes
build-ubuntu:
   time docker image build --pull -f Dockerfile.ubuntu -t ${PREFIX}ubuntu:latest --build-arg PARENT_TAG=${UBUNTU_TAG} .

list-dockerhub-ubuntu-tags:
   curl -Ls 'https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?page_size=1024'| jq '."results"[]["name"]' | grep jammy


# OpenJDK Zulu recipes
build-zulu: build-zulu-8 build-zulu-11 build-zulu-17 build-zulu-18 build-zulu-19

build-zulu-8: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:8  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_8}  .
  
build-zulu-11: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:11  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_11}  .
  
build-zulu-17: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:17  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_17}  .

build-zulu-18: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:18  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_18}  .

build-zulu-19: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:19  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_19}  .

# Kotlin recipes
build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17 build-kotlin-18 build-kotlin-19

build-kotlin-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-18: build-zulu-18
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-19: build-zulu-19
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .


# Scala recipes
build-scala: build-scala-8 build-scala-11 build-scala-17 build-scala-18 build-scala-19

build-scala-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-18: build-zulu-18
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-19: build-zulu-19
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg SCALA_VER=${SCALA_VER} .


# Apache Ant recipes
build-ant: build-ant-8 build-ant-11 build-ant-17 build-ant-18 build-ant-19

build-ant-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg ANT_VER=${ANT_VER} .

build-ant-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg ANT_VER=${ANT_VER} .

build-ant-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg ANT_VER=${ANT_VER} .

build-ant-18: build-kotlin-18
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg ANT_VER=${ANT_VER} .

build-ant-19: build-kotlin-19
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg ANT_VER=${ANT_VER} .


# Apache Maven recipes
build-maven: build-maven-8 build-maven-11 build-maven-17 build-maven-18 build-maven-19

build-maven-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-18: build-kotlin-18
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-19: build-kotlin-19
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg MAVEN_VER=${MAVEN_VER} .


# SBT recipes
build-sbt: build-sbt-8 build-sbt-11 build-sbt-17 build-sbt-18 build-sbt-19

build-sbt-8: build-scala-8
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg SBT_VER=${SBT_VER} .

build-sbt-11: build-scala-11
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg SBT_VER=${SBT_VER} .

build-sbt-17: build-scala-17
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg SBT_VER=${SBT_VER} .

build-sbt-18: build-scala-18
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg SBT_VER=${SBT_VER} .

build-sbt-19: build-scala-19
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg SBT_VER=${SBT_VER} .


# Blazegraph recipes
build-blazegraph: build-maven-8
   time docker image build -f Dockerfile.ubuntu-blazegraph -t ${PREFIX}ubuntu-blazegraph:latest --build-arg PREFIX=${PREFIX} --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_DISTRO_VERSION} .

list-blazegraph-upstream-master-commit-id:
   git ls-remote https://github.com/blazegraph/database heads/master

list-blazegraph-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/blazegraph/database/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Apache Cassandra recipes
build-cassandra: build-cassandra-11

build-cassandra-11: build-ant-11
   time docker image build -f Dockerfile.ubuntu-cassandra -t ${PREFIX}ubuntu-cassandra:latest --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_DISTRO_VERSION} .

list-cassandra-upstream-trunk-commit-id:
   git ls-remote https://github.com/apache/cassandra heads/trunk

list-cassandra-upstream-main-build-version:
   curl -Ls https://raw.githubusercontent.com/apache/cassandra/trunk/build.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath 'string(/project/property[@name="base.version"]/@value)' -


# Apache Jena recipes
build-jena: build-jena-11 build-jena-17 build-jena-18 build-jena-19

build-jena-11: build-maven-11
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg JENA_GIT_COMMIT_ID=${JENA_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_DISTRO_VERSION} .

build-jena-17: build-maven-17
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg JENA_GIT_COMMIT_ID=${JENA_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_DISTRO_VERSION} .

build-jena-18: build-maven-18
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:18 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=18 --build-arg JENA_GIT_COMMIT_ID=${JENA_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_DISTRO_VERSION} .

build-jena-19: build-maven-19
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:19 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=19 --build-arg JENA_GIT_COMMIT_ID=${JENA_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_DISTRO_VERSION} .

list-jena-upstream-main-commit-id:
   git ls-remote https://github.com/apache/jena heads/main

list-jena-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/jena/main/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -

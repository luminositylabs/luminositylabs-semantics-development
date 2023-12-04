#!/usr/bin/env just --justfile

export PREFIX := env_var_or_default('PREFIX','llsem-')
export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','jammy-20231128')
export JAVA_VER_DISTRO_8 := env_var_or_default('JAVA_VER_DISTRO_8','8.0.392-zulu')
export JAVA_VER_DISTRO_11 := env_var_or_default('JAVA_VER_DISTRO_11','11.0.21-zulu')
export JAVA_VER_DISTRO_17 := env_var_or_default('JAVA_VER_DISTRO_17','17.0.9-zulu')
export JAVA_VER_DISTRO_21 := env_var_or_default('JAVA_VER_DISTRO_21','21.0.1-zulu')
export KOTLIN_VER := env_var_or_default('KOTLIN_VER','1.9.21')
export KSCRIPT_VER := env_var_or_default('KSCRIPT_VER','4.2.3')
export SCALA_VER := env_var_or_default('SCALA_VER','3.3.1')
export ANT_VER := env_var_or_default('ANT_VER','1.10.13')
export GRADLE_VER := env_var_or_default('GRADLE_VER','8.5')
export MAVEN_VER := env_var_or_default('MAVEN_VER','3.9.6')
export SBT_VER := env_var_or_default('SBT_VER','1.9.7')
export BLAZEGRAPH_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_GIT_COMMIT_ID','829ce824')
export BLAZEGRAPH_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_DISTRO_VERSION','2.1.6-SNAPSHOT')
export BLAZEGRAPH_RELEASE_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_RELEASE_GIT_COMMIT_ID','BLAZEGRAPH_RELEASE_2_1_5')
export BLAZEGRAPH_RELEASE_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_RELEASE_DISTRO_VERSION','2.1.5')
export CASSANDRA_TRUNK_PARENT_TAG := env_var_or_default('CASSANDRA_TRUNK_PARENT_TAG','17')
export CASSANDRA_TRUNK_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_TRUNK_JAVA_MAJOR_VERSION','17')
export CASSANDRA_TRUNK_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_TRUNK_GIT_COMMIT_ID','7204bc45')
export CASSANDRA_TRUNK_DISTRO_VERSION := env_var_or_default('CASSANDRA_TRUNK_DISTRO_VERSION','5.1-SNAPSHOT')
export CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION','11')
export CASSANDRA_RELEASE_4_1_PARENT_TAG := env_var_or_default('CASSANDRA_RELEASE_4_1_PARENT_TAG','11')
export CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID','cassandra-4.1.3')
export CASSANDRA_RELEASE_4_1_DISTRO_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_DISTRO_VERSION','4.1.3')
export JENA_MAIN_GIT_COMMIT_ID := env_var_or_default('JENA_MAIN_GIT_COMMIT_ID','221ac772')
export JENA_MAIN_DISTRO_VERSION := env_var_or_default('JENA_MAIN_DISTRO_VERSION','5.0.0-SNAPSHOT')
export JENA_RELEASE_4_10_PARENT_TAG := env_var_or_default('JENA_RELEASE_4_10_PARENT_TAG','17')
export JENA_RELEASE_4_10_GIT_COMMIT_ID := env_var_or_default('JENA_RELEASE_4_10_GIT_COMMIT_ID','jena-4.10.0')
export JENA_RELEASE_4_10_DISTRO_VERSION := env_var_or_default('JENA_RELEASE_4_10_DISTRO_VERSION','4.10.0')
export SPARK_MASTER_GIT_COMMIT_ID := env_var_or_default('SPARK_MASTER_GIT_COMMIT_ID','f2ea75f2')
export SPARK_MASTER_DISTRO_VERSION := env_var_or_default('SPARK_MASTER_DISTRO_VERSION','4.0.0-SNAPSHOT')
export SPARK_RELEASE_3_5_PARENT_TAG := env_var_or_default('SPARK_RELEASE_3_5_PARENT_TAG','17')
export SPARK_RELEASE_3_5_GIT_COMMIT_ID := env_var_or_default('SPARK_MASTER_GIT_COMMIT_ID','v3.5.0')
export SPARK_RELEASE_3_5_DISTRO_VERSION := env_var_or_default('SPARK_MASTER_DISTRO_VERSION','3.5.0')
export WIDOCO_MAIN_GIT_COMMIT_ID := env_var_or_default('WIDOCO_MAIN_GIT_COMMIT_ID','4da92b23')
export WIDOCO_MAIN_DISTRO_VERSION := env_var_or_default('WIDOCO_MAIN_DISTRO_VERSION','1.4.20')

default:
  @echo "Invoke just --list to see a list of possible recipes to run"

all: build-ubuntu build-zulu build-kotlin build-scala build-ant build-gradle build-maven build-sbt build-blazegraph build-cassandra build-jena build-spark build-widoco


# Ubuntu recipes
build-ubuntu:
   time docker image build --pull -f Dockerfile.ubuntu -t ${PREFIX}ubuntu:latest --build-arg PARENT_TAG=${UBUNTU_TAG} .

list-dockerhub-ubuntu-tags:
   curl -Ls 'https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?page_size=1024'| jq '."results"[]["name"]' | grep jammy


# OpenJDK Zulu recipes
build-zulu: build-zulu-8 build-zulu-11 build-zulu-17 build-zulu-21

build-zulu-8: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:8  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_8}  .
  
build-zulu-11: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:11  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_11}  .
  
build-zulu-17: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:17  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_17}  .

build-zulu-21: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:21  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_21}  .

# Kotlin recipes
build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17 build-kotlin-21

build-kotlin-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-21: build-zulu-21
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .


# Scala recipes
build-scala: build-scala-8 build-scala-11 build-scala-17 build-scala-21

build-scala-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg SCALA_VER=${SCALA_VER} .

build-scala-21: build-zulu-21
   time docker image build -f Dockerfile.ubuntu-scala -t ${PREFIX}ubuntu-scala:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg SCALA_VER=${SCALA_VER} .


# Apache Ant recipes
build-ant: build-ant-8 build-ant-11 build-ant-17 build-ant-21

build-ant-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg ANT_VER=${ANT_VER} .

build-ant-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg ANT_VER=${ANT_VER} .

build-ant-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg ANT_VER=${ANT_VER} .

build-ant-21: build-kotlin-21
   time docker image build -f Dockerfile.ubuntu-ant -t ${PREFIX}ubuntu-ant:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg ANT_VER=${ANT_VER} .


# Gradle recipes
build-gradle: build-gradle-8 build-gradle-11 build-gradle-17 build-gradle-21

build-gradle-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-gradle -t ${PREFIX}ubuntu-gradle:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg GRADLE_VER=${GRADLE_VER} .

build-gradle-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-gradle -t ${PREFIX}ubuntu-gradle:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg GRADLE_VER=${GRADLE_VER} .

build-gradle-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-gradle -t ${PREFIX}ubuntu-gradle:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg GRADLE_VER=${GRADLE_VER} .

build-gradle-21: build-kotlin-21
   time docker image build -f Dockerfile.ubuntu-gradle -t ${PREFIX}ubuntu-gradle:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg GRADLE_VER=${GRADLE_VER} .


# Apache Maven recipes
build-maven: build-maven-8 build-maven-11 build-maven-17 build-maven-21

build-maven-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg MAVEN_VER=${MAVEN_VER} .

build-maven-21: build-kotlin-21
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg MAVEN_VER=${MAVEN_VER} .


# SBT recipes
build-sbt: build-sbt-8 build-sbt-11 build-sbt-17 build-sbt-21

build-sbt-8: build-scala-8
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg SBT_VER=${SBT_VER} .

build-sbt-11: build-scala-11
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg SBT_VER=${SBT_VER} .

build-sbt-17: build-scala-17
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg SBT_VER=${SBT_VER} .

build-sbt-21: build-scala-21
   time docker image build -f Dockerfile.ubuntu-sbt -t ${PREFIX}ubuntu-sbt:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg SBT_VER=${SBT_VER} .


# Blazegraph recipes
build-blazegraph: build-blazegraph-8 build-blazegraph-release

build-blazegraph-8: build-maven-8
   time docker image build -f Dockerfile.ubuntu-blazegraph -t ${PREFIX}ubuntu-blazegraph:latest --build-arg PREFIX=${PREFIX} --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_DISTRO_VERSION} .

build-blazegraph-release: build-maven-8
   time docker image build -f Dockerfile.ubuntu-blazegraph -t ${PREFIX}ubuntu-blazegraph:${BLAZEGRAPH_RELEASE_DISTRO_VERSION} --build-arg PREFIX=${PREFIX} --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_RELEASE_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_RELEASE_DISTRO_VERSION} .

list-blazegraph-upstream-master-commit-id:
   git ls-remote https://github.com/blazegraph/database heads/master

list-blazegraph-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/blazegraph/database/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Apache Cassandra recipes
build-cassandra: build-cassandra-trunk build-cassandra-release-4_1

build-cassandra-trunk: build-ant-17
   time docker image build -f Dockerfile.ubuntu-cassandra -t ${PREFIX}ubuntu-cassandra:latest --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=${CASSANDRA_TRUNK_PARENT_TAG} --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_TRUNK_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_TRUNK_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_TRUNK_DISTRO_VERSION} .

build-cassandra-release-4_1: build-ant-11
   time docker image build -f Dockerfile.ubuntu-cassandra -t ${PREFIX}ubuntu-cassandra:${CASSANDRA_RELEASE_4_1_DISTRO_VERSION} --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=${CASSANDRA_RELEASE_4_1_PARENT_TAG} --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_RELEASE_4_1_DISTRO_VERSION} .

list-cassandra-upstream-trunk-commit-id:
   git ls-remote https://github.com/apache/cassandra heads/trunk

list-cassandra-upstream-main-build-version:
   curl -Ls https://raw.githubusercontent.com/apache/cassandra/trunk/build.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath 'string(/project/property[@name="base.version"]/@value)' -


# Apache Jena recipes
build-jena: build-jena-main-17 build-jena-main-21
# temporarily removed "build-jena-release-4_10" dependency since 4.10 release build fails

build-jena-main-17: build-maven-17
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} .

build-jena-main-21: build-maven-21
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} .

build-jena-release-4_10: build-maven-17
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:${JENA_RELEASE_4_10_DISTRO_VERSION} --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=${JENA_RELEASE_4_10_PARENT_TAG} --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_4_10_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_4_10_DISTRO_VERSION} .

list-jena-upstream-main-commit-id:
   git ls-remote https://github.com/apache/jena heads/main

list-jena-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/jena/main/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Spark recipes
build-spark: build-spark-master-17 build-spark-master-21 build-spark-release-3_5

build-spark-master-17: build-maven-17
   time docker image build -f Dockerfile.ubuntu-spark -t ${PREFIX}ubuntu-spark:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .

build-spark-master-21: build-maven-21
   time docker image build -f Dockerfile.ubuntu-spark -t ${PREFIX}ubuntu-spark:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .

build-spark-release-3_5: build-maven-17
   time docker image build -f Dockerfile.ubuntu-spark -t ${PREFIX}ubuntu-spark:${SPARK_RELEASE_3_5_DISTRO_VERSION} --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=${SPARK_RELEASE_3_5_PARENT_TAG} --build-arg SPARK_GIT_COMMIT_ID=${SPARK_RELEASE_3_5_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_RELEASE_3_5_DISTRO_VERSION} .

list-spark-upstream-master-commit-id:
   git ls-remote https://github.com/apache/spark heads/master

list-spark-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/spark/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Widoco recipes
build-widoco: build-widoco-main-17 build-widoco-main-21

build-widoco-main-17: build-maven-17
   time docker image build -f Dockerfile.ubuntu-widoco -t ${PREFIX}ubuntu-widoco:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .

build-widoco-main-21: build-maven-21
   time docker image build -f Dockerfile.ubuntu-widoco -t ${PREFIX}ubuntu-widoco:21 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=21 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .

list-widoco-upstream-master-commit-id:
   git ls-remote https://github.com/dgarijo/Widoco heads/master

list-widoco-upstream-maaster-pom-version:
   curl -Ls https://raw.githubusercontent.com/dgarijo/Widoco/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -

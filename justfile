#!/usr/bin/env just --justfile

repo := env_var_or_default('DEFAULT_REPO', 'ghcr.io/luminositylabs')
tag_prefix := env_var_or_default('TAG_PREFIX','llsem-')
prefix := repo + "/" + tag_prefix

do_push := env_var_or_default('PUSH', 'false')
post_push_sleep_seconds := env_var_or_default('POST_PUSH_SLEEP_SECONDS', '0')
do_platform_amd64 := env_var_or_default('PLATFORM_AMD64', 'true')
do_platform_arm64 := env_var_or_default('PLATFORM_ARM64', 'true')
use_cache := env_var_or_default('USE_CACHE', 'true')

export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','noble-20250404')
export JAVA_VER_DISTRO_8 := env_var_or_default('JAVA_VER_DISTRO_8','8.0.442-zulu')
export JAVA_VER_DISTRO_11 := env_var_or_default('JAVA_VER_DISTRO_11','11.0.26-zulu')
export JAVA_VER_DISTRO_17 := env_var_or_default('JAVA_VER_DISTRO_17','17.0.14-zulu')
export JAVA_VER_DISTRO_21 := env_var_or_default('JAVA_VER_DISTRO_21','21.0.6-zulu')
export JAVA_VER_DISTRO_24 := env_var_or_default('JAVA_VER_DISTRO_24','24-zulu')
export JBANG_VER := env_var_or_default('JBANG_VER', '0.125.1')
export KOTLIN_VER := env_var_or_default('KOTLIN_VER','2.1.20')
export SCALA_VER := env_var_or_default('SCALA_VER','3.6.4')
export ANT_VER := env_var_or_default('ANT_VER','1.10.14')
export GRADLE_VER := env_var_or_default('GRADLE_VER','8.13')
export MAVEN_VER := env_var_or_default('MAVEN_VER','3.9.9')
export SBT_VER := env_var_or_default('SBT_VER','1.10.11')
export BLAZEGRAPH_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_GIT_COMMIT_ID','829ce824')
export BLAZEGRAPH_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_DISTRO_VERSION','2.1.6-SNAPSHOT')
export BLAZEGRAPH_RELEASE_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_RELEASE_GIT_COMMIT_ID','BLAZEGRAPH_RELEASE_2_1_5')
export BLAZEGRAPH_RELEASE_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_RELEASE_DISTRO_VERSION','2.1.5')
export CASSANDRA_TRUNK_PARENT_TAG := env_var_or_default('CASSANDRA_TRUNK_PARENT_TAG','17')
export CASSANDRA_TRUNK_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_TRUNK_JAVA_MAJOR_VERSION','17')
export CASSANDRA_TRUNK_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_TRUNK_GIT_COMMIT_ID','cc63d3cd')
export CASSANDRA_TRUNK_DISTRO_VERSION := env_var_or_default('CASSANDRA_TRUNK_DISTRO_VERSION','5.1-SNAPSHOT')
export CASSANDRA_RELEASE_5_0_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_RELEASE_5_0_JAVA_MAJOR_VERSION','17')
export CASSANDRA_RELEASE_5_0_PARENT_TAG := env_var_or_default('CASSANDRA_RELEASE_5_0_PARENT_TAG','17')
export CASSANDRA_RELEASE_5_0_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_RELEASE_5_0_GIT_COMMIT_ID','cassandra-5.0.3')
export CASSANDRA_RELEASE_5_0_DISTRO_VERSION := env_var_or_default('CASSANDRA_RELEASE_5_0_DISTRO_VERSION','5.0.3')
export CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION','11')
export CASSANDRA_RELEASE_4_1_PARENT_TAG := env_var_or_default('CASSANDRA_RELEASE_4_1_PARENT_TAG','11')
export CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID','cassandra-4.1.7')
export CASSANDRA_RELEASE_4_1_DISTRO_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_DISTRO_VERSION','4.1.7')
export JENA_MAIN_GIT_COMMIT_ID := env_var_or_default('JENA_MAIN_GIT_COMMIT_ID','71a9279f')
export JENA_MAIN_DISTRO_VERSION := env_var_or_default('JENA_MAIN_DISTRO_VERSION','5.4.0-SNAPSHOT')
export JENA_RELEASE_5_3_PARENT_TAG := env_var_or_default('JENA_RELEASE_5_3_PARENT_TAG','17')
export JENA_RELEASE_5_3_GIT_COMMIT_ID := env_var_or_default('JENA_RELEASE_5_3_GIT_COMMIT_ID','jena-5.3.0')
export JENA_RELEASE_5_3_DISTRO_VERSION := env_var_or_default('JENA_RELEASE_3_2_DISTRO_VERSION','5.3.0')
export SPARK_MASTER_GIT_COMMIT_ID := env_var_or_default('SPARK_MASTER_GIT_COMMIT_ID','7c12ff62')
export SPARK_MASTER_DISTRO_VERSION := env_var_or_default('SPARK_MASTER_DISTRO_VERSION','4.1.0-SNAPSHOT')
export SPARK_RELEASE_3_5_PARENT_TAG := env_var_or_default('SPARK_RELEASE_3_5_PARENT_TAG','17')
export SPARK_RELEASE_3_5_GIT_COMMIT_ID := env_var_or_default('SPARK_RELEASE_3_5_GIT_COMMIT_ID','v3.5.4')
export SPARK_RELEASE_3_5_DISTRO_VERSION := env_var_or_default('SPARK_RELEASE_3_5_DISTRO_VERSION','3.5.4')
export WIDOCO_MAIN_GIT_COMMIT_ID := env_var_or_default('WIDOCO_MAIN_GIT_COMMIT_ID','5d9b0e77')
export WIDOCO_MAIN_DISTRO_VERSION := env_var_or_default('WIDOCO_MAIN_DISTRO_VERSION','1.4.26')


default:
  @echo "Invoke just --list to see a list of possible recipes to run"

all: build-ubuntu build-zulu build-kotlin build-scala build-ant build-gradle build-maven build-sbt build-blazegraph build-cassandra build-jena build-spark build-widoco


# Ubuntu recipes
build-ubuntu:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu:latest
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   if [[ "{{use_cache}}" == "false" ]]; then CACHE=" --no-cache "; fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        ${CACHE} \
                        --pull \
                        --progress plain \
                        --build-arg PARENT_TAG=${UBUNTU_TAG} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

list-dockerhub-ubuntu-tags:
   curl -Ls 'https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?page_size=1024'| jq '."results"[]["name"]' | grep noble


# OpenJDK Zulu recipes
build-zulu: build-zulu-8 build-zulu-11 build-zulu-17 build-zulu-21 build-zulu-24

build-zulu-8: build-ubuntu
   just _build-zulu-V 8

build-zulu-11: build-ubuntu
   just _build-zulu-V 11

build-zulu-17: build-ubuntu
   just _build-zulu-V 17

build-zulu-21: build-ubuntu
   just _build-zulu-V 21

build-zulu-24: build-ubuntu
   just _build-zulu-V 24

_build-zulu-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-zulu:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-zulu -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG=latest \
                        --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_{{V}}} \
                        --build-arg JBANG_VER=${JBANG_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Kotlin recipes
build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17 build-kotlin-21 build-kotlin-24

build-kotlin-8: build-zulu-8
   just _build-kotlin-V 8

build-kotlin-11: build-zulu-11
   just _build-kotlin-V 11

build-kotlin-17: build-zulu-17
   just _build-kotlin-V 17

build-kotlin-21: build-zulu-21
   just _build-kotlin-V 21

build-kotlin-24: build-zulu-24
   just _build-kotlin-V 24

_build-kotlin-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-kotlin:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-kotlin -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}}\
                        --build-arg KOTLIN_VER=${KOTLIN_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Scala recipes
build-scala: build-scala-8 build-scala-11 build-scala-17 build-scala-21 build-scala-24

build-scala-8: build-zulu-8
   just _build-scala-V 8

build-scala-11: build-zulu-11
   just _build-scala-V 11

build-scala-17: build-zulu-17
   just _build-scala-V 17

build-scala-21: build-zulu-21
   just _build-scala-V 21

build-scala-24: build-zulu-24
   just _build-scala-V 24

_build-scala-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-scala:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-scala -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}} \
                        --build-arg SCALA_VER=${SCALA_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Apache Ant recipes
build-ant: build-ant-8 build-ant-11 build-ant-17 build-ant-21 build-ant-24

build-ant-8: build-kotlin-8
   just _build-ant-V 8

build-ant-11: build-kotlin-11
   just _build-ant-V 11

build-ant-17: build-kotlin-17
   just _build-ant-V 17

build-ant-21: build-kotlin-21
   just _build-ant-V 21

build-ant-24: build-kotlin-24
   just _build-ant-V 24

_build-ant-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-ant:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-ant -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}} \
                        --build-arg ANT_VER=${ANT_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Gradle recipes
build-gradle: build-gradle-8 build-gradle-11 build-gradle-17 build-gradle-21 build-gradle-24

build-gradle-8: build-kotlin-8
   just _build-gradle-V 8

build-gradle-11: build-kotlin-11
   just _build-gradle-V 11

build-gradle-17: build-kotlin-17
   just _build-gradle-V 17

build-gradle-21: build-kotlin-21
   just _build-gradle-V 21

build-gradle-24: build-kotlin-24
   just _build-gradle-V 24

_build-gradle-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-gradle:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-gradle -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}} \
                        --build-arg GRADLE_VER=${GRADLE_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Apache Maven recipes
build-maven: build-maven-8 build-maven-11 build-maven-17 build-maven-21 build-maven-24

build-maven-8: build-kotlin-8
   just _build-maven-V 8

build-maven-11: build-kotlin-11
   just _build-maven-V 11

build-maven-17: build-kotlin-17
   just _build-maven-V 17

build-maven-21: build-kotlin-21
   just _build-maven-V 21

build-maven-24: build-kotlin-24
   just _build-maven-V 24

_build-maven-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-maven:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-maven -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}} \
                        --build-arg MAVEN_VER=${MAVEN_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# SBT recipes
build-sbt: build-sbt-8 build-sbt-11 build-sbt-17 build-sbt-21 build-sbt-24

build-sbt-8: build-scala-8
   just _build-sbt-V 8

build-sbt-11: build-scala-11
   just _build-sbt-V 11

build-sbt-17: build-scala-17
   just _build-sbt-V 17

build-sbt-21: build-scala-21
   just _build-sbt-V 21

build-sbt-24: build-scala-24
   just _build-sbt-V 24

_build-sbt-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-sbt:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker build -f Dockerfile.ubuntu-sbt -t ${IMGTAG} \
                        --platform "${PLATFORMS}" \
                        --progress plain \
                        --build-arg PREFIX={{prefix}} \
                        --build-arg PARENT_TAG={{V}} \
                        --build-arg SBT_VER=${SBT_VER} \
                        .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}


# Blazegraph recipes
build-blazegraph: build-blazegraph-8 build-blazegraph-release

build-blazegraph-8: build-maven-8
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-blazegraph:latest
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=8 \
                              --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_GIT_COMMIT_ID} \
                              --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_DISTRO_VERSION} \
                              .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

build-blazegraph-release: build-maven-8
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-blazegraph:${BLAZEGRAPH_RELEASE_DISTRO_VERSION}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=8 \
                              --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_RELEASE_GIT_COMMIT_ID} \
                              --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_RELEASE_DISTRO_VERSION} \
                              .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

list-blazegraph-upstream-master-commit-id:
   git ls-remote https://github.com/blazegraph/database heads/master

list-blazegraph-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/blazegraph/database/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Apache Cassandra recipes
build-cassandra: build-cassandra-trunk build-cassandra-release-4_1 build-cassandra-release-5_0

build-cassandra-trunk: build-ant-17
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-cassandra:latest
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-cassandra -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=${CASSANDRA_TRUNK_PARENT_TAG} \
                              --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_TRUNK_JAVA_MAJOR_VERSION} \
                              --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_TRUNK_GIT_COMMIT_ID} \
                              --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_TRUNK_DISTRO_VERSION} \
                              .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

build-cassandra-release-4_1: build-ant-11
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-cassandra:${CASSANDRA_RELEASE_4_1_DISTRO_VERSION}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-cassandra -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=${CASSANDRA_RELEASE_4_1_PARENT_TAG} \
                              --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION} \
                              --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID} \
                              --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_RELEASE_4_1_DISTRO_VERSION} \
                              .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

build-cassandra-release-5_0: build-ant-17
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-cassandra:${CASSANDRA_RELEASE_5_0_DISTRO_VERSION}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-cassandra -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=${CASSANDRA_RELEASE_5_0_PARENT_TAG} \
                              --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_RELEASE_5_0_JAVA_MAJOR_VERSION} \
                              --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_RELEASE_5_0_GIT_COMMIT_ID} \
                              --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_RELEASE_5_0_DISTRO_VERSION} \
                              .
   fi
   just _push_image ${IMGTAG} {{post_push_sleep_seconds}}

list-cassandra-upstream-trunk-commit-id:
   git ls-remote https://github.com/apache/cassandra heads/trunk

list-cassandra-upstream-main-build-version:
   curl -Ls https://raw.githubusercontent.com/apache/cassandra/trunk/build.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath 'string(/project/property[@name="base.version"]/@value)' -


# Apache Jena recipes
build-jena: build-jena-main-17 build-jena-main-21 build-jena-release-5_3

build-jena-main-17: build-maven-17
   just _build-jena-main-V 17

build-jena-main-21: build-maven-21
   just _build-jena-main-V 21

build-jena-release-5_3: build-maven-17
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-jena:${JENA_RELEASE_5_3_DISTRO_VERSION}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-jena -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=${JENA_RELEASE_5_3_PARENT_TAG} \
                              --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_5_3_GIT_COMMIT_ID} \
                              --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_5_3_DISTRO_VERSION} \
                              .
   fi
   just _push_image "${IMGTAG}" {{post_push_sleep_seconds}}

_build-jena-main-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-jena:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-jena -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG={{V}} \
                              --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} \
                              --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} \
                              .
   fi
   just _push_image "${IMGTAG}" {{post_push_sleep_seconds}}

list-jena-luminositylabs-main-commit-id:
   git ls-remote https://github.com/luminositylabs/apache-jena heads/main

list-jena-luminositylabs-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/luminositylabs/apache-jena/main/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -

list-jena-upstream-main-commit-id:
   git ls-remote https://github.com/apache/jena heads/main

list-jena-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/jena/main/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Spark recipes
build-spark: build-spark-master-17 build-spark-master-21 build-spark-release-3_5

build-spark-master-17: build-maven-17
   just _build-spark-master-V 17

build-spark-master-21: build-maven-21
   just _build-spark-master-V 21

build-spark-release-3_5: build-maven-17
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-spark:${SPARK_RELEASE_3_5_DISTRO_VERSION}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-spark -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG=${SPARK_RELEASE_3_5_PARENT_TAG} \
                              --build-arg SPARK_GIT_COMMIT_ID=${SPARK_RELEASE_3_5_GIT_COMMIT_ID} \
                              --build-arg SPARK_DISTRO_VERSION=${SPARK_RELEASE_3_5_DISTRO_VERSION} \
                              .
   fi
   just _push_image "${IMGTAG}" {{post_push_sleep_seconds}}

_build-spark-master-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-spark:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-spark -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG={{V}} \
                              --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} \
                              --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} \
                              .
   fi
   just _push_image "${IMGTAG}" {{post_push_sleep_seconds}}

list-spark-upstream-master-commit-id:
   git ls-remote https://github.com/apache/spark heads/master

list-spark-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/spark/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Widoco recipes
build-widoco: build-widoco-main-17 build-widoco-main-21

build-widoco-main-17: build-maven-17
   just _build-widoco-main-V 17

build-widoco-main-21: build-maven-21
   just _build-widoco-main-V 21

_build-widoco-main-V V:
   #!/usr/bin/env bash
   IMGTAG={{prefix}}ubuntu-widoco:{{V}}
   if [[ "{{do_platform_amd64}}" == "true" ]]; then _PLATFORMS+=("linux/amd64"); fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then _PLATFORMS+=("linux/arm64"); fi
   for I in ${!_PLATFORMS[@]}; do
      if [[ ${I} -gt 0 ]]; then PLATFORMS="${PLATFORMS},"; fi
      PLATFORMS="${PLATFORMS}${_PLATFORMS[$I]}"
   done
   if [[ "${PLATFORMS}" != "" ]]; then
      time docker image build -f Dockerfile.ubuntu-widoco -t ${IMGTAG} \
                              --platform "${PLATFORMS}" \
                              --progress plain \
                              --build-arg PREFIX={{prefix}} \
                              --build-arg PARENT_TAG={{V}} \
                              --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} \
                              --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} \
                              .
   fi
   just _push_image "${IMGTAG}" {{post_push_sleep_seconds}}

list-widoco-upstream-master-commit-id:
   git ls-remote https://github.com/dgarijo/Widoco heads/master

list-widoco-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/dgarijo/Widoco/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


_push_image image_name post_push_wait_seconds:
   #!/usr/bin/env bash
   if [[ "{{do_push}}" == "true" ]]; then
      docker image push {{image_name}}
      sleep {{post_push_wait_seconds}}
   fi

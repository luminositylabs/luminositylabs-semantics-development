#!/usr/bin/env just --justfile

repo := env_var_or_default('DEFAULT_REPO', 'ghcr.io/luminositylabs')
tag_prefix := env_var_or_default('TAG_PREFIX','llsem-')
prefix := repo + "/" + tag_prefix

do_push := env_var_or_default('PUSH', 'false')
do_platform_amd64 := env_var_or_default('PLATFORM_AMD64', 'true')
do_platform_arm64 := env_var_or_default('PLATFORM_ARM64', 'true')

export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','noble-20240429')
export JAVA_VER_DISTRO_8 := env_var_or_default('JAVA_VER_DISTRO_8','8.0.412-zulu')
export JAVA_VER_DISTRO_11 := env_var_or_default('JAVA_VER_DISTRO_11','11.0.23-zulu')
export JAVA_VER_DISTRO_17 := env_var_or_default('JAVA_VER_DISTRO_17','17.0.11-zulu')
export JAVA_VER_DISTRO_21 := env_var_or_default('JAVA_VER_DISTRO_21','21.0.3-zulu')
export KOTLIN_VER := env_var_or_default('KOTLIN_VER','1.9.24')
export KSCRIPT_VER := env_var_or_default('KSCRIPT_VER','4.2.3')
export SCALA_VER := env_var_or_default('SCALA_VER','3.4.1')
export ANT_VER := env_var_or_default('ANT_VER','1.10.13')
export GRADLE_VER := env_var_or_default('GRADLE_VER','8.7')
export MAVEN_VER := env_var_or_default('MAVEN_VER','3.9.6')
export SBT_VER := env_var_or_default('SBT_VER','1.10.0')
export BLAZEGRAPH_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_GIT_COMMIT_ID','829ce824')
export BLAZEGRAPH_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_DISTRO_VERSION','2.1.6-SNAPSHOT')
export BLAZEGRAPH_RELEASE_GIT_COMMIT_ID := env_var_or_default('BLAZEGRAPH_RELEASE_GIT_COMMIT_ID','BLAZEGRAPH_RELEASE_2_1_5')
export BLAZEGRAPH_RELEASE_DISTRO_VERSION := env_var_or_default('BLAZEGRAPH_RELEASE_DISTRO_VERSION','2.1.5')
export CASSANDRA_TRUNK_PARENT_TAG := env_var_or_default('CASSANDRA_TRUNK_PARENT_TAG','17')
export CASSANDRA_TRUNK_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_TRUNK_JAVA_MAJOR_VERSION','17')
export CASSANDRA_TRUNK_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_TRUNK_GIT_COMMIT_ID','6bae4f76')
export CASSANDRA_TRUNK_DISTRO_VERSION := env_var_or_default('CASSANDRA_TRUNK_DISTRO_VERSION','5.1-SNAPSHOT')
export CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION','11')
export CASSANDRA_RELEASE_4_1_PARENT_TAG := env_var_or_default('CASSANDRA_RELEASE_4_1_PARENT_TAG','11')
export CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID := env_var_or_default('CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID','cassandra-4.1.4')
export CASSANDRA_RELEASE_4_1_DISTRO_VERSION := env_var_or_default('CASSANDRA_RELEASE_4_1_DISTRO_VERSION','4.1.4')
export JENA_MAIN_GIT_COMMIT_ID := env_var_or_default('JENA_MAIN_GIT_COMMIT_ID','fb7f4fad')
export JENA_MAIN_DISTRO_VERSION := env_var_or_default('JENA_MAIN_DISTRO_VERSION','5.1.0-SNAPSHOT')
export JENA_RELEASE_4_10_PARENT_TAG := env_var_or_default('JENA_RELEASE_4_10_PARENT_TAG','17')
export JENA_RELEASE_4_10_GIT_COMMIT_ID := env_var_or_default('JENA_RELEASE_4_10_GIT_COMMIT_ID','jena-4.10.0')
export JENA_RELEASE_4_10_DISTRO_VERSION := env_var_or_default('JENA_RELEASE_4_10_DISTRO_VERSION','4.10.0')
export JENA_RELEASE_5_0_PARENT_TAG := env_var_or_default('JENA_RELEASE_5_0_PARENT_TAG','17')
export JENA_RELEASE_5_0_GIT_COMMIT_ID := env_var_or_default('JENA_RELEASE_5_0_GIT_COMMIT_ID','jena-5.0.0-ll')
export JENA_RELEASE_5_0_DISTRO_VERSION := env_var_or_default('JENA_RELEASE_5_0_DISTRO_VERSION','5.0.0')
export SPARK_MASTER_GIT_COMMIT_ID := env_var_or_default('SPARK_MASTER_GIT_COMMIT_ID','57b20777')
export SPARK_MASTER_DISTRO_VERSION := env_var_or_default('SPARK_MASTER_DISTRO_VERSION','4.0.0-SNAPSHOT')
export SPARK_RELEASE_3_5_PARENT_TAG := env_var_or_default('SPARK_RELEASE_3_5_PARENT_TAG','17')
export SPARK_RELEASE_3_5_GIT_COMMIT_ID := env_var_or_default('SPARK_MASTER_GIT_COMMIT_ID','v3.5.1')
export SPARK_RELEASE_3_5_DISTRO_VERSION := env_var_or_default('SPARK_MASTER_DISTRO_VERSION','3.5.1')
export WIDOCO_MAIN_GIT_COMMIT_ID := env_var_or_default('WIDOCO_MAIN_GIT_COMMIT_ID','e6a9f23e')
export WIDOCO_MAIN_DISTRO_VERSION := env_var_or_default('WIDOCO_MAIN_DISTRO_VERSION','1.4.24')


default:
  @echo "Invoke just --list to see a list of possible recipes to run"

all: build-ubuntu build-zulu build-kotlin build-scala build-ant build-gradle build-maven build-sbt build-blazegraph build-cassandra build-jena build-spark build-widoco


# Ubuntu recipes
build-ubuntu:
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu:latest
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 --pull -f Dockerfile.ubuntu -t ${IMGTAG}_linux-amd64 --build-arg PARENT_TAG=${UBUNTU_TAG} .
      if [[ "{{do_push}}" == "true" ]]; then
        docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 --pull -f Dockerfile.ubuntu -t ${IMGTAG}_linux-arm64 --build-arg PARENT_TAG=${UBUNTU_TAG} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

list-dockerhub-ubuntu-tags:
   curl -Ls 'https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?page_size=1024'| jq '."results"[]["name"]' | grep noble


# OpenJDK Zulu recipes
build-zulu: build-zulu-8 build-zulu-11 build-zulu-17 build-zulu-21

build-zulu-8: build-ubuntu
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-zulu:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-amd64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_8}  .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-arm64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_8}  .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-zulu-11: build-ubuntu
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-zulu:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-amd64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_11} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-arm64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_11} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-zulu-17: build-ubuntu
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-zulu:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-amd64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_17} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-arm64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_17} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-zulu-21: build-ubuntu
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-zulu:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-amd64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_21} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-zulu -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=latest_linux-arm64 --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_21} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Kotlin recipes
build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17 build-kotlin-21

build-kotlin-8: build-zulu-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-kotlin:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-kotlin-11: build-zulu-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-kotlin:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-kotlin-17: build-zulu-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-kotlin:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-kotlin-21: build-zulu-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-kotlin:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-kotlin -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Scala recipes
build-scala: build-scala-8 build-scala-11 build-scala-17 build-scala-21

build-scala-8: build-zulu-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-scala:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-scala-11: build-zulu-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-scala:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-scala-17: build-zulu-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-scala:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-scala-21: build-zulu-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-scala:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-scala -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg SCALA_VER=${SCALA_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Apache Ant recipes
build-ant: build-ant-8 build-ant-11 build-ant-17 build-ant-21

build-ant-8: build-kotlin-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-ant:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-ant-11: build-kotlin-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-ant:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-ant-17: build-kotlin-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-ant:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-ant-21: build-kotlin-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-ant:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-ant -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg ANT_VER=${ANT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Gradle recipes
build-gradle: build-gradle-8 build-gradle-11 build-gradle-17 build-gradle-21

build-gradle-8: build-kotlin-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-gradle:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-gradle-11: build-kotlin-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-gradle:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-gradle-17: build-kotlin-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-gradle:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-gradle-21: build-kotlin-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-gradle:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-gradle -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg GRADLE_VER=${GRADLE_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Apache Maven recipes
build-maven: build-maven-8 build-maven-11 build-maven-17 build-maven-21

build-maven-8: build-kotlin-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-maven:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-maven-11: build-kotlin-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-maven:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-maven-17: build-kotlin-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-maven:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-maven-21: build-kotlin-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-maven:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-maven -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg MAVEN_VER=${MAVEN_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# SBT recipes
build-sbt: build-sbt-8 build-sbt-11 build-sbt-17 build-sbt-21

build-sbt-8: build-scala-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-sbt:8
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-sbt-11: build-scala-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-sbt:11
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-amd64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=11_linux-arm64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
          docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-sbt-17: build-scala-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-sbt:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-sbt-21: build-scala-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-sbt:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-sbt -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg SBT_VER=${SBT_VER} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi


# Blazegraph recipes
build-blazegraph: build-blazegraph-8 build-blazegraph-release

build-blazegraph-8: build-maven-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-blazegraph:latest
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-blazegraph-release: build-maven-8
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-blazegraph:${BLAZEGRAPH_RELEASE_DISTRO_VERSION}
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-amd64 --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_RELEASE_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_RELEASE_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-blazegraph -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=8_linux-arm64 --build-arg BLAZEGRAPH_GIT_COMMIT_ID=${BLAZEGRAPH_RELEASE_GIT_COMMIT_ID} --build-arg BLAZEGRAPH_DISTRO_VERSION=${BLAZEGRAPH_RELEASE_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

list-blazegraph-upstream-master-commit-id:
   git ls-remote https://github.com/blazegraph/database heads/master

list-blazegraph-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/blazegraph/database/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Apache Cassandra recipes
build-cassandra: build-cassandra-trunk build-cassandra-release-4_1

build-cassandra-trunk: build-ant-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-cassandra:latest
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-cassandra -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${CASSANDRA_TRUNK_PARENT_TAG}_linux-amd64 --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_TRUNK_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_TRUNK_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_TRUNK_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-cassandra -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${CASSANDRA_TRUNK_PARENT_TAG}_linux-arm64 --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_TRUNK_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_TRUNK_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_TRUNK_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-cassandra-release-4_1: build-ant-11
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-cassandra:${CASSANDRA_RELEASE_4_1_DISTRO_VERSION}
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-cassandra -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${CASSANDRA_RELEASE_4_1_PARENT_TAG}_linux-amd64 --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_RELEASE_4_1_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-cassandra -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${CASSANDRA_RELEASE_4_1_PARENT_TAG}_linux-arm64 --build-arg JAVA_MAJOR_VERSION=${CASSANDRA_RELEASE_4_1_JAVA_MAJOR_VERSION} --build-arg CASSANDRA_GIT_COMMIT_ID=${CASSANDRA_RELEASE_4_1_GIT_COMMIT_ID} --build-arg CASSANDRA_DISTRO_VERSION=${CASSANDRA_RELEASE_4_1_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

list-cassandra-upstream-trunk-commit-id:
   git ls-remote https://github.com/apache/cassandra heads/trunk

list-cassandra-upstream-main-build-version:
   curl -Ls https://raw.githubusercontent.com/apache/cassandra/trunk/build.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath 'string(/project/property[@name="base.version"]/@value)' -


# Apache Jena recipes
build-jena: build-jena-main-17 build-jena-main-21 build-jena-release-4_10 build-jena-release-5_0

build-jena-main-17: build-maven-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-jena:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-jena -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-jena -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-jena-main-21: build-maven-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-jena:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-jena -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-jena -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg JENA_GIT_COMMIT_ID=${JENA_MAIN_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_MAIN_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-jena-release-4_10: build-maven-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-jena:${JENA_RELEASE_4_10_DISTRO_VERSION}
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-jena -t  ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${JENA_RELEASE_4_10_PARENT_TAG}_linux-amd64 --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_4_10_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_4_10_DISTRO_VERSION} --build-arg SKIP_JAVADOCS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-jena -t  ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${JENA_RELEASE_4_10_PARENT_TAG}_linux-arm64 --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_4_10_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_4_10_DISTRO_VERSION} --build-arg SKIP_JAVADOCS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi

build-jena-release-5_0: build-maven-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-jena:${JENA_RELEASE_5_0_DISTRO_VERSION}
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-jena -t  ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${JENA_RELEASE_5_0_PARENT_TAG}_linux-amd64 --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_5_0_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_5_0_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-jena -t  ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${JENA_RELEASE_5_0_PARENT_TAG}_linux-arm64 --build-arg JENA_GIT_COMMIT_ID=${JENA_RELEASE_5_0_GIT_COMMIT_ID} --build-arg JENA_DISTRO_VERSION=${JENA_RELEASE_5_0_DISTRO_VERSION} --build-arg SKIP_FUSEKI_UI_E2E_TESTS=true .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi

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
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-spark:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-spark-master-21: build-maven-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-spark:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_MASTER_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_MASTER_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-spark-release-3_5: build-maven-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-spark:${SPARK_RELEASE_3_5_DISTRO_VERSION}
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${SPARK_RELEASE_3_5_PARENT_TAG}_linux-amd64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_RELEASE_3_5_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_RELEASE_3_5_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-spark -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=${SPARK_RELEASE_3_5_PARENT_TAG}_linux-arm64 --build-arg SPARK_GIT_COMMIT_ID=${SPARK_RELEASE_3_5_GIT_COMMIT_ID} --build-arg SPARK_DISTRO_VERSION=${SPARK_RELEASE_3_5_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

list-spark-upstream-master-commit-id:
   git ls-remote https://github.com/apache/spark heads/master

list-spark-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/spark/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -


# Widoco recipes
build-widoco: build-widoco-main-17 build-widoco-main-21

build-widoco-main-17: build-maven-17
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-widoco:17
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-widoco -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-amd64 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-widoco -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=17_linux-arm64 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

build-widoco-main-21: build-maven-21
   #!/usr/bin/env bash
   if [[ "{{do_platform_amd64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-amd64"; fi
   if [[ "{{do_platform_arm64}}" == "true" ]]; then MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS} linux-arm64"; fi
   MANIFEST_PLATFORMS="${MANIFEST_PLATFORMS## }"
   IMGTAG={{prefix}}ubuntu-widoco:21
   if [ "{{do_platform_amd64}}" == "true" ]; then
      time docker image build --platform linux/amd64 -f Dockerfile.ubuntu-widoco -t ${IMGTAG}_linux-amd64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-amd64 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-amd64
      fi
   fi
   if [ "{{do_platform_arm64}}" == "true" ]; then
      time docker image build --platform linux/arm64 -f Dockerfile.ubuntu-widoco -t ${IMGTAG}_linux-arm64 --build-arg PREFIX={{prefix}} --build-arg PARENT_TAG=21_linux-arm64 --build-arg WIDOCO_GIT_COMMIT_ID=${WIDOCO_MAIN_GIT_COMMIT_ID} --build-arg WIDOCO_DISTRO_VERSION=${WIDOCO_MAIN_DISTRO_VERSION} .
      if [[ "{{do_push}}" == "true" ]]; then
         docker push ${IMGTAG}_linux-arm64
      fi
   fi
   if [[ "{{do_push}}" == "true" ]]; then
      just _manifest "${IMGTAG}" "${MANIFEST_PLATFORMS}"
   fi

list-widoco-upstream-master-commit-id:
   git ls-remote https://github.com/dgarijo/Widoco heads/master

list-widoco-upstream-master-pom-version:
   curl -Ls https://raw.githubusercontent.com/dgarijo/Widoco/master/pom.xml | sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -



_manifest manifest_name platform_images:
  #!/usr/bin/env bash
  printf "Creating manifest with name [%s] from platform tags [%s]\n" "{{manifest_name}}" "{{platform_images}}"
  PARAMS="{{manifest_name}}"
  for P in {{platform_images}}; do
    PARAMS="${PARAMS} {{manifest_name}}_${P}"
  done
  docker manifest rm {{manifest_name}}
  docker manifest create -a ${PARAMS}
  docker manifest push {{manifest_name}}

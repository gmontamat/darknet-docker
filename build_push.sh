#!/bin/bash

for var in cpu cpu-noopt cpu-cv cpu-noopt-cv cpu-lib cpu-noopt-lib cpu-cv-lib cpu-noopt-cv-lib
do
  DOCKER_REPO="gmontamat/darknet"
  SOURCE_BRANCH="master"
  SOURCE_COMMIT=`git ls-remote https://github.com/AlexeyAB/darknet.git ${SOURCE_BRANCH} | awk '{ print $1 }'`
  DOCKER_TAG=$var
  VAR=$var

  echo $DOCKER_REPO
  echo $SOURCE_BRANCH
  echo $SOURCE_COMMIT
  echo $DOCKER_TAG
  echo $VAR

if [[ "$DOCKER_TAG" == *cv* ]]; then
  if [[ "$DOCKER_TAG" = *cpu-cv* || "$DOCKER_TAG" = *cpu-noopt-cv* ]]; then
    echo "building cpu-cv or cpu-noopt-cv"
    docker build \
      --build-arg CONFIG=$VAR \
      --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
      --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
      -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu-cv .
  else
    echo "building gpu-cv"
    docker build \
      --build-arg CONFIG=$VAR \
      --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
      --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
      -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu-cv .
  fi
 else
  if [[ "$DOCKER_TAG" = *cpu* || "$DOCKER_TAG" = *cpu-noopt* ]]; then
    echo "building cpu or cpu-noopt"
    docker build \
      --build-arg CONFIG=$VAR \
      --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
      --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
      -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.cpu .
  else
    echo "building gpu"
    docker build \
      --build-arg CONFIG=$VAR \
      --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
      --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
      -t $DOCKER_REPO:$DOCKER_TAG -f Dockerfile.gpu .
  fi
fi

docker push $DOCKER_REPO:$DOCKER_TAG
done


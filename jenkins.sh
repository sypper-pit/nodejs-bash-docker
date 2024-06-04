#!/bin/bash

CONTAINER_NAME="nodejs_container"
HOST_PORT=3080
CONTAINER_PORT=3000
SOURCE_DIRECTORY="/www/wwwroot/workspace/mysite.com"
TARGET_DIRECTORY="/app"
VERSION_NODEJS="latest"

# Function to stop and remove the container
stop_and_remove_container() {
  echo "Stopping container..."
  docker stop $CONTAINER_NAME
  echo "Removing container..."
  docker rm $CONTAINER_NAME
}

# Function to copy files and compile the application
copy_files_and_compile() {
  echo "Copying files to container..."
  docker cp $SOURCE_DIRECTORY/. $CONTAINER_NAME:$TARGET_DIRECTORY
  echo "Clearing yarn cache and reinstalling dependencies..."
  docker exec $CONTAINER_NAME yarn cache clean
  docker exec $CONTAINER_NAME rm -rf $TARGET_DIRECTORY/node_modules
  docker exec $CONTAINER_NAME yarn install --immutable --immutable-cache --check-cache --cwd $TARGET_DIRECTORY
  echo "Building the application..."
  docker exec $CONTAINER_NAME yarn build --cwd $TARGET_DIRECTORY
  echo "Starting the application..."
  docker exec $CONTAINER_NAME yarn start --cwd $TARGET_DIRECTORY
}

# Function to start the container
start_container() {
  echo "Starting container..."
  docker run -d \
    --name $CONTAINER_NAME \
    -p $HOST_PORT:$CONTAINER_PORT \
    -v $SOURCE_DIRECTORY:$TARGET_DIRECTORY \
    --restart always \
    node:$VERSION_NODEJS \
    sh -c "cd $TARGET_DIRECTORY && yarn install --immutable --immutable-cache --check-cache && yarn build && yarn start"
}

# Check if the container exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  stop_and_remove_container
fi

# Create and start the container if it doesn't exist
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
  echo "Creating and starting container..."
  docker run -d \
    --name $CONTAINER_NAME \
    -p $HOST_PORT:$CONTAINER_PORT \
    -v $SOURCE_DIRECTORY:$TARGET_DIRECTORY \
    --restart always \
    node:$VERSION_NODEJS \
    sh -c "cd $TARGET_DIRECTORY && yarn install --immutable --immutable-cache --check-cache && yarn build && yarn start"
else
  copy_files_and_compile
fi

# Check logs if container is in restarting state
if [ "$(docker inspect -f '{{.State.Restarting}}' $CONTAINER_NAME)" == "true" ]; then
  echo "Container is restarting. Showing logs..."
  docker logs $CONTAINER_NAME
fi









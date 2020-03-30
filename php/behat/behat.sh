#!/bin/bash

CONTAINER_ID="wishlistservice_wishlistservice_1"

if [[ $CONTAINER_ID != "" ]] ; then
    CONTAINER_IS_RUNNING=$(docker inspect -f {{.State.Running}} $CONTAINER_ID)

    if [[ $CONTAINER_IS_RUNNING != true ]] ; then
        echo "container is not running!"
        exit 1
    fi
else
    echo "container is not started!"
    exit 1
fi

docker exec -i $(docker ps -qf "name=wishlistservice_wishlistservice") ./vendor/bin/behat $@
exit $?
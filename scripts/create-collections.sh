#!/bin/bash

bucketName=$1
echo "About to create scopes and collections in bucket $bucketName..."
if [ -e "/startup/$bucketName/collections.json" ]; then
  echo "Creating scopes and collections in $bucketName..."

  # Create the scopes and collections
  while read scopeName
  do
    echo "Scope: $scopeName"
    # Check to see if the scope name provided is the default scope. If not, create the scope
    if [ $scopeName != "_default" ]; then
      echo "Creating scope: $scopeName..."
      curl -Ss -X POST -u "$CB_USERNAME:$CB_PASSWORD" http://localhost:8091/pools/default/buckets/$bucketName/collections -d name=$scopeName && echo
    fi

    # Create the collections within the appropriate scope
    while read collectionName
    do
      echo "Creating collection: $collectionName..."
      curl -Ss -X POST -u "$CB_USERNAME:$CB_PASSWORD" http://localhost:8091/pools/default/buckets/$bucketName/collections/$scopeName -d name=$collectionName && echo
    done < <(cat /startup/$bucketName/collections.json | jq -r ".scopes.$scopeName | .collections | .[]")
  done < <(cat /startup/$bucketName/collections.json | jq -r '.scopes | keys[]')

  # Sleep for a few seconds before moving on to give Couchbase time
  # to make sure the scopes and collections exist
  sleep 5
fi

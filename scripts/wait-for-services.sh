#!/bin/bash

maxAttempts=10

if [[ $CB_SERVICES == *"n1ql"* ]]; then
  i=0
  # Wait for the query service to be up and running
  for attempt in {1..maxAttempts}
  do
    curl -s http://127.0.0.1:8093/admin/ping > /dev/null \
      && break

    echo "Waiting for query service..."
    sleep 1
    ((i++))
  done

  if [[ $i == maxAttempts ]]; then
    echo "Max attempts reached trying to wait for query service..."
  fi

  # We're seeing sporadic issues with "Operation not supported" creating indexes
  # As painful as it is, an extra sleep is called for to make sure N1QL is fully up and running
  sleep 5
fi

if [[ $CB_SERVICES == *"fts"* ]]; then
  i=0
  # Wait for the FTS service to be up and running
  for attempt in {1..maxAttempts}
  do
    curl -s -u $CB_USERNAME:$CB_PASSWORD http://127.0.0.1:8094/api/index > /dev/null \
      && break

    echo "Waiting for FTS service..."
    sleep 1
    ((i++))
  done

  if [[ $i == maxAttempts ]]; then
    echo "Max attempts reached trying to wait for FTS service..."
  fi
fi

if [[ $CB_SERVICES == *"cbas"* ]]; then
  i=0
  # Wait for the analytics service to be up and running
  for attempt in {1..maxAttempts}
  do
    curl -s -u $CB_USERNAME:$CB_PASSWORD http://localhost:8095/analytics/config/service > /dev/null \
      && break

    echo "Waiting for analytics service..."
    sleep 1
    ((i++))
  done

  if [[ $i == maxAttempts ]]; then
    echo "Max attempts reached trying to wait for analytics service..."
  fi
fi

if [[ $CB_SERVICES == *"eventing"* ]]; then
  i=0
  # Wait for the eventing service to be up and running
  for attempt in {1..maxAttempts}
  do
    curl -s -u $CB_USERNAME:$CB_PASSWORD http://127.0.0.1:8096/api/v1/functions > /dev/null \
      && break

    echo "Waiting for eventing service..."
    sleep 1
    ((i++))
  done

  if [[ $i == maxAttempts ]]; then
    echo "Max attempts reached trying to wait for eventing service..."
  fi
fi

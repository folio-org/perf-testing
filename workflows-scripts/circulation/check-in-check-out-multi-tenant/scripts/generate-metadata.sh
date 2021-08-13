#!/bin/bash -x
export OKAPITOKEN=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsInVzZXJfaWQiOiI4MjEzODdhZS1hNzkxLTQ5NTgtYTg3ZS1jYTFmMDE2NzA2YmUiLCJpYXQiOjE2Mjg3Nzg4OTYsInRlbmFudCI6ImZzMDAwMDEwMzcifQ.XtKGgkbpmvkzAy5tEk5xvXynBGGTtclxyJRlPPmiIHc
export OKAPITENANT=fs00001037
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/instance-statuses' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "52a2ff34-2a12-420d-8539-21aa8d3cf5d8",
    "code" : "batch",
    "name" : "Batch Loaded",
    "source" : "folio"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/statistical-code-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "3abd6fc2-b3e4-4879-b1e1-78be41769fe3",
    "name" : "ARL (Collection stats)",
    "source" : "folio"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/material-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "1aa8050a-619b-40c6-9b9b-81a2aa9c0912",
    "name" : "electronic resource",
    "source" : "UC"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/instance-statuses' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "52a2ff34-2a12-420d-8539-21aa8d3cf5d8",
    "code" : "batch",
    "name" : "Batch Loaded",
    "source" : "folio"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/statistical-code-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "99cef68e-31ef-40d3-a3d1-f02c4f18b6c9",
    "name" : "University of Chicago",
    "source" : "UC"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/statistical-codes' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "58ca58aa-a2f6-4329-a14d-fbaa57f90cc1",
    "code" : "ebooks",
    "name" : "Books, electronic (ebooks)",
    "statisticalCodeTypeId" : "99cef68e-31ef-40d3-a3d1-f02c4f18b6c9",
    "source" : "UC"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/holdings-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "373ae405-37b3-4ff5-98c6-e9842d2d6687",
    "name" : "electronic",
    "source" : "UC"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/call-number-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "c73c17f4-9660-421b-bdfc-e1c6093dec13",
    "name" : "Library of Congress classification",
    "source" : "local"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/item-note-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "2864ca78-7d78-4a90-8ff6-13a4e30128b4",
    "name" : "Note",
    "source" : "folio"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/holdings-note-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "97fbb130-beb4-4eec-84a6-c69768ca3eea",
    "name" : "Note",
    "source" : "folio"
}'
curl --location --request POST 'https://okapi-cap-planning.int.aws.folio.org/loan-types' \
--header 'Content-Type: application/json' \
--header "x-okapi-tenant: ${OKAPITENANT}" \
--header "x-okapi-token: ${OKAPITOKEN}" \
--data-raw '{
    "id" : "2b94c631-fca9-4892-a730-03ee529ffe27",
    "name" : "Can circulate"
}'

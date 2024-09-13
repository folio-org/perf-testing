To migrate or update a large number of MARC Authority records, the process is divided into two main parts: data mapping and data saving. Below is a detailed description of each step involved in the full migration process:

### 1. Initiate Migration Operation

To start the migration process, you need to create a new migration operation using a POST request.

#### **Request**
- **Endpoint:** `POST /marc-migrations`
- **Request Body:**
  ```json
  {
      "entityType": "authority",
      "operationType": "remapping"
  }
  ```

#### **Response**
- **Status Code:** 201 Created
- **Response Body:** Contains:
  - `id`: The unique identifier for the migration operation.
  - `status`: Indicates the operation status, which will be "new".
  - `totalNumOfRecords`: The total number of MARC Authority records to be migrated.

### 2. Track Data Mapping Job

Once the migration operation is initiated, you need to track the status of the data mapping job using a GET request.

#### **Request**
- **Endpoint:** `GET /marc-migrations/{operationId}`
- **Parameters:** Replace `{operationId}` with the ID received from the initial POST request.

#### **Response**
- **Status Codes:**
  - **In Progress:** The status will show `data_mapping` indicating that the data mapping job is still in progress.
  - **Completed Successfully:** The status will be `data_mapping_completed` with `mappedNumOfRecords` equal to `totalNumOfRecords`.
  - **Failed:** The status will be `data_mapping_failed` if the job did not complete successfully.

- **Response Fields:**
  - `startTimeMapping`: Timestamp when the data mapping started.
  - `endTimeMapping`: Timestamp when the data mapping completed.

  The time taken to complete data mapping can be calculated by subtracting `startTimeMapping` from `endTimeMapping`.

### 3. Initiate Data Saving Step

Once the data mapping has completed successfully, you can proceed to the data saving step.

#### **Request**
- **Endpoint:** `PUT /marc-migrations/{operationId}`
- **Request Body:**
  ```json
  {
      "status": "data_saving"
  }
  ```

#### **Response**
- **Status Code:** 204 No Content
- This indicates that a new asynchronous job for data saving has been submitted.

### 4. Track Data Saving Job

You need to track the status of the data saving job using the same GET request endpoint.

#### **Request**
- **Endpoint:** `GET /marc-migrations/{operationId}`
- **Parameters:** Replace `{operationId}` with the ID received earlier.

#### **Response**
- **Status Codes:**
  - **In Progress:** The status will show `data_saving` indicating that the data saving job is still in progress.
  - **Completed Successfully:** The status will be `data_saving_completed` with `savedNumOfRecords` equal to `totalNumOfRecords`.
  - **Failed:** The status will be `data_saving_failed` if the job did not complete successfully.

- **Response Fields:**
  - `startTimeSaving`: Timestamp when the data saving started.
  - `endTimeSaving`: Timestamp when the data saving completed.

  The time taken to complete data saving can be calculated by subtracting `startTimeSaving` from `endTimeSaving`.

### Check Migration Operation from database
 - select end_time_mapping - start_time_mapping as mapping_duration,end_time_saving - start_time_saving as saving_duration,* from {tenant}_mod_marc_migrations.operation order by start_time_mapping desc

### Summary

1. **Initiate Migration Operation:** `POST /marc-migrations`
2. **Track Data Mapping:** `GET /marc-migrations/{operationId}`
3. **Initiate Data Saving:** `PUT /marc-migrations/{operationId}`
4. **Track Data Saving:** `GET /marc-migrations/{operationId}`

Ensure to handle the asynchronous nature of these operations and monitor the status to confirm successful completion.
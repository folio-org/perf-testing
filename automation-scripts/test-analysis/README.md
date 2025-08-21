# 🧠 ECS Service Detection via FastAPI (CPU Spikes + Memory Leaks)

This guide explains how to use Postman to call two detection models via FastAPI:

- ✅ CPU Spike Detection (`/detect-tests`)
- ✅ Memory Leak Detection (`/detect-memory-leaks`)

---

## ⚙️ Prerequisites

- FastAPI backend is running (locally or deployed)
- AWS credentials configured
- ECS Cluster name, AWS account name, and UTC ISO timeframe

---

## 1️⃣ CPU Spike Detection API

**Endpoint:**
 GET /detect-tests

 
**Example URL:**
http://localhost:8000/detect-tests?cluster=my-ecs-cluster&start=2025-08-01T00:00:00Z&end=2025-08-01T06:00:00Z&account=my-aws-account

**Query Parameters:**

| Name     | Required | Example                      |
|----------|----------|------------------------------|
| cluster  | ✅ yes   | my-ecs-cluster               |
| start    | ✅ yes   | 2025-08-01T00:00:00Z         |
| end      | ✅ yes   | 2025-08-01T06:00:00Z         |
| account  | ✅ yes   | my-aws-account               |

**Response Example:**
```json
[
  {
    "test_window": {
      "start": "2025-08-01T02:00:00Z",
      "end": "2025-08-01T02:55:00Z"
    },
    "active_services": [
      "orders-service",
      "auth-service"
    ]
  }
]

Next Endpoint:

GET /detect-memory-leaks

Example URL:

http://localhost:8000/detect-memory-leaks?cluster=my-ecs-cluster&start=2025-08-01T00:00:00Z&end=2025-08-01T06:00:00Z&account=my-aws-account


**Query Parameters:**

| Name     | Required | Example                      |
|----------|----------|------------------------------|
| cluster  | ✅ yes   | my-ecs-cluster               |
| start    | ✅ yes   | 2025-08-01T00:00:00Z         |
| end      | ✅ yes   | 2025-08-01T06:00:00Z         |
| account  | ✅ yes   | my-aws-account               |


**Response Example:**
```json
[
  {
    "service_name": "reporting-engine",
    "max_memory": 87.2,
    "slope": 0.29,
    "r2_score": 0.91,
    "has_gc_dips": false,
    "leak_reason": "Consistent increase without garbage collection dips"
  }
]




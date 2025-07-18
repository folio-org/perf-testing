import boto3
import pandas as pd
from aws_utils import get_all_service_names, get_cpu_data_for_service
from model_utils import detect_test_windows

# === USER INPUT ===
START_TIME = input("Enter start time (ISO format, e.g., 2025-06-05T13:00:00Z): ")
END_TIME = input("Enter end time (ISO format, e.g., 2025-06-05T14:00:00Z): ")
CLUSTER_NAME = input("Enter the ECS cluster name (e.g., secon-pvt): ")
ACCOUNT_NAME = input("Enter AWS account name for logging: ")
REGION = 'us-east-1'
PERIOD = 300  # 5-minute interval

# AWS Client
session = boto3.Session()
cloudwatch = session.client('cloudwatch', region_name=REGION)

# Step 1: Get all services for this cluster
services = get_all_service_names(CLUSTER_NAME, REGION)
print(f"[{ACCOUNT_NAME}] Found {len(services)} services in cluster '{CLUSTER_NAME}'")

# Step 2: Get CPU data per service
valid_services = {}

for service in services:
    print(f"Fetching CPU data for: {service}")
    data = get_cpu_data_for_service(cloudwatch, CLUSTER_NAME, service, START_TIME, END_TIME, PERIOD)
    if data is not None and not data.empty:
        valid_services[service] = data
    else:
        print(f"No data found for service '{service}' (may not be running)")

# Step 3: Build CPU DataFrame
if not valid_services:
    print(f" No running services found in cluster '{CLUSTER_NAME}' during this period.")
    exit(1)

cpu_df = pd.DataFrame(valid_services)

# Step 4: Run ML model to detect test windows
tests = detect_test_windows(cpu_df)
# Display all services in full, no truncation
pd.set_option('display.max_colwidth', None)

print("\n Detected test windows:\n")
for i, row in tests.iterrows():
    print(f"Test {i + 1}:")
    print(f"  Start:    {row['start']}")
    print(f"  End:      {row['end']}")
    print(f"  Services: {', '.join(row['services'])}\n")



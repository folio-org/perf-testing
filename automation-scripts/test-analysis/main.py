from fastapi import FastAPI, Request  # Import FastAPI framework and Request object
from fastapi.middleware.cors import CORSMiddleware  # Middleware to handle CORS
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse  # Response types
from fastapi.templating import Jinja2Templates  # For HTML templating with Jinja2
from fastapi.staticfiles import StaticFiles  # To serve static files
from pydantic import BaseModel  # For request body validation
import boto3  # AWS SDK for Python
import pandas as pd  # Data analysis library
from aws_utils import get_all_service_names, get_cpu_data_for_service  # Custom functions to get ECS and CloudWatch data
from model_utils import detect_test_windows  # ML model for detecting test windows
from datetime import datetime  # For datetime operations

# Create FastAPI application
app = FastAPI()

# Enable CORS so frontend (even from another domain) can access the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins; change to a list of domains in production
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Set up template and static directories
templates = Jinja2Templates(directory="templates")  # Folder containing HTML templates
app.mount("/static", StaticFiles(directory="static"), name="static")  # Mount static file path

# Route: Home page
@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})  # Render index.html with request context

# Define request model using Pydantic
class TestRequest(BaseModel):
    start_time: str  # Start of the time window (ISO format)
    end_time: str  # End of the time window (ISO format)
    cluster_name: str  # ECS cluster name
    account_name: str  # AWS account identifier

# Route: Detect test windows and active services
@app.post("/detect-tests")
def detect_services(request_data: TestRequest):
    # Extract values from the request JSON
    start_time = request_data.start_time
    end_time = request_data.end_time
    cluster_name = request_data.cluster_name
    account_name = request_data.account_name

    region = 'us-east-1'  # AWS region
    period = 300  # CloudWatch datapoint resolution in seconds (5 mins)

    # Create CloudWatch client
    session = boto3.Session()
    cloudwatch = session.client('cloudwatch', region_name=region)

    # Get all ECS services for the cluster
    services = get_all_service_names(cluster_name, region)
    valid_services = {}  # Dict to hold valid CPU data per service

    # Get CPU data for each service
    for service in services:
        data = get_cpu_data_for_service(cloudwatch, cluster_name, service, start_time, end_time, period)
        if data is not None and not data.empty:
            valid_services[service] = data

    # Return error if no service had valid data
    if not valid_services:
        return JSONResponse(content={"error": "No valid service data found."}, status_code=404)

    # Combine all CPU data into a single DataFrame
    cpu_df = pd.DataFrame(valid_services)

    # Run test detection ML model
    test_results = detect_test_windows(cpu_df)

    # Return results as JSON
    return JSONResponse(content={
        "account": account_name,
        "cluster": cluster_name,
        "start_time": start_time,
        "end_time": end_time,
        "test_windows": test_results.to_dict(orient="records")
    })

# Route: Export raw CPU data (no model applied)
@app.get("/export-raw-data")
def export_raw_data(start_time: str, end_time: str, cluster_name: str):
    region = 'us-east-1'
    period = 300

    session = boto3.Session()
    cloudwatch = session.client('cloudwatch', region_name=region)

    services = get_all_service_names(cluster_name, region)
    raw_data = {}
    for service in services:
        data = get_cpu_data_for_service(cloudwatch, cluster_name, service, start_time, end_time, period)
        if data is not None and not data.empty:
            raw_data[service] = data

    if not raw_data:
        return JSONResponse(content={"error": "No data found for export."}, status_code=404)

    df = pd.DataFrame(raw_data)
    csv_data = df.to_csv()

    return HTMLResponse(content=csv_data, media_type="text/csv")

# Route: Placeholder for dashboard updates
@app.post("/update-dashboard")
def update_dashboard():
    return JSONResponse(content={"message": "Dashboard updated (placeholder)"})

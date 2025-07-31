from fastapi import FastAPI, Request, Query, HTTPException  # Import FastAPI framework and Request object
from fastapi.middleware.cors import CORSMiddleware  # Middleware to handle CORS
from fastapi.responses import HTMLResponse, JSONResponse, FileResponse  # Response types
from fastapi.templating import Jinja2Templates  # For HTML templating with Jinja2
from fastapi.staticfiles import StaticFiles  # To serve static files
from pydantic import BaseModel  # For request body validation
import os # For output 
import json # For output type
import zipfile # For outputting json data as a zipfile
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
# @app.get("/", response_class=HTMLResponse)
# def index(request: Request):
#    return templates.TemplateResponse("index.html", {"request": request})  # Render index.html with request context

# Define request model using Pydantic
class TestRequest(BaseModel):
    start_time: str  # Start of the time window (ISO format)
    end_time: str  # End of the time window (ISO format)
    cluster_name: str  # ECS cluster name
    account_name: str  # AWS account identifier

@app.get("/detect-tests")
def detect_services(
    start_time: str = Query(...),
    end_time: str = Query(...),
    cluster_name: str = Query(...)
):
    account_name = "default-user"
    region = 'us-east-1'
    period = 300  # 5‑minute granularity
    session = boto3.Session()
    cloudwatch = session.client('cloudwatch', region_name=region)

    services = get_all_service_names(cluster_name, region)
    valid_services = {}
    for service in services:
        data = get_cpu_data_for_service(cloudwatch, cluster_name, service, start_time, end_time, period)
        if data is not None and not data.empty:
            valid_services[service] = data

    if not valid_services:
        return JSONResponse({"error": "No valid service data found."}, status_code=404)

    cpu_df = pd.DataFrame(valid_services)
    test_results = detect_test_windows(cpu_df)

    # Convert Timestamps to strings
    def serialize_timestamps(record):
        for key in record:
            if isinstance(record[key], pd.Timestamp):
                record[key] = record[key].isoformat()
        return record

    serialized = [serialize_timestamps(rec) for rec in test_results.to_dict(orient="records")]

    return JSONResponse({
        "account": account_name,
        "cluster": cluster_name,
        "start_time": start_time,
        "end_time": end_time,
        "test_windows": serialized
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


@app.get("/export-tests-zip")
def export_tests_zip(
    start_time: str = Query(..., description="Start time in ISO format (e.g., 2025-07-28T17:00:00Z)"),
    end_time: str = Query(..., description="End time in ISO format (e.g., 2025-07-28T18:40:00Z)"),
    cluster_name: str = Query(..., description="Name of the ECS cluster")
):
    try:
        from aws_utils import get_all_service_names, get_cpu_data_for_service
        from model_utils import detect_test_windows

        region = 'us-east-1'
        period = 300

        # Convert to datetime objects
        start_dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
        end_dt = datetime.fromisoformat(end_time.replace("Z", "+00:00"))

        # Create CloudWatch client
        session = boto3.Session()
        cloudwatch = session.client('cloudwatch', region_name=region)

        # Collect all services and CPU data
        services = get_all_service_names(cluster_name, region)
        valid_services = {}
        for service in services:
            df = get_cpu_data_for_service(cloudwatch, cluster_name, service, start_time, end_time, period)
            if df is not None and not df.empty:
                valid_services[service] = df

        if not valid_services:
            raise HTTPException(status_code=404, detail="No valid CPU data found.")

        # Run the Model
        cpu_df = pd.DataFrame(valid_services)
        cpu_df.sort_index(inplace=True)
        test_results = detect_test_windows(cpu_df)
        if test_results is None or test_results.empty:
            raise HTTPException(status_code=404, detail="No test windows detected.")

        # Save to JSON
        output_dir = "temp_exports"
        os.makedirs(output_dir, exist_ok=True)
        json_path = os.path.join(output_dir, "test_results.json")

        def serialize_datetime(obj):
            if isinstance(obj, datetime):
                return obj.isoformat()
            raise TypeError(f"Type {type(obj)} not serializable")

        with open(json_path, "w") as f:
            json.dump(test_results.to_dict(orient="records"), f, indent=2, default=serialize_datetime)

        # Create a ZIP archive
        zip_path = os.path.join(output_dir, "test_results.zip")
        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
            zipf.write(json_path, arcname="test_results.json")

        return FileResponse(zip_path, filename="test_results.zip", media_type="application/zip")


    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Route: Placeholder for dashboard updates
@app.post("/update-dashboard")
def update_dashboard():
    return JSONResponse(content={"message": "Dashboard updated (placeholder)"})

from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import boto3
import pandas as pd
from aws_utils import get_all_service_names, get_cpu_data_for_service
from model_utils import detect_test_windows
from datetime import datetime

app = FastAPI()

# Enable CORS so the frontend can talk to this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can restrict this to specific domains later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/detect-tests")
def detect_services(
    request: Request,
    start_time: str = Form(...),
    end_time: str = Form(...),
    cluster_name: str = Form(...),
    account_name: str = Form(...),
):
    region = 'us-east-1'
    period = 300
    session = boto3.Session()
    cloudwatch = session.client('cloudwatch', region_name=region)

    services = get_all_service_names(cluster_name, region)
    valid_services = {}

    for service in services:
        data = get_cpu_data_for_service(cloudwatch, cluster_name, service, start_time, end_time, period)
        if data is not None and not data.empty:
            valid_services[service] = data

    if not valid_services:
        return templates.TemplateResponse("index.html", {"request": request, "error": "No valid service data found."})

    cpu_df = pd.DataFrame(valid_services)
    test_results = detect_test_windows(cpu_df)

    return templates.TemplateResponse("index.html", {
        "request": request,
        "results": test_results.to_dict(orient="records")
    })

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

    df = pd.DataFrame(raw_data)
    csv_data = df.to_csv()
    return HTMLResponse(content=csv_data, media_type="text/csv")

@app.post("/update-dashboard")
def update_dashboard():
    # Placeholder
    return JSONResponse(content={"message": "Dashboard updated (placeholder)"})

@app.get("/", response_class=FileResponse)
def serve_ui():
    return "dashboard.html"


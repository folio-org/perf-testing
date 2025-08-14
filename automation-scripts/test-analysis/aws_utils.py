import boto3  # AWS SDK for Python
import logging
from typing import List, Optional
import pandas as pd

# Configure module-level logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

"""
aws_utils.py

Utility functions for interacting with AWS ECS and CloudWatch services.
Provides methods to list ECS services within a cluster and to fetch
CPU utilization metrics for individual services over a specified time range.
"""


def get_all_service_names(cluster_name: str, region: str = 'us-east-1') -> List[str]:
    """
    Retrieve all ECS service names in the given cluster by paginating through
    list_services and then describing services in batches.

    Args:
        cluster_name (str): Name of the ECS cluster.
        region (str): AWS region where the cluster resides. Defaults to 'us-east-1'.

    Returns:
        List[str]: A list of service names; empty if no services found.
    """
    ecs_client = boto3.client('ecs', region_name=region)
    service_arns: List[str] = []
    next_token: Optional[str] = None

    # Paginate through list_services to collect all ARNs
    while True:
        if next_token:
            response = ecs_client.list_services(cluster=cluster_name, nextToken=next_token)
        else:
            response = ecs_client.list_services(cluster=cluster_name)

        service_arns.extend(response.get('serviceArns', []))
        next_token = response.get('nextToken')
        if not next_token:
            break

    # If no services found, return empty list
    if not service_arns:
        logger.info(f"No services found in cluster '{cluster_name}'.")
        return []

    # Describe services in batches of up to 10 (API limit)
    service_names: List[str] = []
    for i in range(0, len(service_arns), 10):
        batch = service_arns[i:i + 10]
        describe_response = ecs_client.describe_services(cluster=cluster_name, services=batch)
        # Extract the serviceName field from each described service
        service_names.extend([s['serviceName'] for s in describe_response.get('services', [])])

    logger.info(f"Retrieved {len(service_names)} service names from cluster '{cluster_name}'.")
    return service_names


def get_cpu_data_for_service(
    cloudwatch_client,
    cluster_name: str,
    service_name: str,
    start_time,
    end_time,
    period: int = 300
) -> Optional[pd.Series]:
    """
    Fetch CPU utilization statistics for a given ECS service from CloudWatch.

    Args:
        cloudwatch_client: boto3 CloudWatch client instance.
        cluster_name (str): Name of the ECS cluster.
        service_name (str): Name of the ECS service.
        start_time (datetime): Start time for the metric query.
        end_time (datetime): End time for the metric query.
        period (int): Granularity of the datapoints in seconds. Defaults to 300s.

    Returns:
        pd.Series: Time-indexed series of CPU utilization averages, or None if no data.
    """
    try:
        response = cloudwatch_client.get_metric_statistics(
            Namespace='AWS/ECS',
            MetricName='CPUUtilization',
            Dimensions=[
                {'Name': 'ClusterName', 'Value': cluster_name},
                {'Name': 'ServiceName', 'Value': service_name}
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=period,
            Statistics=['Average'],
            Unit='Percent'
        )

        datapoints = response.get('Datapoints', [])
        if not datapoints:
            logger.warning(f"No CPU datapoints found for service '{service_name}' between {start_time} and {end_time}.")
            return None

        # Sort datapoints by timestamp and convert to pandas Series
        sorted_data = sorted(datapoints, key=lambda x: x['Timestamp'])
        time_index = [point['Timestamp'] for point in sorted_data]
        values = [point['Average'] for point in sorted_data]

        series = pd.Series(data=values, index=time_index, name=service_name)
        logger.info(f"Fetched {len(series)} CPU datapoints for service '{service_name}'.")
        return series

    except Exception as e:
        # Log the exception details for debugging
        logger.error(f"Failed to retrieve CPU data for service '{service_name}': {e}", exc_info=True)
        return None

def get_memory_data_for_service(
    cloudwatch_client,
    cluster_name: str,
    service_name: str,
    start_time,
    end_time,
    period: int = 300
) -> Optional[pd.Series]:
    """
    Fetch Memory utilization statistics for a given ECS service from CloudWatch.

    Args:
        cloudwatch_client: boto3 CloudWatch client instance.
        cluster_name (str): Name of the ECS cluster.
        service_name (str): Name of the ECS service.
        start_time (datetime): Start time for the metric query.
        end_time (datetime): End time for the metric query.
        period (int): Granularity of the datapoints in seconds. Defaults to 300s.

    Returns:
        pd.Series: Time-indexed series of Memory utilization averages, or None if no data.
    """
    try:
        response = cloudwatch_client.get_metric_statistics(
            Namespace='AWS/ECS',
            MetricName='MemoryUtilization',
            Dimensions=[
                {'Name': 'ClusterName', 'Value': cluster_name},
                {'Name': 'ServiceName', 'Value': service_name}
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=period,
            Statistics=['Average'],
            Unit='Percent'
        )

        datapoints = response.get('Datapoints', [])
        if not datapoints:
            logger.warning(f"No Memory datapoints found for service '{service_name}' between {start_time} and {end_time}.")
            return None

        # Sort and format as pandas Series
        sorted_data = sorted(datapoints, key=lambda x: x['Timestamp'])
        time_index = [point['Timestamp'] for point in sorted_data]
        values = [point['Average'] for point in sorted_data]

        series = pd.Series(data=values, index=time_index, name=service_name)
        logger.info(f"Fetched {len(series)} Memory datapoints for service '{service_name}'.")
        return series

    except Exception as e:
        logger.error(f"Failed to retrieve Memory data for service '{service_name}': {e}", exc_info=True)
        return None


if __name__ == '__main__':
    # Example usage when running this module directly
    # Note: Replace 'my-cluster' and time range with real values
    from datetime import datetime, timedelta

    aws_region = 'us-east-1'
    cluster = 'my-cluster'
    cw = boto3.client('cloudwatch', region_name=aws_region)

    # Define a 1-hour window ending now
    end = datetime.utcnow()
    start = end - timedelta(hours=1)

    services = get_all_service_names(cluster, region=aws_region)
    for svc in services:
        series = get_cpu_data_for_service(cw, cluster, svc, start, end)
        if series is not None:
            print(series)

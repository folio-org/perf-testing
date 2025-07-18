import boto3
import pandas as pd  # ✅ Added import

def get_all_service_names(cluster_name, region='us-east-1'):
    ecs_client = boto3.client('ecs', region_name=region)
    service_arns = []
    next_token = None

    # Paginate through service ARNs
    while True:
        if next_token:
            response = ecs_client.list_services(cluster=cluster_name, nextToken=next_token)
        else:
            response = ecs_client.list_services(cluster=cluster_name)

        service_arns.extend(response['serviceArns'])

        if 'nextToken' not in response:
            break
        next_token = response['nextToken']

    if not service_arns:
        return []

    # Describe services in batches of 10
    service_names = []
    for i in range(0, len(service_arns), 10):
        batch = service_arns[i:i + 10]
        describe_response = ecs_client.describe_services(cluster=cluster_name, services=batch)
        service_names.extend([s['serviceName'] for s in describe_response['services']])

    return service_names


def get_cpu_data_for_service(cloudwatch_client, cluster_name, service_name, start_time, end_time, period=300):
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
            return None

        sorted_data = sorted(datapoints, key=lambda x: x['Timestamp'])
        time_series = pd.Series(
            [point['Average'] for point in sorted_data],
            index=[point['Timestamp'] for point in sorted_data]
        )
        return time_series

    except Exception as e:
        print(f"⚠️ Failed to retrieve CPU data for {service_name}: {e}")
        return None

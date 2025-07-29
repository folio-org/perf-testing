import logging
from typing import List, Dict, Any

import pandas as pd
import numpy as np
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

# Configure module-level logger for tracing and debugging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

"""
model_utils.py

Contains logic to detect test windows in a multi-service CPU utilization timeseries,
and to identify which services were active during those windows based on
an Isolation Forest anomaly detection and custom threshold rules.
"""

def detect_test_windows(
    cpu_df: pd.DataFrame,
    contamination: float = 0.03,
    cpu_threshold: float = 50.0,
    cooldown_threshold: float = 30.0,
    grace_period: int = 2,
    window_minutes: int = 90
) -> pd.DataFrame:
    """
    Identify test intervals based on CPU utilization anomalies across services,
    then determine which services are active in each interval according to
    custom threshold logic.

    Steps:
      1. Fill missing data, infer sampling frequency, and define sliding windows.
      2. For each window:
         a. Standardize CPU values per service.
         b. Fit IsolationForest to detect anomalies (spikes).
         c. Traverse timestamps, grouping contiguous anomalies (and hot points) into windows,
            applying a grace period and cooldown logic to close windows.
      3. Merge overlapping or adjacent windows.
      4. Apply Thresholds
      5. Adjust end time by subtracting 10 minutes (min length 1).

    Args:
        cpu_df (pd.DataFrame): Time-indexed CPU % for each service (columns).
        contamination (float): Fraction of expected anomalies for IsolationForest.
        cpu_threshold (float): Minimum CPU threshold to consider a spike (unused currently).
        cooldown_threshold (float): CPU % above which to extend an active window.
        grace_period (int): Number of consecutive non-hot intervals before closing window.
        window_minutes (int): Duration of each sliding window in minutes.

    Returns:
        pd.DataFrame: Each row has keys 'start', 'end', 'services' (sorted list).
    """
    # 1. Preprocess input DataFrame
    df = cpu_df.fillna(0).copy()
    df['Timestamp'] = df.index  # preserve timestamps for later use

    # Infer sampling frequency (e.g., '5min') and compute window size
    freq = pd.infer_freq(df.index[:3]) or '5min'
    step = pd.Timedelta(freq)
    window_size = pd.Timedelta(minutes=window_minutes)
    timestamps = df.index

    all_windows: List[tuple] = []
    start_idx = 0

    # 2. Slide through DataFrame in overlapping windows
    while start_idx < len(df):
        window_start_time = timestamps[start_idx]
        window_end_time = window_start_time + window_size
        window_df = (
            df[(df.index >= window_start_time) & (df.index < window_end_time)]
            .drop(columns=['Timestamp'])
        )

        # Stop if too few datapoints
        if len(window_df) < 5:
            break

        # a. Standardize features
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(window_df)

        # b. Fit anomaly detection model
        model = IsolationForest(
            n_estimators=100,
            contamination=contamination,
            random_state=42
        )
        labels = model.fit_predict(X_scaled)

        window_df = window_df.copy()
        window_df['Anomaly'] = labels
        window_df['Timestamp'] = window_df.index

        # Services to consider (exclude Anomaly & Timestamp)
        service_cols = [c for c in window_df.columns if c not in ('Anomaly', 'Timestamp')]

        # Initialize per-window variables
        active = False
        window_start = None
        cooldown_count = 0
        current_window_points: List[pd.Timestamp] = []

        # Traverse each timepoint in window
        for _, row in window_df.iterrows():
            is_anomaly = row['Anomaly'] == -1
            cpu_values = row[service_cols]
            # Determine if any service remains "hot"
            still_hot = (cpu_values > cooldown_threshold).any()

            if is_anomaly:
                # Start a new window or continue existing
                if not active:
                    window_start = row['Timestamp']
                    active = True
                    cooldown_count = 0
                    current_window_points = []
                current_window_points.append(row['Timestamp'])
                cooldown_count = 0
            elif active:
                if still_hot:
                    # Extend window if still hot
                    cooldown_count = 0
                    current_window_points.append(row['Timestamp'])
                else:
                    # Increment cooldown; if beyond grace, close window
                    cooldown_count += 1
                    if cooldown_count > grace_period:
                        all_windows.append((window_start, row['Timestamp']))
                        active = False
                        current_window_points = []
                        cooldown_count = 0

        # If a window remains open at end
        if active and current_window_points:
            all_windows.append((window_start, window_df['Timestamp'].iloc[-1]))

        # Move start index forward by half window length
        step_size = max(1, int((window_size // step) // 2))
        start_idx += step_size

    # 3. Merge overlapping or contiguous windows
    merged: List[tuple] = []
    for start, end in sorted(all_windows, key=lambda x: x[0]):
        if not merged:
            merged.append((start, end))
        else:
            last_start, last_end = merged[-1]
            # Merge if windows overlap or touch (within one freq step)
            if start <= last_end + pd.Timedelta(freq):
                merged[-1] = (last_start, max(last_end, end))
            else:
                merged.append((start, end))

    # 4. Determine active services in each merged window
    result: List[Dict[str, Any]] = []
    for start, end in merged:
        # Define pre-test and during-test intervals
        pre_start = start - pd.Timedelta(minutes=5)
        pre_df = cpu_df[(cpu_df.index >= pre_start) & (cpu_df.index < start)]
        during_df = cpu_df[(cpu_df.index >= start) & (cpu_df.index <= end)]

        active_services: List[str] = []
        for service in cpu_df.columns:
            # Skip if data missing
            if service not in pre_df.columns or service not in during_df.columns:
                continue

            pre_max = pre_df[service].max()
            if pre_max is None or np.isnan(pre_max) or pre_max == 0:
                continue

            rounded_pre = round(pre_max)
            during_max = during_df[service].max()

            # Apply custom threshold rules
            if rounded_pre <= 3:
                if during_max >= 15:
                    active_services.append(service)
            elif 7 <= rounded_pre <= 10:
                if during_max >= 20:
                    active_services.append(service)
            else:
                if during_max >= pre_max:
                    active_services.append(service)

        # Adjust end time back by 10 minutes, ensure minimum duration
        adjusted_end = end - pd.Timedelta(minutes=10)
        if adjusted_end <= start:
            adjusted_end = start + pd.Timedelta(minutes=1)

        result.append({
            'start': start,
            'end': adjusted_end,
            'services': sorted(active_services)
        })

    # Return structured DataFrame for downstream consumption
    return pd.DataFrame(result)

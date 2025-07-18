import pandas as pd
import numpy as np
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler

def detect_test_windows(cpu_df: pd.DataFrame, contamination=0.03, cpu_threshold=50.0,
                         cooldown_threshold=30.0, grace_period=2, window_minutes=90):
    df = cpu_df.fillna(0).copy()
    df['Timestamp'] = df.index

    freq = pd.infer_freq(df.index[:3]) or '5min'
    step = pd.Timedelta(freq)
    window_size = pd.Timedelta(minutes=window_minutes)
    timestamps = df.index

    all_windows = []
    start_idx = 0

    while start_idx < len(df):
        window_start_time = timestamps[start_idx]
        window_end_time = window_start_time + window_size
        window_df = df[(df.index >= window_start_time) & (df.index < window_end_time)].drop(columns=['Timestamp'])

        if len(window_df) < 5:
            break

        # Standardize
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(window_df)

        model = IsolationForest(n_estimators=100, contamination=contamination, random_state=42)
        labels = model.fit_predict(X_scaled)

        window_df = window_df.copy()
        window_df['Anomaly'] = labels
        window_df['Timestamp'] = window_df.index

        service_cols = window_df.columns.difference(['Anomaly', 'Timestamp'])

        active = False
        window_start = None
        cooldown_count = 0
        current_window_points = []

        for i, row in window_df.iterrows():
            is_anomaly = row['Anomaly'] == -1
            cpu_values = row[service_cols]
            still_hot = (cpu_values > cooldown_threshold).any()

            if is_anomaly:
                if not active:
                    window_start = row['Timestamp']
                    active = True
                    cooldown_count = 0
                    current_window_points = []
                current_window_points.append(row['Timestamp'])
                cooldown_count = 0
            elif active:
                if still_hot:
                    cooldown_count = 0
                    current_window_points.append(row['Timestamp'])
                else:
                    cooldown_count += 1
                    if cooldown_count > grace_period:
                        all_windows.append((window_start, row['Timestamp']))
                        active = False
                        current_window_points = []
                        cooldown_count = 0

        if active and current_window_points:
            all_windows.append((window_start, window_df['Timestamp'].iloc[-1]))

        start_idx += max(1, int((window_size // step) // 2))

    # Merge overlapping/adjacent windows
    merged = []
    for start, end in sorted(all_windows, key=lambda x: x[0]):
        if not merged:
            merged.append((start, end))
        else:
            last_start, last_end = merged[-1]
            if start <= last_end + pd.Timedelta(freq):
                merged[-1] = (last_start, max(last_end, end))
            else:
                merged.append((start, end))

    # === Determine active services per custom conditional logic ===
    result = []
    for start, end in merged:
        pre_start = start - pd.Timedelta(minutes=5)
        pre_df = cpu_df[(cpu_df.index >= pre_start) & (cpu_df.index < start)]
        during_df = cpu_df[(cpu_df.index >= start) & (cpu_df.index <= end)]

        active_services = []
        for service in cpu_df.columns:
            if service not in during_df.columns or service not in pre_df.columns:
                continue

            pre_max = pre_df[service].max()
            if pre_max == 0 or pd.isna(pre_max):
                continue

            rounded_pre = round(pre_max)
            during_max = during_df[service].max()

            # === Apply threshold logic ===
            if rounded_pre in [0, 1, 2, 3]:
                if during_max >= 12:
                    active_services.append(service)
            elif rounded_pre in [7, 8, 9, 10]:
                if during_max >= 20:
                    active_services.append(service)
            else:
                if during_max >= pre_max:
                    active_services.append(service)

        adjusted_end = end - pd.Timedelta(minutes=10)
        if adjusted_end <= start:
            adjusted_end = start + pd.Timedelta(minutes=1)

        result.append({
            'start': start,
            'end': adjusted_end,
            'services': sorted(active_services)
        })

    return pd.DataFrame(result)




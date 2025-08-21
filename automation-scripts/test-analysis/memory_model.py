import pandas as pd
import numpy as np
from typing import Dict, List
from sklearn.linear_model import LinearRegression

def detect_memory_leaks(
    memory_df: pd.DataFrame,
    slope_threshold: float = 0.01,
    r2_threshold: float = 0.85,
    min_duration_minutes: int = 30,
    crash_drop_threshold: float = 10.0,
    step_increase_threshold: float = 5.0,
    flat_threshold: float = 1.0,
    min_flat_duration: int = 3
) -> List[Dict]:
    """
    Detect memory leak patterns (Type A: steady increase, B: crash after rise, C: step-wise).
    Now returns start and end times of each detected pattern.
    """
    leak_results = []
    service_names = memory_df.columns
    min_points = (min_duration_minutes * 60) // 300  # assumes 5-min intervals

    for service in service_names:
        usage_series = memory_df[service].dropna()
        if len(usage_series) < min_points:
            continue

        timestamps = usage_series.index
        values = usage_series.values

        # Type A: Linear regression
        X = np.arange(len(values)).reshape(-1, 1)
        y = values.reshape(-1, 1)
        reg = LinearRegression().fit(X, y)
        slope = reg.coef_[0][0]
        r2 = reg.score(X, y)

        if slope > slope_threshold and r2 > r2_threshold:
            leak_results.append({
                "service_name": service,
                "leak_type": "A",
                "start_time": str(timestamps[0]),
                "end_time": str(timestamps[-1]),
                "leak_reason": "Significant steady increase (Type A)"
            })

        # Type B: Increase followed by sudden drop
        diffs = usage_series.diff().dropna()
        crash_indices = diffs[diffs < -crash_drop_threshold].index

        if not crash_indices.empty:
            crash_time = crash_indices[0]
            crash_pos = timestamps.get_loc(crash_time)
            leak_results.append({
                "service_name": service,
                "leak_type": "B",
                "start_time": str(timestamps[0]),
                "end_time": str(crash_time),
                "leak_reason": "Sudden drop after increase (Type B)"
            })

        # Type C: Step pattern detection (allow 1+ cycles)
        cycles = 0
        i = 0
        while i < len(values) - min_flat_duration - 1:
            start_val = values[i]
            for j in range(i + 1, len(values) - min_flat_duration):
                increase = values[j] - start_val
                if increase >= step_increase_threshold:
                    flat = all(
                        abs(values[k+1] - values[k]) <= flat_threshold
                        for k in range(j, j + min_flat_duration)
                        if k + 1 < len(values)
                    )
                    if flat:
                        cycles += 1
                        leak_results.append({
                            "service_name": service,
                            "leak_type": "C",
                            "start_time": str(timestamps[i]),
                            "end_time": str(timestamps[j + min_flat_duration - 1]),
                            "leak_reason": f"Step pattern with {cycles} stair-step cycle(s) (Type C)"
                        })
                        i = j + min_flat_duration
                        break
            else:
                i += 1

    return leak_results

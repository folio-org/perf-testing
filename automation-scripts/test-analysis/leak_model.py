import pandas as pd
import numpy as np
from typing import Dict, List
from sklearn.linear_model import LinearRegression

def detect_memory_leaks(
    memory_df: pd.DataFrame,
    slope_threshold: float = 0.1,
    r2_threshold: float = 0.85,
    min_duration_minutes: int = 30
) -> List[Dict]:
    """
    Detect services experiencing memory leaks using slope-based heuristics.

    Parameters:
        memory_df: Multi-index DataFrame (index = timestamp, columns = service memory values)
        slope_threshold: Minimum slope of memory increase to be considered a leak
        r2_threshold: Minimum R² value of linear trend to indicate steady growth
        min_duration_minutes: Minimum duration the leak pattern must persist

    Returns:
        List of services with suspected memory leaks and leak details
    """
    leak_results = []
    service_names = memory_df.columns
    min_points = (min_duration_minutes * 60) // 300  # assumes 5-min intervals

    for service in service_names:
        usage_series = memory_df[service].dropna()

        if len(usage_series) < min_points:
            continue  # not enough data points to make a call

        # Linear regression
        X = np.arange(len(usage_series)).reshape(-1, 1)
        y = usage_series.values.reshape(-1, 1)

        reg = LinearRegression().fit(X, y)
        slope = reg.coef_[0][0]
        r2 = reg.score(X, y)

        # Look for memory dips (suggesting garbage collection)
        dips = usage_series.diff().dropna() < -2.0
        has_gc_dips = dips.sum() > 0

        if slope > slope_threshold and r2 > r2_threshold and not has_gc_dips:
            leak_results.append({
                "service_name": service,
                "max_memory": float(np.max(usage_series)),
                "slope": float(slope),
                "r2_score": float(r2),
                "has_gc_dips": bool(has_gc_dips),
                "leak_reason": "Consistent increase without garbage collection dips"
            })

    return leak_results

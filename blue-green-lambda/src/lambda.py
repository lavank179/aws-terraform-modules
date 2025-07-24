import json
import datetime
import time


def lambda_handler(event, context):
    version = "v7"  # CHANGE THIS for each version deployment
    print(f"Executing {version}")
    
    # Simulate 3-min work
    time.sleep(5)  # Use 5–10s for realistic testing (not 3 mins)
    
    return {
        "statusCode": 200,
        "body": f"Hello from {version}, time: {datetime.datetime.now()}"
    }

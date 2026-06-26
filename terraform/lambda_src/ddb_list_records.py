from __future__ import print_function
import boto3
import json
from decimal import Decimal

print('Loading function: DDBListRecord')


# Fix Decimal serialization
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)


def lambda_handler(event, context):

    print("EVENT RECEIVED:", json.dumps(event))

    params = event.get("queryStringParameters") or {}
    multi_params = event.get("multiValueQueryStringParameters") or {}

    tableName = None

    if multi_params.get("tableName"):
        tableName = multi_params["tableName"][0]
    else:
        tableName = params.get("tableName")

    if not tableName:
        return {
            "statusCode": 400,
            "body": json.dumps("Missing tableName")
        }


    table = boto3.resource("dynamodb").Table(tableName)

    response = table.scan()

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response["Items"], cls=DecimalEncoder)
    }
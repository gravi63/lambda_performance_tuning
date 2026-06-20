from __future__ import print_function
import boto3
import json

print('Loading function: DDBListRecords')


def lambda_handler(event, context):
    '''
    Lists items in a DynamoDB table via Scan.

    Expected event:
      - tableName: required, the DynamoDB table to scan
      - payload: optional, kwargs passed directly to scan
                 e.g. {"FilterExpression": "...", "Limit": 50}
    '''
    if 'tableName' not in event:
        raise ValueError('"tableName" is required')

    dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    return dynamo.scan(**event.get('payload', {}))

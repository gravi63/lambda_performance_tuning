from __future__ import print_function
import boto3
import json

print('Loading function: DDBUpdateRecord')


def lambda_handler(event, context):
    '''
    Updates an item in DynamoDB.

    Expected event:
      - tableName: required, the DynamoDB table to update
      - payload: required, kwargs passed directly to update_item
                 e.g. {"Key": {"id": {"S": "123"}},
                       "AttributeUpdates": {"name": {"Value": {"S": "bar"}, "Action": "PUT"}}}
    '''
    if 'tableName' not in event:
        raise ValueError('"tableName" is required')
    if 'payload' not in event:
        raise ValueError('"payload" is required')

    dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    return dynamo.update_item(**event['payload'])

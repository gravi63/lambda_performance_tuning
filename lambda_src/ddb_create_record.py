from __future__ import print_function
import boto3
import json

print('Loading function: DDBCreateRecord')


def lambda_handler(event, context):
    '''
    Creates an item in DynamoDB.

    Expected event:
      - tableName: required, the DynamoDB table to write to
      - payload: required, kwargs passed directly to put_item
                 e.g. {"Item": {"id": {"S": "123"}, "name": {"S": "foo"}}}
    '''
    if 'tableName' not in event:
        raise ValueError('"tableName" is required')
    if 'payload' not in event:
        raise ValueError('"payload" is required')

    dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    return dynamo.put_item(**event['payload'])

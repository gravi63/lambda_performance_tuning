from __future__ import print_function
import boto3
import json

print('Loading function: DDBDeleteRecord')


def lambda_handler(event, context):
    '''
    Deletes an item from DynamoDB.

    Expected event:
      - tableName: required, the DynamoDB table to delete from
      - payload: required, kwargs passed directly to delete_item
                 e.g. {"Key": {"id": {"S": "123"}}}
    '''
    if 'tableName' not in event:
        raise ValueError('"tableName" is required')
    if 'payload' not in event:
        raise ValueError('"payload" is required')

    dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    return dynamo.delete_item(**event['payload'])

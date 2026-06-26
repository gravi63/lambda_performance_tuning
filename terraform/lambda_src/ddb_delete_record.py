from __future__ import print_function
import boto3
import json

print('Loading function: DDBDeleteRecord')


def lambda_handler(event, context):
    '''
    Creates an item in DynamoDB.

    Expected event:
      - tableName: required, the DynamoDB table to write to
      - payload: required, kwargs passed directly to put_item
                 e.g. {"Item": {"id": {"S": "123"}, "name": {"S": "foo"}}}
    '''
    operation = "delete"

    if 'tableName' in event:
        dynamo = boto3.resource('dynamodb').Table(event['tableName'])
    operations = {
        'create': lambda x: dynamo.put_item(**x),
        'read': lambda x: dynamo.get_item(**x),
        'update': lambda x: dynamo.update_item(**x),
        'delete': lambda x: dynamo.delete_item(**x),
        'list': lambda x: dynamo.scan(**x),
        'echo': lambda x: x,
        'ping': lambda x: 'pong'
    }

    if operation in operations:
        return operations[operation](event.get('payload'))
    else:
        raise ValueError('Unrecognized operation "{}"'.format(operation))

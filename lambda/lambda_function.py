import boto3  
region = 'ap-southeast-3'
instances = ['i-05d0a74a160855c9c']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
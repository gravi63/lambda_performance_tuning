###############################################################################
# AWS Lambda Power Tuning (Serverless Application Repository)
###############################################################################

# Deploy AWS Lambda Power Tuner from Serverless Application Repository (SAR)
resource "aws_serverlessapplicationrepository_cloudformation_stack" "power_tuner" {
  name           = "lambda-power-tuner"
  application_id = "arn:aws:serverlessrepo:us-east-1:650453409529:applications/aws-lambda-power-tuning"

  parameters = {}

  capabilities = ["CAPABILITY_IAM"]
}
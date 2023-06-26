
resource "aws_iam_policy" "policy" {
 
    description = "Policy to allow api gateway write to SQS"
    name        = "ekow-api-sqs-policy"
    path        = "/ekow-policies/"
    policy      = jsonencode(
        {
            Statement = [
                {
                    Action   = ["sqs:SendMessage"],
                    Effect   = "Allow",
                    Resource = "arn:aws:sqs:eu-west-2:352350294114:ekow-sqs.fifo"
                    Sid      = "VisualEditor0"
                },
            ]
            Version   = "2012-10-17"
        }
    )
   
    tags        = {}
}

resource "aws_iam_role" "bn-role" {
    
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "apigateway.amazonaws.com"
                    }
                    Sid       = ""
                },
            ]
            Version   = "2012-10-17"
        }
    )
    description           = "Allows API Gateway to SQS via VPC Endpoint."
    force_detach_policies = false
    managed_policy_arns   = [
        aws_iam_policy.policy.id,
    ]
    max_session_duration  = 3600
    name                  = "bn-role"
    path                  = "/new-role/"
    tags                  = {}
}

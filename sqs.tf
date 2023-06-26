resource "aws_sqs_queue" "akow-sqs" {
  # (resource arguments)
    content_based_deduplication       = false
    deduplication_scope               = "queue"
    delay_seconds                     = 0
    fifo_queue                        = true
    fifo_throughput_limit             = "perQueue"
    kms_data_key_reuse_period_seconds = 300
    max_message_size                  = 262144
    message_retention_seconds         = 345600
    name                              = "ekow-sqs.fifo"
    policy                            = jsonencode(
        {
            Id        = "__default_policy_ID"
            Statement = [
                {
                    Action    = "SQS:*"
                    Effect    = "Allow"
                    Principal = {
                        AWS = "arn:aws:iam::352350294114:root"
                    }
                    Resource  = "arn:aws:sqs:eu-west-2:352350294114:ekow-sqs.fifo"
                    Sid       = "__owner_statement"
                },
            ]
            Version   = "2008-10-17"
        }
    )
    receive_wait_time_seconds         = 0
    sqs_managed_sse_enabled           = true
    tags                              = {}
    tags_all                          = {}
    visibility_timeout_seconds        = 30
}

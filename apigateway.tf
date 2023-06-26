resource "aws_api_gateway_rest_api" "ekow-api" {
  # Resource
    api_key_source               = "HEADER"
    disable_execute_api_endpoint = false
    minimum_compression_size     = -1
    name                         = "ekow-api"
    put_rest_api_mode            = "overwrite"
    tags                         = {}
    tags_all                     = {}

    endpoint_configuration {
        types            = [
            "PRIVATE",
        ]
        vpc_endpoint_ids = [
            "${aws_vpc_endpoint.ekow-endpoint.id}"
        ]
    }
}

resource "aws_api_gateway_resource" "ekow-resource" {
  
    path_part       = "ekow-resource"
    parent_id       = aws_api_gateway_rest_api.ekow-api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.ekow-api.id
}

resource "aws_api_gateway_method" "ekow-method" {
    
    api_key_required     = false
    authorization        = "NONE"
    authorization_scopes = []
    http_method          = "POST"
    request_models       = {}
    request_parameters   = {}
    rest_api_id = aws_api_gateway_rest_api.ekow-api.id
    resource_id   = aws_api_gateway_resource.ekow-resource.id
}

resource "aws_api_gateway_integration" "ekow-integration" {
  # Resource
    cache_key_parameters    = []
    connection_type         = "INTERNET"
    http_method             = "POST"
    integration_http_method = "POST"
    passthrough_behavior    = "NEVER"
    request_parameters      = {
        "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
    }
    request_templates       = {
        "application/json" = <<-EOT
            #set($dedupId = $context.requestId)
            #set($groupId = $input.json('$.data.jobNumber'))
            Action=SendMessage&MessageBody=$input.body&MessageGroupId=$groupId&MessageDeduplicationId=$dedupId
        EOT
    }
    depends_on              = [aws_api_gateway_resource.ekow-resource]
    resource_id             = aws_api_gateway_resource.ekow-resource.id
    rest_api_id             = aws_api_gateway_rest_api.ekow-api.id
    timeout_milliseconds    = 29000
    
    type                    = "AWS"
    credentials             = aws_iam_role.bn-role.arn
    uri                     = "arn:aws:apigateway:eu-west-2:sqs:path/352350294114/ekow-sqs.fifo"
}

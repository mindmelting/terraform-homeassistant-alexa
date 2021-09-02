resource "aws_lambda_function" "haaska" {
  function_name    = "haaska-home-assistant"
  filename         = "./haaska_1.1.1.zip"
  source_code_hash = filebase64sha256("./haaska_1.1.1.zip")
  handler          = "haaska.event_handler"
  runtime          = "python3.6"

  role = aws_iam_role.lambda_iam_role.arn

  environment {
    variables = {
      "HA_BEARER_TOKEN" = var.ha_bearer_token
      "HA_URL"          = var.ha_url
    }
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "haaska-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "lambda.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "alexa" {
  statement_id  = "AllowExecutionFromAlexa"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.haaska.function_name
  principal     = "alexa-connectedhome.amazon.com"
  event_source_token = var.alexa_skill_id
}
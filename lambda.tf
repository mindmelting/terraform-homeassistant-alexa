resource "aws_lambda_function" "ha_alexa" {
  function_name    = "home-assistant-alexa"
  filename         = "./lambda_function.zip"
  source_code_hash = filebase64sha256("./lambda_function.zip")
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"

  role = aws_iam_role.lambda_iam_role.arn

  environment {
    variables = {
      "DEBUG"    = var.debug
      "BASE_URL" = var.ha_url
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
  statement_id       = "AllowExecutionFromAlexa"
  action             = "lambda:InvokeFunction"
  function_name      = aws_lambda_function.ha_alexa.function_name
  principal          = "alexa-connectedhome.amazon.com"
  event_source_token = var.alexa_skill_id
}
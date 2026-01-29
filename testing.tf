# Daily Report (Cron - 23:59 UTC)
resource "aws_cloudwatch_event_rule" "daily_report" {
  name                = "lks-eventbridge-daily-report"
  description         = "Generate daily operational report"
  schedule_expression = "cron(59 23 * * ? *)"
}

# Target Lambda
resource "aws_cloudwatch_event_target" "daily_report_target" {
  rule      = aws_cloudwatch_event_rule.daily_report.name
  target_id = "DailyReportLambda"
  arn       = aws_lambda_function.generate_report.arn
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge_daily_report" {
  statement_id  = "AllowEventBridgeDailyReport"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_report.arn
}

# Order Status Events (Event Pattern)
resource "aws_cloudwatch_event_rule" "order_status" {
  name        = "lks-eventbridge-order-status"
  description = "Capture order status change events"

  event_pattern = jsonencode({
    source = ["lks.order.management"],
    detail-type = ["Order Status Change"],
    detail = {
      status = ["CREATED", "PAID", "SHIPPED", "FAILED"]
    }
  })
}

# Target Lambda
resource "aws_cloudwatch_event_target" "order_status_target" {
  rule      = aws_cloudwatch_event_rule.order_status.name
  target_id = "OrderStatusLambda"
  arn       = aws_lambda_function.send_notification.arn
}

# Permission
resource "aws_lambda_permission" "allow_eventbridge_order_status" {
  statement_id  = "AllowEventBridgeOrderStatus"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_notification.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.order_status.arn
}

# 3. Low Stock Alert (Rate - every 1 hour)

resource "aws_cloudwatch_event_rule" "low_stock" {
  name                = "lks-eventbridge-low-stock"
  description         = "Check inventory stock every hour"
  schedule_expression = "rate(1 hour)"
}

# Target Lambda
resource "aws_cloudwatch_event_target" "low_stock_target" {
  rule      = aws_cloudwatch_event_rule.low_stock.name
  target_id = "LowStockLambda"
  arn       = aws_lambda_function.low_stock_check.arn
}

# Permission
resource "aws_lambda_permission" "allow_eventbridge_low_stock" {
  statement_id  = "AllowEventBridgeLowStock"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.low_stock_check.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.low_stock.arn
}

# LAMBDA REFERENCES (DATA / RESOURCE)
# Jika Lambda dibuat di file lain → pakai data source
data "aws_lambda_function" "generate_report" {
  function_name = "lks-lambda-generate-report"
}

data "aws_lambda_function" "send_notification" {
  function_name = "lks-lambda-send-notification"
}

data "aws_lambda_function" "low_stock_check" {
  function_name = "lks-lambda-low-stock-check"
}


###SubnetGroup###
resource "aws_db_subnet_group" "private_sb" {
  name        = "lks-order-privatesubnetgroup"
  description = "For More Secure Database"
  subnet_ids  = [your private subnet]
}
###RdsInstance(NoCLuster)
resource "aws_db_instance" "sofya_db" {
  identifier             = "lks-orders"
  allocated_storage      = 20
  db_name                = "orders_db"
  engine                 = "postgres"
  instance_class         = "db.t4g.micro"
  username               = "postgres"
  password               = "TechnoCloud2026!"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.private_sb.name
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.all_trafict.id]

}
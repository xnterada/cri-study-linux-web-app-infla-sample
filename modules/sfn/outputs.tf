output "start_state_machine_arn" {
  value       = aws_sfn_state_machine.start_server.arn
  description = "起動ワークフローのARN"
}

output "stop_state_machine_arn" {
  value       = aws_sfn_state_machine.stop_server.arn
  description = "停止ワークフローのARN"
}

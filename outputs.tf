output "role_url" {
  value = "https://console.aws.amazon.com/iamv2/home?#/roles/details/${aws_iam_role.demo_drift_role.name}?section=permissions"
}

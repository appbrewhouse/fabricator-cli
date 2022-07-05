data "aws_iam_user" "iam_access" {
  user_name = "iac"
}

resource "aws_iam_access_key" "iam_access" {
  user = data.aws_iam_user.iam_access.user_name
}

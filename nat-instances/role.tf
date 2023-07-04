resource "aws_iam_role" "this" {
  name = "${var.name}-InstanceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
  inline_policy {
    name = "network-interface"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = ["*"]
        Action = [
          "ec2:AttachNetworkInterface",
          "ec2:ModifyInstanceAttribute",
          "ec2:CreateRoute",
          "ec2:AssociateAddress",
          "ec2:ReplaceRoute"
        ]
      }]
    })
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMMangedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "${aws_iam_role.this.name}-InstanceProfile"
  role = aws_iam_role.this.name
}
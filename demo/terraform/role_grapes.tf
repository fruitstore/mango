resource "aws_iam_role" "grapes_demo" {
  name               = "grapes_demo"
  assume_role_policy = "${data.aws_iam_policy_document.policy_assume_grape_demo.json}"
}

resource "aws_iam_role_policy_attachment" "grapes_demo_lambda_attach" {
  role       = "${aws_iam_role.grapes_demo.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
}

resource "aws_iam_role_policy_attachment" "grapes_demo_vpc_attach" {
  role       = "${aws_iam_role.grapes_demo.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


data "aws_iam_policy_document" "policy_assume_grape_demo" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "lambda.amazonaws.com"]
    }
  }
}
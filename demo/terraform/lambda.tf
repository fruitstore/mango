resource "aws_lambda_function" "grape_demo_lambda" {
  filename         = "../lambda/grape_demo.zip"
  function_name    = "grape_demo"
  role             = "${aws_iam_role.grapes_demo.arn}"
  handler          = "./grape_demo"
  source_code_hash = "${base64sha256(file("../lambda/grape_demo.zip"))}"
  runtime          = "go1.x"

  vpc_config {
      subnet_ids =["${aws_subnet.grape_demo_a.id}", "${aws_subnet.grape_demo_b.id}"]
      security_group_ids = ["${aws_security_group.grape_demo_lambda.id}"]
  }
  environment {
    variables = {
      foo = "bar"
    }
  }
}
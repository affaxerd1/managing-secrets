provider "aws" {
    region = "eu-west-2"
  
}
//define ley policy - IAM policy which defines who can user a CMK
data "aws_caller_identity" "self" {
  
}

//user aws_caller_identity data source's inside aws_iam_policy_document to create a key policy that gives the current user admin permissions over the CMK
data "aws_iam_policy_document" "cmk_admin_policy" {
    statement {
      effect = "Allow"
      resources = ["*"]
      actions = ["kms:*"]
      principals {
        type = "AWS"
        identifiers = [data.aws_caller_identity.self.arn]
      }
    }
  
}

//now define CMK using the aws_kms_key resource
resource "aws_kms_key" "cmk" {
    policy = data.aws_iam_policy_document.cmk_admin_policy.json
  
}

//create an alias
resource "aws_kms_alias" "cmk" {
    name = "alias/kms-cmk-example"
    target_key_id = aws_kms_key.cmk.id
  
}
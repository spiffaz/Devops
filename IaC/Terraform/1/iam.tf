resource "aws_iam_role" "database" {
  name_prefix        = "${var.default_tags.project}-role-"
  assume_role_policy = data.aws_iam_policy_document.instance_trust_policy.json
}

data "aws_iam_policy_document" "instance_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "rds.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "instance_permissions_policy" {
  statement {
    sid    = "RDSDataServiceAccess"
    effect = "Allow"
    actions = [
      "dbqms:CreateFavoriteQuery",
      "dbqms:DescribeFavoriteQueries",
      "dbqms:UpdateFavoriteQuery",
      "dbqms:DeleteFavoriteQueries",
      "dbqms:GetQueryString",
      "dbqms:CreateQueryHistory",
      "dbqms:DescribeQueryHistory",
      "dbqms:UpdateQueryHistory",
      "dbqms:DeleteQueryHistory",
      "rds-data:ExecuteSql",
      "rds-data:ExecuteStatement",
      "rds-data:BatchExecuteStatement",
      "rds-data:BeginTransaction",
      "rds-data:CommitTransaction",
      "rds-data:RollbackTransaction",
      "secretsmanager:CreateSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:GetRandomPassword",
      "tag:GetResources"
    ]
    resources = [
      "*"
    ]
  }
}

## Consul Instance Role <> Policy Attachment
resource "aws_iam_role_policy" "database_instance_policy" {
  name_prefix = "${var.default_tags.project}-instance-policy-"
  role        = aws_iam_role.database.id
  policy      = data.aws_iam_policy_document.instance_permissions_policy.json
}

## Consul Instance Profile <> Role Attachment
resource "aws_iam_instance_profile" "database_instance_profile" {
  name_prefix = "${var.default_tags.project}-instance-profile-"
  role        = aws_iam_role.database.name
}

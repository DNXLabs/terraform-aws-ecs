resource "aws_backup_vault" "nfs" {
  count = var.expire_backup_efs > 0 ? 1 : 0
  name  = "vault-${var.name}"
}

resource "aws_backup_plan" "bkp_efs_plan" {
  count = var.expire_backup_efs > 0 ? 1 : 0
  name  = "Backup-${var.name}"

  rule {
    rule_name         = "Daily-Backup-${var.name}"
    target_vault_name = aws_backup_vault.nfs.*.name[count.index]
    schedule          = "cron(0 22 * * ? *)"
    lifecycle {
      delete_after = var.expire_backup_efs
    }
  }
}

resource "aws_iam_role" "efs_backup_role" {
  count = var.expire_backup_efs > 0 ? 1 : 0

  name               = "Backup-efs-${var.name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
      "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "efs_backup_role" {
  count = var.expire_backup_efs > 0 ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.efs_backup_role.*.name[count.index]
}


resource "aws_backup_selection" "example" {
  count = var.expire_backup_efs > 0 ? 1 : 0

  iam_role_arn = aws_iam_role.efs_backup_role.*.arn[count.index]
  name         = "Backup-efs-${var.name}"
  plan_id      = aws_backup_plan.bkp_efs_plan.*.id[count.index]
  resources = [
    aws_efs_file_system.ecs.arn
  ]
}

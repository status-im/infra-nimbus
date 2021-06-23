resource "aws_iam_user" "nimbus_team" {
  name  = var.nimbus_team_members[count.index]
  count = length(var.nimbus_team_members)
  tags  = { Purpose = "Nimbus team Console access" }
}

resource "aws_iam_group" "nimbus_team" {
  name = "nimbus-team-members"
  path = "/users/"
}

resource "aws_iam_access_key" "nimbus_team" {
  user  = aws_iam_user.nimbus_team[count.index].name
  count = length(aws_iam_user.nimbus_team)

  /* GPG key for encrypting the secret key */
  pgp_key = file("files/${aws_iam_user.nimbus_team[count.index].name}.gpg")
}

resource "aws_iam_user_login_profile" "nimbus_team" {
  user  = aws_iam_user.nimbus_team[count.index].name
  count = length(var.nimbus_team_members)

  /* GPG key for encrypting the secret key */
  pgp_key = file("files/${aws_iam_user.nimbus_team[count.index].name}.gpg")

  /* Make user change password after first login */
  password_reset_required = true

  /* Avoid re-creating due to password change */
  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
}

resource "aws_iam_group_membership" "nimbus_team" {
  name  = "nimbus-team-group-membership"
  group = aws_iam_group.nimbus_team.name
  users = aws_iam_user.nimbus_team.*.name
}

resource "aws_iam_group_policy_attachment" "nimbus_team" {
  group      = aws_iam_group.nimbus_team.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

/* These are encrypted using the GPG key, uncomment to get the password. */
/*
output "nimbus_team_passwords" {
  value = {
    for profile in aws_iam_user_login_profile.nimbus_team:
      profile.user => profile.encrypted_password
  }
}
*/

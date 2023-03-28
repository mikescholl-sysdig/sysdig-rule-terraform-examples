

data "external" "branch" {
  program = ["${path.module}/env.sh"]
}

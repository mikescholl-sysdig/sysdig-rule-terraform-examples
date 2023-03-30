locals {
  branch_name = replace(data.external.branch.result.branch, "/", "-")
}
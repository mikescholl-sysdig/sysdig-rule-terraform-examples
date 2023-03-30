data "external" "branch" {
  program = ["/bin/bash", "-c", "echo", "'{\"branch\":${BUILDKITE_BRANCH}}'"]
}

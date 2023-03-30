resource "sysdig_secure_rule_falco" "exec_shell" {
  name        = local.branch_name != "main" ? "exec_shell_${local.branch_name}" : "exec_shell" // ID
  description = "A shell was used as the entrypoint/exec point into a container with an attached terminal."
  tags        = ["container", "shell", "mitre_execution"]

  condition = "spawned_process and container and shell_procs and proc.tty != 0 and container_entrypoint"
  output    = "A shell was spawned in a container with an attached terminal (user=%user.name %container.info shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)"
  priority  = "notice"
  source    = "syscall" // syscall, k8s_audit, aws_cloudtrail, gcp_auditlog or azure_platformlogs


  exceptions {
    name   = "proc_names"
    fields = ["proc.name"]
    comps  = ["in"]
    values = jsonencode([[["python", "python2", "python3"]]])
    # If only one element is provided, it should still needs to be specified as a list of lists.
  }
}

data "template_file" "exec_shell" {
  count = local.branch_name != "main" ? 1 : 0
  template = file("${path.module}/templates/rule.yaml.tpl")
  vars = {
    rule_name = sysdig_secure_rule_falco.exec_shell.name
    rule_condition = sysdig_secure_rule_falco.exec_shell.condition
    rule_output = sysdig_secure_rule_falco.exec_shell.output
    rule_source = sysdig_secure_rule_falco.exec_shell.source
    rule_description = sysdig_secure_rule_falco.exec_shell.description
    rule_priority = sysdig_secure_rule_falco.exec_shell.priority
  }
}

resource "local_file" "exec_shell" {
  count = local.branch_name != "main" ? 1 : 0
  filename = "rules/${sysdig_secure_rule_falco.exec_shell.name}.yaml"
  content = data.template_file.exec_shell[0].rendered
}
resource "random_pet" "node_groups" {
  for_each = local.node_groups_expanded

  separator = "-"
  length    = 2

  keepers = {
    ami_type      = lookup(each.value, "ami_type", null)
    disk_size     = lookup(each.value, "disk_size", null)
    instance_type = each.value["instance_type"]
    iam_role_arn  = each.value["iam_role_arn"]

    key_name = each.value["key_name"]

    source_security_group_ids = join("|", compact(
      lookup(each.value, "source_security_group_ids", [])
    ))
    subnet_ids      = join("|", each.value["subnets"])
    node_group_name = join("-", [var.cluster_name, each.key])
    launch_template = lookup(each.value, "launch_template_id", null)
    launch_template_version = lookup(each.value, "launch_template_version", null)
  }

  depends_on = [var.ng_depends_on]
}

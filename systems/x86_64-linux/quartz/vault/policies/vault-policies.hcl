# Allow the policies helper to list and modify policies
path "sys/policies/acl/*" {
	capabilities = [ "create", "list", "read", "update", "delete", "patch" ]
}

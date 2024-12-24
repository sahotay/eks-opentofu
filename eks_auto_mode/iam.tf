# Service-Linked Role for Spot Instances
## This service-linked role is required to utilize Spot Instances in the account.
### For more information, see the AWS documentation on Service-Linked Roles.
#### https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create-service-linked-role.html

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
  description      = "Service linked role for Spot instances"
}
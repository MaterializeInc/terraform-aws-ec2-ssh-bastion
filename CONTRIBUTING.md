# Contributor instructions

## Testing

### Manual testing

To test the module manually, follow these steps:

1. Login to the [AWS console](https://aws.amazon.com/) and note down your VPC ID and subnet IDs.
1. Copy the `terraform.tfvars.example` file to `terraform.tfvars`:
    ```
    cp terraform.tfvars.example terraform.tfvars
    ```
1. Update the values in `terraform.tfvars` to match your VPC.
1. Create the resources:
    ```
    terraform apply
    ```
1. After the resources have been created, `psql` to your Materialize instance and create the SSH tunnel connection by using the statement from the terraform output
1. Get the SSH public key from Materialize by using the statement from the terraform output
1. SSH into the bastion host using the command from the terraform output
1. Add the Materialize SSH public key to the `~/.ssh/authorized_keys` file on the bastion host

## Cutting a new release

Perform a manual test of the latest code on `main`. See prior section. Then run:

    git tag -a vX.Y.Z -m vX.Y.Z
    git push origin vX.Y.Z

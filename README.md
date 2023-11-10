# terraform-modules

The repo for Answer Digital shared Terraform modules.

## Using these modules

You can use these modules in your own terraform projects as follows:

```hcl
module "ec2_setup" {
  source = "github.com/answerdigital/terraform-modules//modules/aws/ec2?ref=v4"
}
```

Notice the double `//` between the repository URL and the path to the module.
For further information please see the [terraform documentation](https://developer.hashicorp.com/terraform/language/modules/sources#modules-in-package-sub-directories).

Versions are shared across all modules. You can choose a specific tag (e.g. `?ref=v4.0.0`) or to get the latest changes within a major version, use `?ref=v4` which will get the latest v4.x.x release.

## Documentation

Further documentation can be found in the [wiki](https://github.com/answerdigital/terraform-modules/wiki).

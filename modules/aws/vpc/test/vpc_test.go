package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/terraform-modules/test/aws"
	"testing"
)

func TestTerraformAwsHelloWorldExample(t *testing.T) {
	t.Parallel()

	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: ".",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	aws.TestSharedMethod("OOH")
}



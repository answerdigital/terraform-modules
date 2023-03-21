package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
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

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	ContainsString(t, vpcId)
}

func ContainsString(t *testing.T, a string) {
	// Replace this with the string you want to check

	if !strings.Contains(a, "vpc") {
		t.Errorf("Expected the input string to contain 'vpc', but it did not: %s", a)
	}
}

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAlbListenerRules(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: ".",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":               "test-cluster",
			"vpc_id":             "vpc-12345678",
			"private_subnet_ids": []string{"subnet-1", "subnet-2"},
			"public_subnet_ids":  []string{"subnet-3", "subnet-4"},
			"secure_subnet_ids":  []string{"subnet-5", "subnet-6"},
			"certificate_arn":    "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012",
			"alb":                true,
			"alb_listener_rules": []map[string]interface{}{
				{
					"path_pattern":     "/api/service1/*",
					"target_group_arn": "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service1/abcdef1234567890",
					"priority":         100,
				},
				{
					"path_pattern":     "/api/service2/*",
					"target_group_arn": "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/service2/abcdef1234567890",
					"priority":         110,
					"host_header":      "example.com",
				},
			},
		},

		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	albPathBasedRoutingRules := terraform.OutputList(t, terraformOptions, "alb_path_based_routing_rules")

	// Verify we have the correct number of rules
	assert.Equal(t, 2, len(albPathBasedRoutingRules))
}
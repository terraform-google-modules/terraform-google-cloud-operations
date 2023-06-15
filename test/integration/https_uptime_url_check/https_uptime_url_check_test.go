package https_uptime_url_check

import (
	"testing"

	// import the blueprints test framework modules for testing and assertions

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// name the function as Test*
func TestUptimeCheckModule(t *testing.T) {

	// initialize Terraform test from the blueprint test framework
	uptimeCheckT := tft.NewTFBlueprintTest(t)
	// define and write a custom verifier for this test case call the default verify for confirming no additional changes
	uptimeCheckT.DefineVerify(func(assert *assert.Assertions) {
		// perform default verification ensuring Terraform reports no additional changes on an applied blueprint
		uptimeCheckT.DefaultVerify(assert)
	})
	// call the test function to execute the integration test
	uptimeCheckT.Test()
}

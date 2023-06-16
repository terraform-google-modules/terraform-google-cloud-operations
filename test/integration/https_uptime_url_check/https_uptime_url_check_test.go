package https_uptime_url_check

import (
	"testing"

	// import the blueprints test framework modules for testing and assertions

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
)

// name the function as Test*
func TestUptimeCheckModule(t *testing.T) {

	// initialize Terraform test from the blueprint test framework
	uptimeCheckT := tft.NewTFBlueprintTest(t)
	// call the test function to execute the integration test
	uptimeCheckT.Test()
}

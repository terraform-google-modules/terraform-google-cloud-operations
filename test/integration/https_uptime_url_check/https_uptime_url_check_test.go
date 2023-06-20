/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

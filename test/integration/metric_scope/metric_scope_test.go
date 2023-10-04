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

package metric_scope

import (
	"testing"
	"fmt"

	// import the blueprints test framework modules for testing and assertions

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// name the function as Test*
func TestMetricScopeModule(t *testing.T) {
	const scope_project = "2"
	const group = "2"

	// initialize Terraform test from the blueprint test framework
	ms := tft.NewTFBlueprintTest(t)

	ms.DefineVerify(func(assert *assert.Assertions) {
		ms.DefaultVerify(assert)
		assert.Equal(scope_project, ms.GetStringOutput("metric-scope-ids"), fmt.Sprintf("Monitored project are created"))
		assert.Equal(group, ms.GetStringOutput("monitoring-groups"), fmt.Sprintf("Monitored Groups are created"))

	})
	// call the test function to execute the integration test
	ms.Test()
}

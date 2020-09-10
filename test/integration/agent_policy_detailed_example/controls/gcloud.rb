# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control "gcloud" do
  title "gcloud"

  describe command("gcloud --project=#{attribute("project_id")} services list --enabled") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "logging.googleapis.com" }
    its(:stdout) { should match "monitoring.googleapis.com" }
    its(:stdout) { should match "osconfig.googleapis.com" }
  end

  describe command("gcloud alpha compute instances ops-agents policies describe " \
    "ops-agents-test-policy-detailed --project=#{attribute("project_id")} --quiet") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
  end
end

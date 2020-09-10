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

project_id = attribute('project_id')
description = attribute('description')
agent_rules = attribute('agent_rules')
group_labels = attribute('group_labels')
os_types = attribute('os_types')
zones = attribute('zones')
instances = attribute('instances')

control "gcloud" do
  title "gcloud"

  describe command("gcloud alpha compute instances ops-agents policies describe " \
    "ops-agents-test-policy-update --project=#{attribute("project_id")} " \
    "--quiet --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end


    describe "description" do
      it "is equal to the description created by the module" do
        expect(data['description']).to eq description
      end
    end

    describe "agent_rules" do
      it "is equal to the agent_rules created by the module" do
        data['agent_rules'].zip(agent_rules).each do |agent_rule_actual, agent_rule_expected|
          agent_rule_actual = agent_rule_actual.transform_keys(&:to_sym)
          expect(agent_rule_actual).to eq agent_rule_expected
        end
      end
    end

    describe "group_labels" do
      it "is equal to the group_labels created by the module" do
        if group_labels == []
          expect(data['assignment']['group_labels']).to eq group_labels
        else
          # data['assignment']['group_labels'].zip(group_labels).each do \
          #   |group_labels_actual, group_labels_expected|
          #   group_labels_actual.zip(group_labels_expected).each do \
          #     |group_label_actual, group_label_expected|
          #     expect(group_label_actual[0]).to eq group_label_expected[:name]
          #     expect(group_label_actual[1]).to eq group_label_expected[:value]
          #   end
          # end
          data['assignment']['group_labels'].zip(group_labels).each do \
            |group_labels_actual, group_labels_expected|
            group_labels_actual = group_labels_actual.transform_keys(&:to_sym)
            expect(group_labels_actual).to eq group_labels_expected
          end
        end
      end
    end

    describe "os_types" do
      it "is equal to the os_types created by the module" do
        data['assignment']['os_types'].zip(os_types).each do \
          |os_types_actual, os_types_expected|
          os_types_actual = os_types_actual.transform_keys(&:to_sym)
          expect(os_types_actual).to eq os_types_expected
        end
      end
    end

    describe "zones" do
      it "is equal to the zones created by the module" do
        expect(data['assignment']['zones']).to eq zones
      end
    end

    describe "instances" do
      it "is equal to the instances created by the module" do
        expect(data['assignment']['instances']).to eq instances
      end
    end
  end
end

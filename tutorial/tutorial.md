# Cloud Ops Agent Terraform Tutorial

This tutorial will guide you through using Terraform by Hashicorp to deploy three new VMs 

## Prerequisites 
You **MUST** have a project with billing enabled to use this tutorial.

Enter the tutorial directory. 
```bash 
cd tutorial
```

Rename the Terraform Variable Example file.  
```bash
mv terraform.tfvars.example terraform.tfvars
```

Download the set-permissions script:
```bash
curl -O https://cloud.google.com/stackdriver/docs/set-permissions.sh
```

### Project Selection

If needed, login to your gcp account within cloudshell, this ensures you're able to run the necessary commands.  
```bash
gcloud auth login
```

Next, set a project you'll be deploying VMs in. To see available projects:   
```bash
gcloud projects list
```
And then set your configuration for whichever project you prefer:  
```bash
gcloud config set project PROJECT_ID
```

Lastly, enable the following APIs if needed:
```bash
gcloud services enable compute.googleapis.com
```
```bash 
gcloud services enable osconfig.googleapis.com
```

## Service Account Setup 
Next you'll need to create a service account and credentials file. These resources allow Terraform to create the VM. 
**NOTE** 
For this example we'll name the service account and display it as 'terraform' but this is an arbitrary string and can be subsituted however you see fit.

1. Create the Terraform service account.
```bash
gcloud iam service-accounts create terraform \
  --description="Service account for VM provisioning with Terraform" \
  --display-name="terraform"
```
2. Create the iam policy bindings and attach the necessary role to the account:
```bash 
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member="serviceAccount:terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" --role="roles/compute.admin" 
```
```bash 
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member="serviceAccount:terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" --role="roles/osconfig.guestPolicyAdmin" 
```
```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member="serviceAccount:terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com" --role="iam.serviceAccountUser"
```

3. Create the key-file associated with the service account:
```bash
gcloud iam service-accounts keys create test-key.json --iam-account=terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```
4. Run the `set-permissions.sh` script to add the necessary logging and monitoring roles:
```bash
chmod 777 set-permissions.sh
./set-permissions.sh --project=$GOOGLE_CLOUD_PROJECT
```

## Using Terraform

### Configure Terraform file
This tutorial has 3 Terraform files present:
```bash
user@cloudshell:~/terraform $ tree
.
|-- main.tf
|-- terraform.tfvars
|-- test-key.json
`-- variables.tf
```

You'll make changes in the `terraform.tfvars` file. At a minimum you need to specify values for the following inside of double quotes (""):  
```bash
gcp_project =
service_account_email = 
```
Set the `gcp_project` variable with the output from:
```bash
echo $GOOGLE_CLOUD_PROJECT
```
And for `service_acount_email` we'll use the default compute service account for this project. The default service account email is structured like: `PROJECT_ID_NUM-compute@developer.gserviceaccount.com`
If you're unsure of your project number, you can capture it with the following command in CloudShell:  
```bash
gcloud projects describe $GOOGLE_CLOUD_PROJECT --format="value(projectNumber)"
```

### Initialize Terraform deployment
Once you've set the two required variables, you can initialize your terraform deployment:
```bash
terraform init
```

If there are no issues, you are ready to continue.

## Understanding the Terraform deployment

### Review the VM definition
Review the  <walkthrough-editor-open-file filePath="tutorial/main.tf" startLine="15" endLine="45"> Compute Instance definition</walkthrough-editor-open-file> in `main.tf`. This defines a single compute vm for demo purposes, with several labels.

### Review the Cloud Ops Agent definition
The <walkthrough-editor-open-file filePath="tutorial/main.tf" startLine="47" endLine="77"> Cloud Ops Agent Policy definition </walkthrough-editor-open-file> defines the Cloud Ops Agent policy, which uses Google's [VM Manager Guest OS Policy tool](https://cloud.google.com/compute/docs/os-config-management#how_guest_policies_work) to manage the Cloud Ops Agent and it's updates, and it targets VMs with the labels that we previously defined.

## Create resources
To create the resources we can first view our plan:
```bash
terraform plan
```
And then build the resources:
```bash
terraform apply
```
Terraform will prompt you for confirmation here, be sure to type in 'yes' if you want to continue!

After deployment, you'll need about 5-10 minutes before data from the OPs Agent appears in Google Cloud Console

## Review the GCE Observability Page
After about 5 minutes, the Ops Agent should have started submitting data.

From the <walkthrough-spotlight-pointer spotlightId="console-nav-menu">Cloud Console Menu</walkthrough-spotlight-pointer> select the Google Compute Engine section, then select the VM you just created. Select the VM's "Observability" tab, and view the newly generated metrics.

## Clean up
To clean up all your work in this tutorial, first deprovision your VM with Terraform:
``` terraform destroy```

Then delete the service account and the key created during this tutorial:
```bash
gcloud iam service-accounts keys delete key-id --iam-account terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```
```bash
gcloud iam service-accounts delete terraform@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```

## Conclusion
You've successfully used Terraform to create a VM, attach an agent policy, and deploy the Cloud Ops Agent! Great work.
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

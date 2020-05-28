# newterra v1
Auto-creation of a `main.tf` Terraform file for most services, only focused on infrastructure creation.  Post-infrastructure setup is currently outside the scope.

Currently, this script must be run from the same location as the templates folder that is part of this repo.  A "blank" csv file is included with the correct header row so you can enter the `access key` and `secret key` data provided in Lab Content Tools.  If you decide to not use this credentials file, the script will ask you to input your cloud sandbox `access_key` and `secret_key` through prompts.

**The ./terraform-builder.ps1 when ran will do the following:**

- Validate your credentials
- Create the base `main.tf` file
- Initialize the Terraform enviornment with `terraform init`
- Ask questions to create different variations of resources based on your input
- Add these resoruces to the `main.tf` file
- Validate the `main.tf` file for errors with `terraform validate`
- Plan the changes to the AWS environment with `terraform plan`
- Create the requested resources in the AWS environment with `terraform apply`


## Operation

To operate, you first need to ensure you have the pre-requisite [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7) package available.  If you are on Windows, your native PowerShell version will also work. Then follow these steps.

1. Download or clone this repo from GitHub.
2. Open a PowerShell console and change directory to the `newterra` directory.
3. Run the `terraform-builder.ps1` script.

> If you run into a a script execution issue on Windows, remember you may need to change your execution policy.
> 
> The quickest way to do that is to run the script with the following flags:
> `powershell.exe -ExecutionPolicy Bypass -File C:\your\path\to\newterra\terraform-builder.ps1`

4. Once the script is running, follow the prompts to enter credentials and a few different resources as defined by the included templates.
5. When the script finishes, you'll have an auto-generated `main.tf` file that's been automatically applied to your cloud sandbox.  You can also use that `main.tf` file as a base for the Terraform you upload to Pluralsight's Lab Content Tools.
6. When you are ready to upload your Terraform file, follow the [steps on the Author Kit site](https://authors.pluralsight.com/labs-workflow-overview/setting-up-an-environment-with-terraform/).

## AWS
### Currently Supported Services
- VPC
- Internet Gateway
- Subnets
- EC2 Instances
- S3 Buckets


This is not officially supported by Pluralsight, but feel free to add issues or feature requests for feedback.  If this is helpful, please reach out to your AE, ASM, or PE-I and let them know so we can look at continued development.

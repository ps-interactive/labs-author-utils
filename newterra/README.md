# newterra v1
Auto creation of a main.tf file for most services, only focused on infrastructure creation.  Post infrastructure setup is currently outside the scope.

Currently, this script must be ran from the same location as the templates folder that is part of this package.  Terraform.exe is included because it is a requirment, as well as a "blank" csv file with the correct headers for your csv credentials file.  Though if you do not use the credentials file, the script will ask for your credentials to be input directly.

**The ./terraform-builder.ps1 when ran will do the following:**

- Validate your credentials
- Create the base main.tf file
- Initialize the terraform enviornment with terraform init
- Ask questions to create different variations of resources based on your input
- Add these resoruces to the main.tf file
- Validate the main.tf file for errors with terraform validate
- Plan the changes to the aws environment with terraform plan
- Create the requested resources in the AWS environment with Terraform apply


## Operation

To operate you first need to ensure you have the pre-requisite powershell core package available.  If you are on windows your native powershell version will also work. Then follow these steps.

1. Download or clone this project folder from github.
2. Open a powershell console and change directory to the newterra directory.
3. Run the terraform-builder.ps1 script.
> If you run into a a script execution issue on Windows remember you may need to change your execution policy.
4. Follow the promptes entering the credentials provided from the PS Author environment tool.
5. Enjoy your auto generated file and usable environment.
6. Us this main.tf file as a base for your learner environment.
7. When you are ready to turn in your terraform file follow the steps on the PS Author Kit.

This script will take input from a credentials file and a resources files and create a usable terraform main.tf file.


## AWS
### Currently Supported Services
- VPC
- Internet Gateway
- Subnets
- Ec2 Instances
- S3 Buckets


This is not officially supported by Pluralsight.  But feel free to add issues or feature requests for feedback.  If this is helpful.  Please reach out to your AE or ASM and let them know and we can look at continued development.

<#
.SYNOPSIS
    Powershell Core 7.0 script that creates a terraform file for aws with credentils provided in a "credentials.csv" file in the same directory or copied in directly if credentials.csv is not found.
    After you answer the questions, a maint.tf file will be created, validated, planed and then applied to a aws account created the associated resources.  Remember you can remove them all by running .\terraform.exe destroy.
    You can create the project in any folder you like, but the script must be ran from the folder with the templates folder.  
        
        - Currently supported: 
            AWS:
                - vpc
                - Internet Gateway
                - Subnets
                - EC2
                - S3 Bucket

        - Unsupported: 
            everything else for now

.DESCRIPTION
    Creates a default main.tf file based your answers as a starting place for your terraform lab file submission.  
    This is for getting starting with an environment that does not yet exist. 
    When you are ready to submit your main.tf file. Remove the Access and Secrete keys field and data and send to a compressed folder named terraform.zip

.PARAMETER full_folder_path
   

.NOTES
    Author: Aaron Rosenmund
    Last Edit: 2020-05-21
    Version 1.01 - Alpha newterra
#>


#ps-environment settings

#initializing environment to import cloud resources
function initialize-environment(){

    # Create Main.tf

    $global:project_path = read-host "Path to folder containing the following:
    - terraform.exe
    - credentials.csv (Requires csv with Header `"Access key ID`" and `"Secret access key`" to properly work.)

    [Enter Here]:
    " 

    $global:newterra_path = get-location
    $global:newterra_path = $newterra_path.Path 
    set-location $global:project_path
    # check for credentials csv--> import credentials
    $files = Get-ChildItem
    $filenames = $files.Name
    $c = 0
    Foreach ($name in $filenames){

        if($name -eq "credentials.csv"){$c++} 
    }

    if($c -eq 1){
    $creds = import-csv $global:project_path\credentials.csv
    $access = $creds.'Access key ID'
    $secret = $creds.'Secret access key'}else{
                                                Write-warning "There is no credentials.csv file. Let's add credentials manually."
                                                Write-host "You will need the Access key ID as well as the Secrete access key for the account."
                                                $access = Read-host "Enter the Access Key ID"
                                                $secret = Read-host "Enter the Secret access key"
                                                }


$provider_text = "
variable `"region`" {
    default = `"us-west-2`"
    }

provider `"aws`" {
    version = `"~> 2.0`"
    region  = var.region
    access_key = `"$access`"
    secret_key = `"$secret`"
}

"
# add random function string to call later
$random_function = "
# Requires the `Random` Provider - it is installed by terraform init
resource `"random_string`" `"version`" {
    length  = 8
    upper   = false
    lower   = true
    number  = true
    special = false
}"

    $provider_text | out-file -Encoding utf8 $global:project_path\main.tf
    $random_function | out-file -Append -Encoding utf8 $global:project_path\main.tf

    .\terraform.exe init -no-color

 Write-Host -Message "Newterra has finished initualizing your enviornment. You may now begin the default selection builder or use terraform.exe command line tools with your AWS login." -ForegroundColor Green

  #main file created

}

function start-default_build(){

Write-host "A VPC, Internet gateway and subnet are required and can be created with this script. Would you like to create these default resources now? [Y]es / [N]o"
$default_Networking = Read-host
if ($default_Networking -match "[Yy]"){
    #create default vpc in main.tf
    get-content $global:newterra_path\templates\default_networking.tf | out-file -append -Encoding utf8 $global:project_path\main.tf
    }else{write-host "No default networking was created you will need to create these yourself and import into your terraform main.tf before submitting."}
#Default EC2 instances.

Write-host "Default EC2 instances can be created for you based on the t2.micro ubunut 18.04 distribution. Would you like to create these default EC2 resoruces now?  [Y]es / [N]o"

$ami ="
data `"aws_ami`" `"ubuntu`" {
    most_recent = true

    filter {
        name = `"name`"
        values = [`"ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*`"]
    }

    filter {
        name = `"virtualization-type`"
        values = [`"hvm`"]
    }

    owners = [`"099720109477`"]

}
"
$ami | out-file -Append -Encoding utf8 $global:project_path\main.tf

$default_EC2 = Read-Host
if($default_EC2 -match "[Yy]"){
    #ask for number requested
    [int]$i = read-host "How many EC2 instances would you like creates? [1-10]"
    $c = 0
    while($c -lt $i){
        $n = $c
        $ec2_name = "ps-t2micro-$n"
        [object[]]$default = get-content $global:newterra_path\templates\default_ec2.tf 
        $default = $default.replace("ec2_name",$ec2_name)
        $note = "#creating EC2 instance resource $c."
        $note | out-file -Append -Encoding utf8 $global:project_path\main.tf
        $default | out-file -Append -Encoding utf8 $global:project_path\main.tf
        $c++
    }
    #pull content from template --> identified variables should already be set-->output as append to maint.tf

}else{Write-host "No default EC2 resources were created."}


#Default S3 Buckets
Write-host "Default S3 buckets can be created for you. Would you like to create these default EC2 resoruces now?  [Y]es / [N]o"
$default_S3 = Read-Host

if($default_S3 -match "[Yy]"){
    #ask for number of s3 buckets
    [int]$i = read-host "How many S3 buckets would you like creates? [1-5]"

    $c = 0
    while($c -lt $i){
        $n = $c
        $s3_name = "ps-s3-$n"
        $bucket_name = "ps-s3-$n-"+"`${random_string.version.result}"
        [object[]]$default = get-content $global:newterra_path\templates\default_s3.tf 
        $default = $default.replace("s3_name",$s3_name)
        $default = $default.replace("bucket_name",$bucket_name)
        $note = "#creating s3 instance resource $c."
        $note | out-file -Append -Encoding utf8 $global:project_path\main.tf
        $default | out-file -Append -Encoding utf8 $global:project_path\main.tf
        $c++
    }

}else{Write-host "No default S3 resources were created."}

#Planned support for Default Users list.

#test main.tf
.\terraform.exe validate -no-color
.\terraform.exe plan -no-color -lock=false
.\terraform.exe apply -no-color -lock=false -input=false -auto-approve
write-host "All your requested default resources have been created. Once you are ready remove the Access key ID and secret access key lines from the main.tf file and it will be in the valid format for submission of the main.tf file." -ForegroundColor Green
}

initialize-environment

start-default_build


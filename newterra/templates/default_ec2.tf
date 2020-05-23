resource "aws_instance" "ec2_name" {
    ami                          = data.aws_ami.ubuntu.id
    associate_public_ip_address  = true
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    subnet_id                    = aws_subnet.lab_vpc_subnet_a.id

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        volume_size           = 8
        volume_type           = "gp2"
    }

    timeouts {}
}
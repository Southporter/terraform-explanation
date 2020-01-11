# This script would handle any OS level installations
# or other setup.
sudo yum update -y
sudo yum install -y nodejs # Or some other packages
# You can use terraform variables like this:
export DB_URL=${db_url}
# The ${var_name} will get replaced by what ever is in the vars block
# in the data.template_file.user_data part of the terraform code.

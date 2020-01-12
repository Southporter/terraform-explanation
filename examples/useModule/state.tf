terraform {
	backend "s3" {
		bucket = "shem-terraform-state" # The s3 bucket name
		key    = "webservers-tutorial"  # This is the key inside the bucket

		# A profile that has access to the bucket
		# The bucket will be the same regardles
		# of which account or region you are
		# deploying to, so hardcoding this here is
		# not necessarily a bad thing.
		profile = "terraform"
		# The same applies to region
		region = "us-east-1"
	}
}

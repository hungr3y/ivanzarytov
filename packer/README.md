To run packer build job you have to:
1) create file in the root folder of the repository, name format should be "*.token.hcl"
2) put AWS access key and secret key in the file in hcl format (access_key = "ACCESSKEY123")
3) install required plugins for packer with packer init

`packer init .`
4) run build job with pointing token file as var file

`packer build -var-file=".packer.token.hcl" packer/backend`
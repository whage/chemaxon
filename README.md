# Interview exercise for ChemAxon

# 1 - Coding and deployment
The first part was a coding and deployment exercise. The code implements the "clock mirror image" problem.

## 1.1 Create ECR repository
To create an ECR repository, run `terraform init` and `terraform apply` in the `terraform/ecr` folder.
The URL of the newly created docker repository can be viewed by running `terraform output`.
Requires `terraform 0.12.xx`!

## 1.2 Build & push docker image
To build the docker image, run `build.sh` with your own ECR repository UR, for example:
```
./build.sh 583709312004.dkr.ecr.eu-central-1.amazonaws.com/sallai-chemaxon
```

The app is compiled in a docker container (official golang image) to make
sure the build environment is always the same. The compiled binary is then added to an
ubuntu docker image without the build tools.

After a `docker login` to the ECR repository, we must push the image, for example:
```
docker push 583709312004.dkr.ecr.eu-central-1.amazonaws.com/sallai-chemaxon:1.0.0
```

## 1.3 Deploy the application to AWS
To deploy the application in a **very minimal** setup, run `terraform init` followed by `terraform apply` in the
`terraform/application` folder. It requires some variables for the ECR repository and
the ssh key pair (should match an existing EC2 key pair).
Ideally, these would be set with some config management tool based on the earlier ECR deployment
but for this exercise, the simplest way to set them is through environment variables:
- `TF_VAR_ecr_password`
- `TF_VAR_ecr_repository`
- `TF_VAR_key_name`

The HCL files deploy an EC2 instance with a public IP address and start the application
in a docker container (using EC2 `user_data`) exposed on TCP port 80.
Port 22 is also open for some ssh debugging.

## 1.4 HTTP endpoint
The compiled binary runs an HTTP server with a single endpoint: `/getTimeFromMirrorImage`.
It expects its input via query string parameters:

- `hours`
- `minutes`

It takes a clock reading as seen in the mirror and returns the "real" clock reading as a string in
`<hours>:<minutes>` format.
 
Example call to the HTTP endpoint:
```
curl "http://<server_ip>/getTimeFromMirrorImage?hours=12&minutes=03"
```

# 2 - AWS network module
The second part was to create a terraform module that can be used to deploy VPC level resources
into an AWS account.

It creates a VPC with 2 public and 2 private subnets with the corresponding internet- and NAT gateways
and route tables.
It also creates a VPC endpoint for S3 for accessing S3 buckets without leaving the AWS network.

To deploy, run `terraform init` and `terraform apply` in the `terraform/network` folder.
Requires `terraform 0.12.xx`!

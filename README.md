# Interview exercise for ChemAxon

# 1 - Coding
The first part was a coding exercise.
The code implements the "clock mirror image" problem. It may be packaged as a docker image using the provided Dockerfile.
The compilation itself takes place in a docker container (official golang image) to make
sure the build environment is always the same. The compiled binary is then added to an
ubuntu docker image without the build tools.

Part of the exercise was to push the resulting docker image to an ECR registry.
To create an ECR repository, run `terraform apply` in the `terraform/ecr` folder.
The URL of the newly created docker registry can be viewed by running `terraform output`.

To build the docker image, run build.sh with the image name/tag, like so (with your own ECR URL):
```
./build.sh 583709312004.dkr.ecr.eu-central-1.amazonaws.com/chemaxon:1.0.0
```

After a `docker login` to the ECR registry, we can push the image with
```
docker push 583709312004.dkr.ecr.eu-central-1.amazonaws.com/chemaxon:1.0.0
```

The compiled binary runs an HTTP server with a single endpoint: `/getTimeFromMirrorImage`.
It expects its input via query string parameters:

- `hours`
- `minutes`

The web server listens on the fixed TCP port 61023.

Example call to the HTTP endpoint:
```
curl "localhost:61023/getTimeFromMirrorImage?hours=12&minutes=03"
```

# 2 - AWS network module
The second part was to create a terraform module that can be used to deploy VPC level resources
into an AWS account.

It creates a VPC with 2 public and 2 private subnets with the corresponding internet- and NAT gateways
and route tables.
It also creates a VPC endpoint for S3 for accessing S3 buckets without leaving the AWS network.

To deploy, run `terraform apply` in the `terraform/network` folder. The code assumes `terraform 0.12.xx`!

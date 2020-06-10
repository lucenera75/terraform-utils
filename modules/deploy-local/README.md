# Deploy Fergus Lambdas with Terraform

## first you shoul have valid AWS credentials exported in your environment

there are few ways to do it, for example by activating one of your AWS profiles:
```
export AWS_PROFILE=fergus-dev
```
or just exporting your keys
```
export AWS_ACCESS_KEY_ID=************
export AWS_SECRET_ACCESS_KEY=***********
```

## you must have terraform installed
https://learn.hashicorp.com/terraform/getting-started/install.html


## play
now you can create a main.tf file under the root of your node lambda project

```
module "lambda-deploy" {
    source  = "app.terraform.io/roby/lambda-deploy/fergus"
    version = "0.0.1"
    name = "audit_logger"
    region     = "ap-southeast-1"
    src = "./"
    lambdavars = {
        hello1 = "ciao"
        hello2 = 1284698.55
        hello3 = "ciao2"
        hello4 = "ciao3"
    }
}
```

_lambdavars_ will be injected in the lambda variables configuration and will be available via process.env

_name_ will be the name of your lambda function

_src_ is the source of the lambda (same level of package.json)

now you can run 

### this will download the dependencies of the module and initialize .terraform state 
```
terraform init
```


### this will create and deploy the lambda in aws
```
terraform apply -auto-approve
```

### this will destroy
```
terraform destroy -auto-approve
```



### to add another policy:


### to deploy from s3:


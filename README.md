# GitHub-Actions-Terraform-Project

## 시나리오

![workflow.png](https://i.esdrop.com/d/f/bPHSKWDXdc/wlfjgQ6DRf.png)

- GitHub Actions로 AWS에 인프라를 배포하고 ECR에 컨테이너 이미지를 업로드 한다

![PR_comment.png](https://i.esdrop.com/d/f/bPHSKWDXdc/ZMCBn9p5ZP.png)

- Workflow는 PR에서 `terraform plan`, Push에서 `terraform apply` 가 이루어 진다

## 아키텍처

![architecture.png](https://i.esdrop.com/d/f/bPHSKWDXdc/c9t9Bjvhl4.png)

- 고가용성으로 설계된 WEB/WAS/DB
- WEB/WAS는 오토스케일링 그룹으로, LB와 타겟 그룹으로 연결된다
- WEB/WAS는 User Data로 ECR에 업로드한 이미지를 사용한다
- LB와 RDS는 Route 53 레코드에 등록되어 사전에 설정한 값으로 사용된다

## 구성상 이점

- WEB/WAS가 트래픽 증가로 오토스케일링이 되었을 때, 수동 작업이 필요하지 않다
    - 새로 생성된 WEB/WAS는 타겟그룹으로 LB에 연결된다
    - Route53 레코드에 LB가 등록되어, Nginx의 구성 파일을 수정하지 않아도 된다
- Route53 레코드에 DB가 등록되어, WAS는 사전 설정 DB 호스트 값을 사용할 수 있다

## 사전 생성 리소스

- 도메인
- Route53 Pulbic 호스팅 존
- AWS Secrets Manager Secret (DB용)
- 키페어

## 생성 리소스

```jsx
|---module
|       |---network
|       |       |---aws_eip
|       |       |       |---nat[0](+)
|       |       |       |---nat[1](+)
|       |       |---aws_internet_gateway
|       |       |       |---this(+)
|       |       |---aws_nat_gateway
|       |       |       |---this[0](+)
|       |       |       |---this[1](+)
|       |       |---aws_route
|       |       |       |---public_internet_gateway(+)
|       |       |       |---web_nat_gateway[0](+)
|       |       |       |---web_nat_gateway[1](+)
|       |       |---aws_route_table
|       |       |       |---public(+)
|       |       |       |---web[0](+)
|       |       |       |---web[1](+)
|       |       |---aws_route_table_association
|       |       |       |---db[0](+)
|       |       |       |---db[1](+)
|       |       |       |---public[0](+)
|       |       |       |---public[1](+)
|       |       |       |---was[0](+)
|       |       |       |---was[1](+)
|       |       |       |---web[0](+)
|       |       |       |---web[1](+)
|       |       |---aws_subnet
|       |       |       |---db[0](+)
|       |       |       |---db[1](+)
|       |       |       |---private_lb[0](+)
|       |       |       |---private_lb[1](+)
|       |       |       |---public[0](+)
|       |       |       |---public[1](+)
|       |       |       |---was[0](+)
|       |       |       |---was[1](+)
|       |       |       |---web[0](+)
|       |       |       |---web[1](+)
|       |       |---aws_vpc
|       |       |       |---main(+)
|       |---web
|       |       |---aws_autoscaling_group
|       |       |       |---web(+)
|       |       |---aws_launch_template
|       |       |       |---web(+)
|       |       |---aws_security_group
|       |       |       |---web(+)
|       |---was
|       |       |---aws_autoscaling_group
|       |       |       |---was(+)
|       |       |---aws_launch_template
|       |       |       |---was(+)
|       |       |---aws_security_group
|       |       |       |---was(+)
|       |---db
|       |       |---aws_db_instance
|       |       |       |---postgres(+)
|       |       |---aws_db_subnet_group
|       |       |       |---this(+)
|       |       |---aws_security_group
|       |       |       |---db(+)
|       |---private_lb
|       |       |---aws_lb
|       |       |       |---private(+)
|       |       |---aws_lb_listener
|       |       |       |---app(+)
|       |       |---aws_lb_target_group
|       |       |       |---was(+)
|       |       |---aws_security_group
|       |       |       |---private_lb(+)
|       |---public_lb
|       |       |---aws_lb
|       |       |       |---public(+)
|       |       |---aws_lb_listener
|       |       |       |---http(+)
|       |       |       |---https(+)
|       |       |---aws_lb_target_group
|       |       |       |---web(+)
|       |       |---aws_security_group
|       |       |       |---public_lb(+)
|       |---route53
|       |       |---aws_route53_record
|       |       |       |---private_lb(+)
|       |       |       |---public_lb(+)
|       |       |---aws_route53_zone
|       |       |       |---private(+)
|       |---iam
|       |       |---aws_iam_instance_profile
|       |       |       |---this(+)
|       |       |---aws_iam_policy
|       |       |       |---ecr_policy(+)
|       |       |---aws_iam_role
|       |       |       |---ec2_role(+)
|       |       |---aws_iam_role_policy_attachment
|       |       |       |---ec2_role(+)
```

## 수동 작업

- RDS는 AWS-managed VPC에 생성되므로 hosted_zone ID가 달라 자동으로 레코드에 등록할 수 없다. 수동으로 Route53 레코드를 등록해야 한다

## 예상 비용

```jsx
Project: DevOps-Pipeline-Tools/deploy-terraform/joo\terraform\plan.json

 Name                                                            Monthly Qty  Unit                  Monthly Cost 

 module.db.aws_db_instance.postgres
 ├─ Database instance (on-demand, Multi-AZ, db.t3.micro)               730  hours                       $40.88   
 └─ Storage (general purpose SSD, gp2)                                  10  GB                           $2.76   

 module.network.aws_nat_gateway.this[0]
 ├─ NAT gateway                                                        730  hours                       $43.07   
 └─ Data processed                                        Monthly cost depends on usage: $0.059 per GB           

 module.network.aws_nat_gateway.this[1]
 ├─ NAT gateway                                                        730  hours                       $43.07
 └─ Data processed                                        Monthly cost depends on usage: $0.059 per GB

 module.private_lb.aws_lb.private
 ├─ Application load balancer                                          730  hours                       $16.43
 └─ Load balancer capacity units                          Monthly cost depends on usage: $5.84 per LCU

 module.public_lb.aws_lb.public
 ├─ Application load balancer                                          730  hours                       $16.43
 └─ Load balancer capacity units                          Monthly cost depends on usage: $5.84 per LCU

 module.route53.aws_route53_record.private_lb
 ├─ Standard queries (first 1B)                           Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)              Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                            Monthly cost depends on usage: $0.70 per 1M queries

 module.route53.aws_route53_record.public_lb
 ├─ Standard queries (first 1B)                           Monthly cost depends on usage: $0.40 per 1M queries
 ├─ Latency based routing queries (first 1B)              Monthly cost depends on usage: $0.60 per 1M queries
 └─ Geo DNS queries (first 1B)                            Monthly cost depends on usage: $0.70 per 1M queries

 module.route53.aws_route53_zone.private
 └─ Hosted zone                                                          1  months                       $0.50

 module.was.aws_autoscaling_group.was
 └─ module.was.aws_launch_template.was
    └─ Instance usage (Linux/UNIX, on-demand, t3.micro)              1,460  hours                       $18.98

 module.web.aws_autoscaling_group.web
 └─ module.web.aws_launch_template.web
    └─ Instance usage (Linux/UNIX, on-demand, t3.micro)              1,460  hours                       $18.98

 OVERALL TOTAL                                                                                           $201.09
──────────────────────────────────
55 cloud resources were detected:
∙ 10 were estimated, 9 of which include usage-based costs, see https://infracost.io/usage-file
∙ 45 were free, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                                        ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ DevOps-Pipeline-Tools/deploy-terraform/joo\terraform\plan.json ┃ $201         ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
```

- NAT Gateway 하나가 $43로 RDS 인스턴스와 맞먹는 가격임을 알 수 있다.
- LB는 $16로 생각보다 저렴하였다.
- 한달 $200 정도로 작은 웹 서비스 하나를 고가용성으로 운영할 수 있다!

## 코드

- Nginx

```jsx
# joo/build-image/nginx/Dockerfile

FROM nginx:1.25.3
COPY nginx.conf /etc/nginx/nginx.conf
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
```

```jsx
# joo/build-image/nginx/nginx.config

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {

    # NGINX will handle gzip compression of responses from the app server
    gzip on;
    gzip_proxied any;
    gzip_types text/plain application/json;
    gzip_min_length 1000;

    upstream app {
        server lb.joo.com;
    }

    server {
        listen 80;
        server_name app.juiceb7597.com;

        location / {
            proxy_pass http://app;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_cache_bypass $http_upgrade;
        }
    }
}
```

- Terraform

```jsx
# joo/terraform/terraform.tfvars

################################################################################
# Common
################################################################################

name = "joo"
# 비용 관리를 위해 모든 리소스에 추가할 태그
tags = { "owner" : "joo" } 

################################################################################
# Network
################################################################################

azs                    = ["ap-northeast-2a", "ap-northeast-2c"]
cidr                   = "10.0.0.0/16"
public_subnet_cidr     = ["10.0.0.0/24", "10.0.10.0/24"]
web_subnet_cidr        = ["10.0.20.0/24", "10.0.30.0/24"]
private_lb_subnet_cidr = ["10.0.40.0/24", "10.0.50.0/24"]
was_subnet_cidr        = ["10.0.60.0/24", "10.0.70.0/24"]
db_subnet_cidr         = ["10.0.80.0/24", "10.0.90.0/24"]

################################################################################
# Public/Private LB
################################################################################

load_balancer_type = "application"
public_lb_sg_ports = {
  https = "443"
}

private_lb_sg_ports = {
  app = "80"
}

################################################################################
# WEB/WAS
################################################################################

instance_type             = "t3.micro"
key_name                  = "juiceb"
wait_for_capacity_timeout = "5m"
health_check_type         = "EC2"
health_check_grace_period = 300
min_size                  = 2
max_size                  = 4
desired_capacity          = 2

web_sg_ports = {
  http  = "80"
  https = "443"
}

was_sg_ports = {
  app = "8000"
}

################################################################################
# DB
################################################################################

engine            = "postgres"
engine_version    = "15.3"
instance_class    = "db.t3.micro"
multi_az          = true
allocated_storage = 10

db_sg_ports = {
  postgresql = "5432"
}
```

- GitHub Actions Workflow - ECR

```jsx
# .github/workflows/build-nginx.yml

name: Build Nginx Image to AWS ECR
on:
  push:
    branches: [ main ]
    paths: 
      - 'joo/build-image/nginx/*'
      - '.github/workflows/build-nginx.yml'

jobs:
  build: 
    permissions: 
      id-token: write
      contents: read
      pull-requests: write
    environment: joo
    defaults:
      run:
        working-directory: ./joo/build-image/nginx
    runs-on: ubuntu-latest
    steps:
    - name: Checkout tf code in runner environment 
      uses: actions/checkout@v4

    - name: Configure AWS Credentials Action For GitHub Actions
      uses: aws-actions/configure-aws-credentials@v4
      with: 
        role-to-assume: ${{ secrets.AWS_ROLE }}
        aws-region: us-east-1

    - name: Login to Amazon ECR Public
      id: login-ecr-public
      uses: aws-actions/amazon-ecr-login@v2
      with:
        registry-type: public

    - name: Build, tag, and push docker image to Amazon ECR Public
      env:
        REGISTRY: ${{ steps.login-ecr-public.outputs.registry }}
        REGISTRY_ALIAS: ${{ secrets.ECR_ALIAS }}
        REPOSITORY: nginx
        IMAGE_TAG: 0.1
      run: |
        docker build -t $REGISTRY/$REGISTRY_ALIAS/$REPOSITORY:$IMAGE_TAG .
        docker push $REGISTRY/$REGISTRY_ALIAS/$REPOSITORY:$IMAGE_TAG
```

- GitHub Actions Workflow - Terraform

```jsx
# .github/workflows/deploy-infra.yml

name: Terraform AWS Workflow
on:
  push:
    branches: [ main ]
    paths: 
      - 'joo/terraform/**'
      - '.github/workflows/deploy-infra.yml'
  pull_request:
    branches: [ main ]
    paths: 
      - 'joo/terraform/**'
      - '.github/workflows/deploy-infra.yml'

jobs:
  tf_code_check: 
    permissions: 
      id-token: write
      contents: read
      pull-requests: write
    environment: joo
    defaults:
      run:
        working-directory: ./joo/terraform
    runs-on: ubuntu-latest
    steps:
    - name: Checkout tf code in runner environment 
      uses: actions/checkout@v4

    - name: Configure AWS Credentials Action For GitHub Actions
      uses: aws-actions/configure-aws-credentials@v4
      with: 
        role-to-assume: ${{ secrets.AWS_ROLE }}
        aws-region: ap-northeast-2
        
    - name: Setup Terraform CLI
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: "1.6.2"

    - name: Terraform init
      id: init
      run: terraform init

    - name: Terraform fmt
      id: fmt
      run: terraform fmt -check
      continue-on-error: true

    - name: Terraform validate
      id: validate
      run: terraform validate -no-color
      
    - name: Terraform plan 
      id: plan
      if: github.event_name == 'pull_request'
      run: terraform plan

    - name: PR Comment
      uses: actions/github-script@v6
      if: github.event_name == 'pull_request'
      env:
        PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
      with: 
        github-token: ${{ secrets.GITHUB_TOKEN }}
        script: |
         const output = `## 테라폼 구축 계획
          #### terraform init ⚙️\`${{ steps.init.outcome }}\`
          #### terraform fmt 🖌\`${{ steps.fmt.outcome }}\`
          #### terraform validate 🤖\`${{ steps.validate.outcome }}\`
          <details><summary>문법 검사 결과</summary>

          \`\`\`\n
          ${{ steps.validate.outputs.stdout }}
          \`\`\`

          </details>

          #### terraform plan 📖\`${{ steps.plan.outcome }}\`

          <details><summary>테라폼 구축 계획</summary>

          \`\`\`\n
          ${process.env.PLAN}
          \`\`\`

          </details>

          **위의 내용으로 테라폼 배포를 요청합니다!**

          *Pusher: @${{ github.actor }}, Action: \`${{ github.event_name }}\`, Working Directory: \`${{ env.tf_actions_working_dir }}\`, Workflow: \`${{ github.workflow }}\`*`;

          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: output
          })
    - name: Terraform Apply 
      if: github.event_name == 'push'
      run: terraform apply -auto-approve
```

## 배포에 성공한 모습!

![app.png](https://i.esdrop.com/d/f/bPHSKWDXdc/1FP4dx56Ko.png)
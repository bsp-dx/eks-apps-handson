# tfmodule-aws-ecs

AWS ECS 컨테이너 오케스트레이션 서비스를 구성 하는 테라폼 모듈 입니다.

## [ECS](https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/Welcome.html)
ECS 는 AWS 의 다양한 서비스(기능)들과 통합과 빠르고 쉽게 구성이 가능합니다.

컨테이너 오케스트레이션 도구로는 AWS 이외에도 Docker Swarm, Kubernetes, 하시코프의 Nomad 등 오픈소스가 있습니다.

### [Fargate 시작 유형](https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/launch_types.html)
Fargate 시작 유형은 프로비저닝 없이 컨테이너화된 애플리케이션을 실행하고 백엔드 인프라를 관리할 때 사용할 수 있습니다. AWS Fargate은 서버리스 방식으로 Amazon ECS 워크로드를 호스팅할 수 있습니다.
![ECS Fargate](https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/images/overview-fargate.png)

### [EC2 시작 유형](https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/launch_types.html)
EC2 시작 유형은 Amazon ECS 클러스터를 등록하고 직접 관리하는 Amazon EC2 인스턴스에서 컨테이너화된 애플리케이션을 실행하는 데 사용할 수 있습니다.
![ECS EC2](https://docs.aws.amazon.com/ko_kr/AmazonECS/latest/developerguide/images/overview-standard.png)



## Example

ECS 구성 예시

```
module "ecs" {
  source = "../tfmodule-aws-ecs"
  
  image_names = ["sample-golang-service", "sample-spring-boot-service"]
  
  principals_full      = ["YOUR_AWS_ROLE_OR_USER_IAM_ARN"] # "*" is ALL
  principals_readonly  = ["*"]
  image_tag_mutability = "IMMUTABLE"
  scan_images_on_push  = true
  
  tags        = {
    Project     = "simple"
    Environment = "Test"
    Team        = "DX"
    Owner       = "symplesims@email.com"
  }
  
}
```

## Input Variables

| Name | Description | Type | Example | Required |
|------|-------------|------|---------|:--------:|
| capacity_providers | capacity providers 는 작업 및 서비스를 실행하는 데 필요한 가용성, 확장성 및 비용을 개선합니다. 유효한 capacity provider 는 FARGATE 및 FARGATE_SPOT 입니다. | list(string) | ["FARGATE", "FARGATE_SPOT"] | No |
| default_capacity_provider_strategy | 클러스터에 기본적으로 사용할 capacity_providers 전략입니다. | list(map(any)) | {} | No |
| enable_lifecycle_policy | 리포지토리에 수명 주기 정책의 추가 여부를 설정 합니다. | bool | false| No |
| scan_images_on_push | 이미지가 저장소로 푸시된 후 스캔 여부를 설정 합니다. | bool | true| No |
| principals_full     | ECR 저장소의 전체 액세스 권한을 가지는 IAM 리소스 ARN 입니다. | list(string) | ["arn:aws:iam::111111:user/apple_arn","arn:aws:iam::111111:role/admin_arn"] | No |
| principals_readonly | ECR 저장소의 읽기 전용 IAM 리소스 ARN 입니다. | list(string) | ["*"] | No |
| tags | ECR 저장소의 태그 속성을 정의 합니다. | obejct({}) | <pre>{<br>    Project = "simple"<br>    Environment = "Test"<br>    Team = "DX"<br>    Owner = "symplesims@email.com"<br>}</pre> | Yes |

 

variable "name" {
description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
type        = string
default     = null
}


variable "default_capacity_provider_strategy" {
description = "The capacity provider strategy to use by default for the cluster. Can be one or more."
type        = list(map(any))
default     = []
}

variable "container_insights" {
description = "Controls if ECS Cluster has container insights enabled"
type        = bool
default     = false
}

variable "tags" {
description = "A map of tags to add to ECS Cluster"
type        = map(string)
default     = {}
}

## Output Values

| Name | Description | Example |  
|------|-------------|---------| 
| repository_url_map | ECR 리포지토리 저장소 이름 및 URL 정보 입니다. | <pre>repository_url_map = {<br>  "sample-golang-service" = "11111111.ecr.REGION.amazonaws.com/sample-golang-service"<br>  "sample-spring-service" = "11111111.ecr.REGION.amazonaws.com/sample-spring-service"<br>}</pre> |
| repository_arn_map | ECR 리포지토리 리소스의 이름 및 ARN 식별자 정보 입니다. | <pre>repository_arn_map = {<br>  sample-golang-service = "arn:aws:ecr:REGION:ACCOUNT:repository/sample-golang-service"<br>  sample-spring-service = "arn:aws:ecr:REGION:ACCOUNT:repository/sample-spring-service"<br>}</pre> |

## ECR Access

"sample-golang-service" 저장소를 생성 했다고 가정 하면 ECR 토큰을 취득하여 Docker 를 통한 로그인 및 이미지를 push 및 pull 할 수 있습니다.

### docker login

AWS ECR 저장소에 Docker 를 통한 로그인 합니다.  
ECR_IMAGE_URI 환경 변수를 설정 합니다. 형식은 아래와 같습니다.

```
<AWS_ACCOUNT>.dkr.ecr.<AWS_REGION>.amazonaws.com/<ECR_IMAGE_NAME>
```

ECR access-token 값 조회 및 Docker 로그인

```
# export ECR_IMAGE_URI=<YOUR_ECR_REPOSITORY_URI>
export ECR_IMAGE_URI=827519537363.dkr.ecr.ap-northeast-2.amazonaws.com/sample-golang-service
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${ECR_IMAGE_URI}
```

### image push

로컬에 있는 docker 이미지를 ECR 저장소에 업로드(push) 합니다.  
업로드 하기 위해선 먼저 도커 이미지 이름과 태그 정보를 ECR_IMAGE_URI 환경 변수에 맞게 변경 해야 합니다.

```
docker tag sample-golang-service:1.0.0 ${ECR_IMAGE_URI}:1.0.0
docker push ${ECR_IMAGE_URI}:1.0.0
```

### image pull

AWS ECR 저장소의 도커 이미지를 로컬로 다운로드(pull) 합니다.

```
docker pull ${ECR_IMAGE_URI}:1.0.0
```

### AWS CLI 를 통한 이미지 조회

```
aws ecr list-images --repository-name sample-golang-service
```


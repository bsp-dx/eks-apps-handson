# ECR

AWS ECR 프라이빗 저장소를 생성 합니다.

## Example

ERC 테라폼 모듈을 통해 AWS ECR 프라이빗 저장소를 생성하는 예시 입니다.

```
module "ctx" {
  source = "../context"
}

module "ecr" {
  source = "../tfmodule-aws-ecr"
  
  image_names = ["sample-golang-service", "sample-spring-boot-service"]
  
  principals_full      = ["YOUR_AWS_ROLE_OR_USER_IAM_ARN"] # "*" is ALL
  principals_readonly  = ["*"]
  image_tag_mutability = "IMMUTABLE"
  scan_images_on_push  = true
  
  tags                 = module.ctx.tags
  
}
```


## Input Variables

| Name | Description | Type | Example | Required |
|------|-------------|------|---------|:--------:|
| image_names | AWS ECR 프라이빗 리포지토리 이름으로 사용되는 Docker 이미지 이름을 정의합니다. | list(string) | [""] | No |
| image_tag_mutability | 리포지토리에 대한 태그 변경 모드를 설정합니다. 'IMMUTABLE' 또는 'MUTABLE' 중 하나여야 합니다. | string | "IMMUTABLE"| No |
| enable_lifecycle_policy | 리포지토리에 수명 주기 정책의 추가 여부를 설정 합니다. | bool | false| No |
| scan_images_on_push | 이미지가 저장소로 푸시된 후 스캔 여부를 설정 합니다. | bool | true| No |
| principals_full     | ECR 저장소의 전체 액세스 권한을 가지는 IAM 리소스 ARN 입니다. | list(string) | ["arn:aws:iam::111111:user/apple_arn","arn:aws:iam::111111:role/admin_arn"] | No |
| principals_readonly | ECR 저장소의 읽기 전용 IAM 리소스 ARN 입니다. | list(string) | ["*"] | No |
| tags | ECR 저장소의 태그 속성을 정의 합니다. | obejct({}) | <pre>{<br>    Project = "simple"<br>    Environment = "Test"<br>    Team = "DX"<br>    Owner = "symplesims@email.com"<br>}</pre> | Yes |

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


# tfmodule-aws-ecr
AWS ECR 프라이빗 저장소를 생성 합니다.

## Example
ERC 테라폼 모듈을 통해 AWS ECR 프라이빗 저장소를 생성하는 예시 입니다.

```
module "ecr" {
  source = "../tfmodule-aws-ecr"
  
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


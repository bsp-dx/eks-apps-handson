# macbook-install
주요 프로그램 설치

- homebrew 설치
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- oh-my-zsh 설치
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

- 주요 오픈소스 설치
```
brew install git
```

- terraform 설치
tfswitch 명령을 통해 multiple 버전 관리 지원
```
brew install warrensbox/tap/tfswitch
tfswitch -l
terraform --version
ln -s /usr/local/bin/terraform /usr/local/bin/tf
```

- Graphviz DOT 설치
```
brew install graphviz
```

- EKS Tools 설치
```
# kubectl
https://kubernetes.io/ko/docs/tasks/tools/install-kubectl-macos/

# istoctl
https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/

# helm
brew install helm

# aws-iam-authenticator
brew install aws-iam-authenticator
```

- aws cli v2 설치
```
https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/install-cliv2.html
```

- go-lang 설치
```
brew install go
```

# ISTIO
AWS EKS 환경에서 ISTIO 서비스메시를 구성 합니다.

[aws-load-balancer-controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/) 참고 

[EKS 클러스터에 ALB Ingress Controller 구성 가이드](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/deploy/installation/#add-controller-to-cluster)
Edit file
1. Edit the saved yaml file, go to the Deployment spec, and set the controller --cluster-name arg value to your EKS cluster name
2. ServiceAccount


## Reference
- [AWSLoadBalancerControllerIAMPolicy](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/deploy/installation/#add-controller-to-cluster) 설치 가이드 참고   
  [ALBIngressControllerPolicy](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/install/iam_policy.json) 

- ㅇㅇ
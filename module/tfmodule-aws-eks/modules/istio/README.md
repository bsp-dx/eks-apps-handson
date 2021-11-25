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

- [AWS EKS Istio annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/)

- [kubernetes-sigs](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/docs/install)

- [Kubernetes AWS NLB](https://kubernetes.io/docs/concepts/services-networking/service/#aws-nlb-support)

- [AWS IRSA OIDC](https://ssup2.github.io/theory_analysis/AWS_EKS_Service_Account_IAM_Role/)

- [EKS IRSA를 활용하여 pod에 IAM 할당하기](https://wrapitup.tistory.com/3?category=878337)

- [AWS EKS Workshop](https://github.com/awskrug/eks-workshop/blob/master/content/servicemesh_with_istio/install.md)

- [AWS EKS Istio Workshop](https://awskrug.github.io/eks-workshop/servicemesh_with_istio/introduction/)


### Istio
- [install with Istioctl](https://istio.io/latest/docs/setup/install/istioctl/)
- [IstioOperator Options](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/)
- [Installation Options Value](https://istio.io/v1.5/docs/reference/config/installation-options/)
- [Manifest Profiles](https://github.com/istio/istio/tree/master/manifests/profiles)
  [Default](https://istio.io/latest/docs/setup/additional-setup/config-profiles/)

Install / Uninstall istio
```
# Install
istioctl manifest apply -f ./istio-manifests.yaml -y

# Unintall
istioctl x uninstall --purge
```

## Certificate Manager
- [Cloud Native Certificate Management](https://github.com/jetstack/cert-manager)
- [Download Certificate Management](https://github.com/jetstack/cert-manager/releases)
```
wget https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
```


## 플러그인 설치 순서
1. OIDC IAM Role
2. cert-manager
3. aws-load-balancer-controller
4. Istio core
5. Istio ingress-gateway NLB 
6. Istio ingress-controller ALB

# Inha Capstone Infrastructure

이 디렉토리는 Terraform을 사용하여 AWS 인프라를 관리합니다. Terraform Workspace를 활용하여 prod와 dev 환경을 분리합니다.

## 인프라 구성

- **EC2 인스턴스 3개**
  - MongoDB 전용 인스턴스 (t3.xlarge, 30GB)
  - Elasticsearch & Monstache 인스턴스 (t3.xlarge, 50GB)
  - 애플리케이션 서버 + PostgreSQL (t3.medium, 30GB)
- **공통 리소스 (환경별 공유)**
  - VPC, Security Group, IAM Instance Profile, Key Pair


## Terraform Workspace

Terraform Workspace를 사용하여 동일한 코드로 여러 환경을 관리합니다.

### 환경 구분
- **prod (default)**: 운영 환경
- **dev**: 개발 환경

> **참고**: `default` workspace는 자동으로 `prod` 환경으로 매핑됩니다.

### Workspace 명령어

```bash
# 현재 workspace 확인
terraform workspace show

# 사용 가능한 workspace 목록
terraform workspace list

# dev workspace 생성
terraform workspace new dev

# workspace 전환
terraform workspace select dev     # dev 환경으로 전환
terraform workspace select default # prod 환경으로 전환

# workspace 삭제 (주의: 리소스를 먼저 destroy 해야 함)
terraform workspace delete dev
```

## 배포 가이드

### 사전 요구 사항

1. **Terraform 설치**: v1.0 이상
2. **AWS 자격증명 설정**: AWS CLI 또는 환경 변수로 설정
3. **필요한 리소스**:
   - VPC: `vpc-0a8e611b221cddec6`
   - Security Group: `sg-08b23a1e6bd2bbd1d`
   - Key Pair: `capstone-02`
   - IAM Instance Profile: `SafeInstanceProfileForUser-inha-capstone-02`

### Prod 환경 배포

현재 운영 중인 환경입니다. **주의해서 작업하세요.**

```bash
# 1. default workspace 사용 (prod로 매핑됨)
terraform workspace select default

# 2. 초기화 (처음 한 번만)
terraform init

# 3. 변경 사항 확인
terraform plan

# 4. 적용 (필요한 경우만)
terraform apply
```

### Dev 환경 배포

```bash
# 1. dev workspace 생성 (처음 한 번만)
terraform workspace new dev

# 또는 기존 workspace로 전환
terraform workspace select dev

# 2. 변경 사항 확인
terraform plan

# 3. 적용
terraform apply

# 4. 생성된 리소스 확인
terraform output
```

### 리소스 정리

```bash
# dev 환경 삭제
terraform workspace select dev
terraform destroy

# workspace 삭제 (리소스가 모두 삭제된 후)
terraform workspace select default
terraform workspace delete dev
```

## 리소스 Naming Convention

환경별로 다음과 같이 리소스 이름이 생성됩니다:

- **형식**: `{project_name}_{environment}_{resource_type}`
- **예시**:
  - Prod (default): `capstone_02_prod_mongodb_ec2`, `capstone_02_prod_server_ec2`, `capstone_02_prod_es_ec2`
  - Dev: `capstone_02_dev_mongodb_ec2`, `capstone_02_dev_server_ec2`, `capstone_02_dev_es_ec2`


## 환경별 차이점

### 공통 설정 (모든 환경 동일)
- VPC, Security Group, Key Pair
- IAM Instance Profile
- 인스턴스 타입 (Server: t3.medium, MongoDB: t3.xlarge, ES: t3.xlarge)
- 볼륨 크기 (Server/MongoDB: 30GB, ES: 50GB)
- 데이터베이스 자격증명


### 환경별 차이
- **EC2 인스턴스 이름**: workspace에 따라 자동 생성
- **Docker 컨테이너 이름**: `mongodb_{environment}`, `postgres_{environment}`
- **Docker 네트워크**: `inha-network-{environment}`
- **Environment 태그**: 각 리소스에 환경 태그 추가

## Outputs

배포 후 다음 정보를 확인할 수 있습니다:

```bash
terraform output

# 출력 예시:
# mongodb_public_dns = "ec2-xx-xx-xx-xx.us-west-2.compute.amazonaws.com"
# mongodb_public_ip = "xx.xx.xx.xx"
# server_public_dns = "ec2-xx-xx-xx-xx.us-west-2.compute.amazonaws.com"
# server_public_ip = "xx.xx.xx.xx"
# es_public_dns = "ec2-xx-xx-xx-xx.us-west-2.compute.amazonaws.com"
# es_public_ip = "xx.xx.xx.xx"
```


## 주의사항

1. **Prod 환경 보호**: default workspace(prod)에서 작업 시 매우 신중하게 진행하세요.
2. **비용**: 각 환경마다 EC2 인스턴스 3개가 생성되어 비용이 발생합니다.
3. **State 관리**: 각 workspace는 별도의 state 파일을 유지합니다.
4. **리소스 충돌**: 동일한 workspace에서 여러 번 apply하면 리소스가 중복 생성되지 않습니다.


## 검증

배포 후 리소스가 정상적으로 생성되었는지 확인하세요:

### AWS 콘솔 확인
1. EC2 콘솔에서 인스턴스 확인
2. 인스턴스 이름에 환경이 포함되어 있는지 확인 (`capstone_02_{environment}_*`)
3. Environment 태그 확인

### SSH 접속 확인
```bash
# MongoDB 인스턴스
ssh -i capstone-02.pem ubuntu@<mongodb-public-ip>
docker ps  # mongodb_{environment} 컨테이너 확인

# Server 인스턴스
ssh -i capstone-02.pem ubuntu@<server-public-ip>
docker ps  # postgres_{environment} 컨테이너 확인
```

## 문제 해결

### Workspace 관련
```bash
# workspace 생성 실패 시
terraform workspace list  # 이미 존재하는지 확인

# state lock 에러 시
# AWS DynamoDB에서 lock을 수동으로 해제하거나 잠시 후 재시도
```

### 리소스 생성 실패
```bash
# 자세한 로그 확인
TF_LOG=DEBUG terraform apply

# 특정 리소스만 재생성
terraform taint aws_instance.mongodb_ec2
terraform apply
```

## 변수 커스터마이징

필요시 `variables.tf`의 default 값을 변경하거나, 명령줄에서 오버라이드할 수 있습니다:

```bash
# 인스턴스 타입 변경
terraform apply -var="mongodb_instance_type=t3.small"

# 프로젝트 이름 변경
terraform apply -var="project_name=my_project"
```

## TODO

- [ ] SSM
- [ ] NAT Gateway and change to private subnet

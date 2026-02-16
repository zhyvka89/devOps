# Terraform AWS Infrastructure

Цей проєкт демонструє побудову базової AWS-інфраструктури за допомогою Terraform з використанням модульного підходу.

Інфраструктура включає:
- Remote backend для Terraform state (S3 + DynamoDB)
- Мережеву інфраструктуру (VPC, public/private subnets, NAT Gateway)
- ECR (Elastic Container Registry) для зберігання Docker-образів
- EKS для Kubernetes кластера (EKS + Node Group)
- AWS RDS instance або Amazon Aurora Cluster залежно від параметра `use_aurora` 
- Helm для встановлення Jenkins та Argo CD
- Jenkins для CI (build + push Docker image)
- Argo CD для GitOps-деплою в Kubernetes
- Grafana для моніторингу метрик

---

## 📁 Структура проєкту

```
lesson-8-9/
│
├── main.tf         # Головний файл для підключення модулів
├── backend.tf        # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf        # Загальні виводи ресурсів
│
├── modules/         # Каталог з усіма модулями
│  ├── s3-backend/     # Модуль для S3 та DynamoDB
│  │  ├── s3.tf      # Створення S3-бакета
│  │  ├── dynamodb.tf   # Створення DynamoDB
│  │  ├── variables.tf   # Змінні для S3
│  │  └── outputs.tf    # Виведення інформації про S3 та DynamoDB
│  │
│  ├── vpc/         # Модуль для VPC
│  │  ├── vpc.tf      # Створення VPC, підмереж, Internet Gateway
│  │  ├── routes.tf    # Налаштування маршрутизації
│  │  ├── variables.tf   # Змінні для VPC
│  │  └── outputs.tf  
│  ├── ecr/         # Модуль для ECR
│  │  ├── ecr.tf      # Створення ECR репозиторію
│  │  ├── variables.tf   # Змінні для ECR
│  │  └── outputs.tf    # Виведення URL репозиторію
│  │
│  ├── eks/           # Модуль для Kubernetes кластера
│  │  ├── eks.tf        # Створення кластера
│  │  ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│  │  ├── variables.tf   # Змінні для EKS
│  │  └── outputs.tf    # Виведення інформації про кластер
│  │
│  ├── rds/         # Модуль для RDS
│  │  ├── rds.tf      # Створення RDS бази даних  
│  │  ├── aurora.tf    # Створення aurora кластера бази даних  
│  │  ├── shared.tf    # Спільні ресурси  
│  │  ├── variables.tf   # Змінні (ресурси, креденшели, values)
│  │  └── outputs.tf  
│  │ 
│  ├── jenkins/       # Модуль для Helm-установки Jenkins
│  │  ├── jenkins.tf    # Helm release для Jenkins
│  │  ├── variables.tf   # Змінні (ресурси, креденшели, values)
│  │  ├── providers.tf   # Оголошення провайдерів
│  │  ├── values.yaml   # Конфігурація jenkins
│  │  └── outputs.tf    # Виводи (URL, пароль адміністратора)
│  │ 
│  └── argo_cd/       # Mодуль для Helm-установки Argo CD
│    ├── jenkins.tf    # Helm release для Jenkins
│    ├── variables.tf   # Змінні (версія чарта, namespace, repo URL тощо)
│    ├── providers.tf   # Kubernetes+Helm. переносимо з модуля jenkins
│    ├── values.yaml   # Кастомна конфігурація Argo CD
│    ├── outputs.tf    # Виводи (hostname, initial admin password)
│		  └──charts/         # Helm-чарт для створення app'ів
│ 	 	  ├── Chart.yaml
│	 	  ├── values.yaml     # Список applications, repositories
│			  └── templates/
│		    ├── application.yaml
│		    └── repository.yaml
├── charts/
│  └── django-app/
│    ├── templates/
│    │  ├── deployment.yaml
│    │  ├── service.yaml
│    │  ├── configmap.yaml
│    │  └── hpa.yaml
│    ├── Chart.yaml
│    └── values.yaml   # ConfigMap зі змінними середовища
├──Django
│			 ├── core\
│			 ├── Dockerfile
│			 ├── Jenkinsfile
│      ├── manage.py
│      ├── requirements.txt
│			 └── docker-compose.yaml
└──README.md            # Документація проєкту
```


## ⚙️ Використання Terraform

**1️⃣ Ініціалізація Terraform**

`terraform init`

Ініціалізує Terraform, завантажує провайдери та налаштовує backend.

**2️⃣ Перевірка плану змін**

`terraform plan`

Показує, які ресурси будуть створені, змінені або видалені.

**3️⃣ Створення інфраструктури**

`terraform apply`

Застосовує конфігурацію та створює ресурси в AWS.

**4️⃣ Видалення інфраструктури**

`terraform destroy`

Видаляє всі ресурси, створені Terraform.



## 🐳 Docker та ECR

### Отримання ECR URL та логін

```bash
terraform output -raw ecr_repository_url
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <registry-id>.dkr.ecr.eu-central-1.amazonaws.com
```

### Збірка Docker-образу Django

```bash
docker build -t django-app:v1 .
```

### Push образу в Amazon ECR

```bash
docker tag django-app:v1 <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/django-app:v1
docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/django-app:v1
```


## ☸ Kubernetes та Helm

### Деплой застосунку

```bash
helm install django-app ./charts/django-app
```

Або оновлення:

```bash
helm upgrade django-app ./charts/django-app
```

### Перевірка подів

```bash
kubectl get pods
```

Очікуваний результат — pod у статусі **Running**.


## ⚙️ ConfigMap та змінні середовища

Змінні середовища Django винесені в **ConfigMap**:

- **ALLOWED_HOSTS**

- інші параметри застосунку

ConfigMap підключається до Deployment через **envFrom**.


## 🌐 Доступ до застосунку

Застосунок доступний ззовні через Service типу **LoadBalancer**.

```bash
kubectl get svc django-app
```

У браузері відкривається URL типу:

```
http://<external-load-balancer-url>
```


## Як перевірити Jenkins

### 1. Перевірити namespace

```bash
kubectl get ns | findstr jenkins
```

### 2. Перевірити поди Jenkins

```bash
kubectl get pods -n jenkins
```

### 3. Отримати адресу Jenkins

```bash
kubectl get svc -n jenkins
```

У колонці EXTERNAL-IP буде URL Jenkins.



## Як побачити результат в Argo CD

### 1. Перевірити namespace Argo CD

```bash
kubectl get ns | findstr argocd
```

### 2. Перевірити поди

```bash
kubectl get pods -n argocd
```

### 3. Отримати Argo CD URL

```bash
kubectl get svc -n argocd
```

### 4. Логін в Argo CD

Логін:
**username**: admin
**password**: 

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
```

## Моніторинг та перевірка метрик в Grafana

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
# Lesson 7 — Kubernetes (EKS) + Django Application

## 📌 Опис завдання

Метою цього домашнього завдання є розгортання Django-застосунку у кластері Kubernetes (Amazon EKS), створеному за допомогою Terraform, з використанням Helm для деплою та ConfigMap для керування змінними середовища.

У межах роботи реалізовано:
- інфраструктуру AWS (S3, DynamoDB, VPC, ECR, EKS),
- контейнеризацію Django-застосунку,
- збереження Docker-образу в ECR,
- деплой застосунку в Kubernetes через Helm,
- використання ConfigMap для змінних середовища.

---

## 🗂 Структура проєкту

```
lesson-7/
│
├── main.tf # Головний Terraform файл
├── backend.tf # Backend для Terraform state (S3 + DynamoDB)
├── outputs.tf # Вивід ресурсів
│
├── modules/
│ ├── s3-backend/ # S3 + DynamoDB для Terraform state
│ ├── vpc/ # Мережева інфраструктура (VPC, Subnets, NAT, IGW)
│ ├── ecr/ # Elastic Container Registry
│ └── eks/ # Kubernetes кластер (EKS + Node Group)
│
├── charts/
│ └── django-app/ # Helm chart для Django-застосунку
│ ├── templates/
│ │ ├── deployment.yaml
│ │ ├── service.yaml
│ │ ├── configmap.yaml
│ │ └── hpa.yaml
│ ├── Chart.yaml
│ └── values.yaml
```

---

## 🚀 Кроки розгортання

### 1️⃣ Ініціалізація Terraform

```bash
terraform init
```

### 2️⃣ Перевірка плану

```bash
terraform plan
```

### 3️⃣ Створення інфраструктури

```bash
terraform apply
```

У результаті створюються:

- S3 bucket і DynamoDB table для Terraform state,

- VPC з публічними та приватними підмережами,

- ECR репозиторій,

- Kubernetes кластер Amazon EKS з Node Group.


## 🐳 Docker та ECR

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


## 📈 Масштабування

Реалізовано Horizontal Pod Autoscaler (HPA):

- мінімум: 2 pod’и

- максимум: 6 pod’ів

- масштабування при CPU > 70%

(Для Free Tier допускається робота з 1 pod через обмеження ресурсів.)


## 🧹 Видалення інфраструктури

```bash
terraform destroy
```
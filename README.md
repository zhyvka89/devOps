# Lesson 8–9: CI/CD with Jenkins, Helm, Terraform and Argo CD

## Опис проєкту

Цей проєкт демонструє повний CI/CD-процес у Kubernetes (AWS EKS) з використанням:

- **Terraform** — для створення інфраструктури
- **Helm** — для встановлення Jenkins та Argo CD
- **Jenkins** — для CI (build + push Docker image)
- **Amazon ECR** — для зберігання Docker-образів
- **Argo CD** — для GitOps-деплою в Kubernetes

---

## Структура проєкту

```
lesson-8-9/
├── main.tf
├── backend.tf
├── outputs.tf
├── modules/
│ ├── s3-backend/
│ ├── vpc/
│ ├── ecr/
│ ├── eks/
│ ├── jenkins/
│ └── argo_cd/
├── charts/
│ └── django-app/
```

##  Як застосувати Terraform

### 1. Ініціалізація Terraform

```bash
terraform init -reconfigure
```

### 2. Перевірка плану

```bash
terraform plan
```

### 3. Застосування

```bash
terraform apply
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

### 4. Jenkins pipeline

Pipeline реалізований через **Jenkinsfile** та виконує:

- Збірку Docker-образу Django

- Пуш образу в Amazon ECR

- Оновлення values.yaml Helm-чарту

- Пуш змін у гілку main

Для перевірки:

- Відкрити Jenkins UI

- Запустити job

- Переконатися, що build завершився успішно


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


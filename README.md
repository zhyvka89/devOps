# Lesson 5 – Terraform AWS Infrastructure

Цей проєкт демонструє побудову базової AWS-інфраструктури за допомогою Terraform з використанням модульного підходу.

Інфраструктура включає:
- Remote backend для Terraform state (S3 + DynamoDB)
- Мережеву інфраструктуру (VPC, public/private subnets, NAT Gateway)
- ECR (Elastic Container Registry) для зберігання Docker-образів

---

## 📁 Структура проєкту

```
lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування remote backend (S3 + DynamoDB)
├── outputs.tf               # Загальні outputs
│
├── modules/
│   ├── s3-backend/          # Модуль для Terraform backend
│   │   ├── s3.tf            # S3 bucket для state
│   │   ├── dynamodb.tf      # DynamoDB для state locking
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vpc/                 # Модуль для мережевої інфраструктури
│   │   ├── vpc.tf           # VPC, subnets, IGW, NAT
│   │   ├── routes.tf        # Route tables та маршрути
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # ECR repository та policy
│       ├── variables.tf
│       └── outputs.tf
│
└── README.md                # Документація проєкту
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

## 🧩 Опис модулів
**🔹 S3-backend**

Модуль відповідає за зберігання Terraform state:
1. S3 bucket з:
 - versioning
 - server-side encryption
 - забороною публічного доступу
2.  DynamoDB таблиця для state locking
  
Використовується як remote backend для Terraform.

**🔹 VPC**

Модуль створює мережеву інфраструктуру:

- VPC з заданим CIDR
- 3 public subnet
- 3 private subnet
- Internet Gateway для public subnet
- NAT Gateway для private subnet
- Route tables та маршрутизацію

Забезпечує ізоляцію приватних ресурсів і доступ до інтернету.

**🔹 ECR**

Модуль створює Elastic Container Registry:

- ECR repository
- Автоматичне сканування Docker-образів при push
- Політику доступу для push/pull образів
- Outputs з URL репозиторію

Може використовуватись у CI/CD або для ECS/EKS.
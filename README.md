# Terraform RDS Module

Універсальний Terraform-модуль для створення AWS RDS instance або Amazon Aurora Cluster залежно від параметра `use_aurora`.

Модуль автоматично створює:

- DB Subnet Group

- Security Group

- Parameter Group (для RDS або Aurora)

- RDS Instance або Aurora Cluster + Writer instance


## Приклад використання

```bash
module "rds" {
  source = "./modules/rds"

  name       = "app-db"
  use_aurora = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  db_name  = "app"
  username = "admin"
  password = "password123"

  engine         = "aurora-postgresql"
  engine_version = "13.7"
  instance_class = "db.t3.medium"
  multi_az       = false
}
```


## Змінні модуля

| Назва                 | Тип            | Опис                                                                           |
| --------------------- | -------------- | ------------------------------------------------------------------------------ |
| `use_aurora`          | `bool`         | Якщо `true` — створюється Aurora Cluster, якщо `false` — звичайна RDS instance |
| `name`                | `string`       | Базове ім’я для всіх ресурсів БД                                               |
| `vpc_id`              | `string`       | ID VPC, у якій створюється база даних                                          |
| `subnet_ids`          | `list(string)` | Список приватних підмереж для DB Subnet Group                                  |
| `db_name`             | `string`       | Назва бази даних                                                               |
| `username`            | `string`       | Master username для БД                                                         |
| `password`            | `string`       | Пароль користувача БД                                                          |
| `engine`              | `string`       | Тип engine (наприклад: `postgres`, `aurora-postgresql`, `mysql`)               |
| `engine_version`      | `string`       | Версія engine                                                                  |
| `instance_class`      | `string`       | Клас інстансу БД (наприклад: `db.t3.micro`, `db.r6g.large`)                    |
| `multi_az`            | `bool`         | Увімкнення Multi-AZ для звичайної RDS                                          |
| `allowed_cidr_blocks` | `list(string)` | CIDR-блоки, яким дозволений доступ до БД                                       |



## Зміна типу БД

### Звичайна RDS instance

```bash
use_aurora = false
engine     = "postgres"
```

Результат:

- `aws_db_instance`

- `aws_db_parameter_group`

### Aurora Cluster

```bash
use_aurora = true
engine     = "aurora-postgresql"
```

Результат:

- `aws_rds_cluster`

- `aws_rds_cluster_instance`

- `aws_rds_cluster_parameter_group`


## Зміна engine та версії

```bash
engine         = "aurora-mysql"
engine_version = "8.0.mysql_aurora.3.04.1"
```

або

```bash
engine         = "postgres"
engine_version = "14.5"
```


## Зміна класу інстансу

```bash
instance_class = "db.t3.micro"
```

Популярні приклади:

- `db.t3.micro` — тестове середовище

- `db.r6g.large` — production

- `db.m5.large` — універсальний варіант


## Outputs

| Назва               | Опис                                   |
| ------------------- | -------------------------------------- |
| `endpoint`          | Endpoint для підключення до бази даних |
| `security_group_id` | ID Security Group бази даних           |


## Особливості модуля

- Умовне створення ресурсів через `use_aurora`

- Мінімальна кількість змінних

- Багаторазове використання

- Підходить для `dev`, `stage`, `prod`
# 📘 Terraform + Keycloak

## Modelo Mental, Abstrações e Convenções

Este documento explica **como pensar** e **como usar** as bibliotecas Terraform para provisionamento de componentes de autorização no Keycloak.

O foco é:

* clareza conceitual
* boa DX
* governança invisível
* independência entre módulos

Provider utilizado:
👉 `keycloak/keycloak`

---

## 2️⃣ As abstrações do domínio

Modelamos apenas **dois tipos de entidade**, cada uma com responsabilidade clara.

---

## 2.1 Resource Server

### O que é

Um **Resource Server** representa um serviço que:

* expõe endpoints protegidos
* define *quais permissões existem*
* **não autentica usuários**

Ele serve exclusivamente como:

* agrupador de roles
* agrupador de scopes

---

### Como o consumidor declara

```hcl
resource_server "pix-api" {
  roles = [
    "reader",
    "admin"
  ]
}
```

Ou, opcionalmente, sem declarar roles explicitamente:

```hcl
resource_server "pix-api" {}
```

---

### Comportamento padrão (roles)

* Caso **nenhuma role seja declarada**, o módulo **DEVE** criar automaticamente uma role padrão chamada:

```
viewer
```

* Essa role representa acesso **somente leitura**
* A role `viewer` **NÃO precisa** ser declarada pelo consumidor
* A criação é **implícita e padronizada**

---

### O que o módulo cria (internamente)

Assumindo organização fixa `acme`:

| Componente | Nome Gerado           |
| ---------- | --------------------- |
| Client     | `acme-pix-api`        |
| Role       | `acme-pix-api:viewer` |
| Scope      | `acme-pix-api:viewer` |

Ou, quando roles são declaradas explicitamente:

| Componente | Nome Gerado           |
| ---------- | --------------------- |
| Role       | `acme-pix-api:reader` |
| Role       | `acme-pix-api:admin`  |

Regras internas:

* client não permite login
* não emite token
* existe apenas para autorização
* sempre existe **ao menos uma role válida**

---

### Responsabilidades do módulo

* Validar naming do resource server
* Criar client
* Criar roles (com prefixo automático)
* Criar **role padrão `viewer` quando nenhuma for declarada**
* Criar scopes (1:1 com roles)
* Garantir consistência semântica

---

## 2.2 Service Account

### O que é

Um **Service Account** representa um consumidor de resource servers, autenticando via:

* `client_credentials`

Ele **não define permissões** — apenas consome.

---

### Como o consumidor declara

```hcl
service_account "pix-worker" {
  permissions = {
    "pix-api" = ["reader"]
  }
}
```

O consumidor:

* não conhece prefixos
* não conhece client ids reais
* não precisa saber como roles são nomeadas

---

### O que o módulo cria (internamente)

| Componente     | Nome Gerado           |
| -------------- | --------------------- |
| Client         | `sa-acme-pix-worker`  |
| Role associada | `acme-pix-api:reader` |

Regras internas:

* apenas `client_credentials`
* login desabilitado
* associa roles já existentes

---

### Responsabilidades do módulo

* Validar naming do service account
* Inferir client ids de resource servers
* Resolver nomes de roles automaticamente
* Associar roles sem criar dependência direta

---

## 3️⃣ Naming e Governança (invisível ao consumidor)

### Convenções gerais

* Inputs do consumidor:

  * `kebab-case`
  * sem prefixos
  * sem sufixos técnicos

* Prefixos, concatenações e padrões:

  * são responsabilidade **exclusiva do módulo**
  * não vazam para a DX

---

### Validação

* Toda validação ocorre em `variable { validation {} }`
* Falhas acontecem no `terraform plan`
* O módulo **não corrige** inputs inválidos

Exemplo:

* ❌ `Reader`
* ❌ `pix_api`
* ❌ `sa-pix-worker`
* ✅ `pix-api`
* ✅ `reader`

---

## 4️⃣ Independência entre módulos

* Resource Servers e Service Accounts:

  * são módulos independentes
  * podem viver em repositórios distintos
* Comunicação ocorre via:

  * naming convention
  * `terraform_remote_state`
  * ou `data keycloak_*`

Terraform **não orquestra** ordem entre eles.

---
# Ansible — Deploy dos Microserviços

## Pré-requisitos
- Ansible instalado localmente (`pip install ansible`)
- Módulo Docker: `ansible-galaxy collection install community.docker`
- Acesso SSH às EC2 via key pair (.pem)

## Como usar

### 1. Preencher as variáveis
Edita o ficheiro `vars.yml` com os valores reais:
- IPs das EC2 (dados pela Sara)
- Endpoint do RDS (dados pela Sara)
- URL da fila SQS (dados pela Sara)
- Password da base de dados

### 2. Correr o playbook completo
```bash
ansible-playbook -i inventory.yml playbook.yml
```

### 3. Correr só um serviço (exemplo)
```bash
ansible-playbook -i inventory.yml playbook.yml --limit catalog
```

### 4. Verificar conectividade
```bash
ansible all -i inventory.yml -m ping
```

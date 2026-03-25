\# Sovereign AI Hub — Infrastructure



Infrastructure AWS déployée 100% en code avec Terraform.

Un serveur Ubuntu accessible en SSH, créé en une commande.



\## Ce que fait ce code



\- Crée un réseau privé (VPC) dans AWS région Paris

\- Configure un subnet public avec accès Internet

\- Déploie un serveur Ubuntu 22.04 accessible en SSH

\- Gère les règles réseau avec un Security Group



\## Prérequis



\- \[Terraform](https://terraform.io) installé

\- \[AWS CLI](https://aws.amazon.com/cli/) configuré avec `aws configure`

\- Une clé SSH générée : `ssh-keygen -t ed25519 -f \~/.ssh/sovereign-key`



\## Comment déployer

```bash

terraform init

terraform plan

terraform apply

```



\## Se connecter en SSH

```bash

ssh -i "$env:USERPROFILE\\.ssh\\sovereign-key" ubuntu@$(terraform output -raw instance\_public\_ip)

```



\## Détruire l'infrastructure

```bash

terraform destroy

```



\## Stack technique



| Technologie | Usage |

|-------------|-------|

| Terraform | Infrastructure as Code |

| AWS EC2 | Serveur Ubuntu 22.04 |

| AWS VPC | Réseau privé |

| AWS Security Group | Pare-feu |


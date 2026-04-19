# Synthese du projet DevOps

## Vue d'ensemble

Ce document présente une synthèse courte du travail déjà réalisé dans le projet DevOps. Une documentation plus détaillée est également disponible dans `doc/documentation-detaillee-projet-devops.md`.

À ce stade, les étapes suivantes ont déjà été réalisées et validées :

- `00-environnement.md`
- `01-pipeline-cicd.md`
- `02-github-actions.md`
- `03-terraform-init.md`
- `04-terraform-modules.md`
- `05-ansible-playbook.md`
- `06-docker-avance.md`
- `07-kubernetes-deploy.md`
- `08-helm-charts.md`
- `09-prometheus-grafana.md`

## Étapes réalisées jusqu'à présent

Jusqu'ici, le travail réalisé peut être résumé de la manière suivante :

- préparation complète de l'environnement local ;
- mise en place d'une pipeline CI/CD avec GitHub Actions ;
- évolution de cette pipeline avec workflow réutilisable, environnements et déploiements distincts ;
- premiers travaux avec Terraform, puis refactorisation modulaire ;
- mise en place d'une base Ansible avec playbooks, roles et validation de l'idempotence ;
- optimisation Docker avancée avec comparaison d'images et validation d'une stack complète avec Docker Compose ;
- premiers déploiements Kubernetes sur Minikube avec PostgreSQL et application ;
- création d'un chart Helm simple et découverte de Kustomize.
- mise en place d'une stack de monitoring locale avec Prometheus, Grafana et AlertManager.

## Choix des outils

Les outils suivants ont été retenus pour rester cohérents avec les consignes du cours et avec une logique DevOps classique :

- **Git et GitHub** pour le versionnement du projet et l'hébergement du code ;
- **GitHub Actions** pour la mise en place de la CI/CD ;
- **Docker** pour la conteneurisation de l'application ;
- **Docker Compose** pour l'orchestration locale d'une stack complète ;
- **Terraform** pour l'infrastructure as code ;
- **Ansible** pour l'automatisation de la configuration ;
- **Minikube** pour le cluster Kubernetes local, conformément à l'option A du document `00-environnement.md`.

## GitHub Actions et outils de vérification

Le pipeline GitHub Actions a été structuré de manière progressive :

- exécution des tests automatisés ;
- build de l'image Docker ;
- étape de vérification de sécurité ;
- déploiement simulé.

Une version plus avancée du pipeline a ensuite été mise en place avec :

- un workflow Docker réutilisable ;
- une action composite locale ;
- deux environnements de déploiement : `staging` et `production`.

Les environnements GitHub ont également été configurés de la manière suivante :

- `staging` sans protection ;
- `production` avec reviewer obligatoire et délai d'attente.

## Explication du CI/CD

Le principe de CI/CD appliqué dans ce projet est le suivant :

- **CI (Continuous Integration)** : chaque changement envoyé sur le dépôt déclenche automatiquement des vérifications, notamment les tests et la construction de l'image Docker ;
- **CD (Continuous Delivery / Deployment)** : une fois les vérifications réussies, le pipeline prépare ou simule le déploiement selon la branche et l'environnement visé.

Cette approche permet :

- d'automatiser les contrôles ;
- de réduire les vérifications manuelles ;
- de sécuriser la qualité du code avant déploiement ;
- de structurer clairement le passage entre développement, staging et production.

## Pipeline de déploiement

Le pipeline mis en place suit la logique suivante :

1. exécution des tests sur plusieurs versions de Node.js ;
2. construction de l'image Docker ;
3. vérification de sécurité ;
4. déploiement vers `staging` ;
5. déploiement vers `production` sur `main`, avec approbation et temporisation.

Ce fonctionnement a été validé à la fois sur `develop` et sur `main`.

## Détail du pipeline

Le pipeline principal repose sur les éléments suivants :

- un workflow principal `ci.yml` ;
- un workflow réutilisable pour la construction Docker ;
- des jobs séparés pour `test`, `build`, `security`, `deploy-staging` et `deploy-production`.

Ce découpage permet une lecture plus claire du pipeline, une meilleure maintenance et une logique plus proche des pratiques professionnelles.

## Terraform

Deux étapes principales ont déjà été réalisées avec Terraform :

- une première étape d'initialisation avec création simple de ressources Docker ;
- une seconde étape modulaire avec :
  - un module `webapp` ;
  - un module `database` ;
  - un environnement `dev`.

Les validations suivantes ont été réalisées :

- `terraform init`
- `terraform plan`
- `terraform apply`
- vérification des ressources créées
- `terraform destroy`

L'objectif était de démontrer le cycle complet de l'infrastructure as code.

## Docker

Le travail réalisé avec Docker a porté sur deux aspects :

- la conteneurisation simple de l'application ;
- l'optimisation avancée de l'image.

Une comparaison a été réalisée entre :

- une image non optimisée `app:bad`
- une image multi-stage optimisée `app:optimized`

Résultats observés :

- `app:bad` = `1.57GB`
- `app:optimized` = `194MB`

Une stack Docker Compose complète a également été validée avec :

- l'application ;
- PostgreSQL ;
- Redis ;
- Nginx comme reverse proxy.

## Kubernetes

La partie Kubernetes a commencé avec un déploiement simple sur Minikube. Les éléments suivants ont été validés :

- un namespace dédié ;
- une ConfigMap et un Secret ;
- un déploiement PostgreSQL avec PVC ;
- un déploiement applicatif avec plusieurs replicas ;
- un service `ClusterIP` ;
- un accès de test via `port-forward` ;
- une démonstration de scaling, rolling update et rollback.

## Helm et Kustomize

Une première étape Helm a ensuite été réalisée pour transformer le déploiement Kubernetes en chart plus réutilisable. Les points validés sont les suivants :

- création d'un chart Helm simple ;
- ajout de `values-dev.yaml` et `values-prod.yaml` ;
- validation avec `helm lint` et `helm template` ;
- installation, upgrade, rollback et historique de release ;
- mise en place d'une structure Kustomize simple avec `base`, `dev` et `prod`.

## Monitoring

La partie monitoring a ensuite été mise en place avec une stack locale composée de :

- Prometheus ;
- Grafana ;
- AlertManager ;
- node-exporter ;
- un service `webhook-mock`.

Les validations principales ont été les suivantes :

- targets Prometheus en état `UP` ;
- dashboard Grafana provisionné automatiquement ;
- règles d'alertes chargées ;
- déclenchement réel de l'alerte `AppDown` ;
- réception des webhooks `firing` puis `resolved` dans `webhook-mock`.

## Difficultés principales rencontrées

Les principales difficultés rencontrées jusqu'à présent ont été les suivantes :

- démarrage initial de l'environnement local, avec plusieurs outils à installer et à valider ;
- configuration de l'authentification GitHub avec des identifiants personnels et une connexion SSH bloquée sur le port `22` ;
- ajustement de certains workflows GitHub Actions pour corriger des références d'actions non résolues ;
- nécessité d'adapter légèrement certains exemples du cours pour qu'ils fonctionnent avec la structure réelle du projet ;
- lenteur importante du build de l'image Docker non optimisée ;
- configuration Ansible sur des conteneurs minimaux ne disposant pas immédiatement des prérequis nécessaires ;
- nécessité de relancer et revérifier le cluster Minikube avant de commencer la partie Kubernetes ;
- simplification du chart généré automatiquement par Helm pour garder une structure plus lisible.
- nécessité de valider la chaîne complète d'alerte avec une panne contrôlée de l'application pour confirmer les webhooks.

## Solutions apportées

Les solutions mises en place ont permis de garder le projet cohérent avec les consignes tout en assurant un fonctionnement réel :

- installation et validation progressive des outils requis sur macOS ;
- utilisation de `ssh.github.com` sur le port `443` pour contourner le blocage réseau GitHub ;
- correction et mise à jour des workflows GitHub Actions ;
- conservation du code du professeur autant que possible, avec uniquement des adaptations minimales lorsque cela était nécessaire pour exécuter le projet ;
- validation systématique par tests locaux, builds Docker, exécutions Terraform, Ansible et GitHub Actions ;
- validation progressive de Kubernetes avec des manifestes simples, proches du document, avant d'ajouter des éléments plus avancés ;
- simplification volontaire des fichiers Helm pour garder un niveau compréhensible et proche d'une première prise en main ;
- mise en place d'un `webhook-mock` local pour vérifier clairement les notifications AlertManager ;
- maintien d'une documentation détaillée pour justifier les choix techniques et les ajustements effectués.

## Autres éléments pertinents

En complément, les points suivants ont également été réalisés :

- préparation complète de l'environnement local ;
- validation du cluster Minikube ;
- mise en place d'une base Ansible avec inventaire, playbooks, roles et démonstration d'idempotence ;
- premiers manifestes Kubernetes fonctionnels dans le dossier `k8s/` ;
- ajout d'un chart Helm et d'une structure Kustomize dans le projet ;
- ajout d'une stack de monitoring dans le dossier `monitoring/` ;
- rédaction d'une documentation détaillée pour suivre chaque étape du projet.

## Conclusion

À ce stade, le projet est déjà structuré, versionné et validé sur plusieurs briques essentielles de l'écosystème DevOps : environnement, CI/CD, Docker, Terraform, Ansible, Kubernetes, Helm, Kustomize et monitoring. La suite du travail pourra s'appuyer sur cette base pour poursuivre les étapes suivantes, notamment la sécurité avancée et GitOps.

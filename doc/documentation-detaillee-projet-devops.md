# Documentation détaillée du projet DevOps

Ce document reprend de manière structurée les étapes réalisées dans le projet. L'objectif est de garder une trace claire du travail effectué, sans entrer dans un niveau de détail trop lourd. La synthèse courte reste disponible dans `doc/synthese-professeur.md`.

# 00 - Mise en place de l'environnement

## Objectif

Préparer un environnement local utilisable pour l'ensemble du projet DevOps, avec les outils nécessaires pour Docker, Kubernetes, Terraform et Ansible.

## Réalisation

Les outils principaux ont été installés et validés sur macOS :

- `git`
- `docker`
- `kubectl`
- `minikube`
- `terraform`
- `ansible`
- `helm`

Le choix de `Minikube` a été retenu parce qu'il correspond à l'option A du document du cours et qu'il permettait d'avoir un cluster Kubernetes local cohérent pour toutes les étapes suivantes.

## Validation

Les vérifications principales ont porté sur :

- les versions des outils ;
- le bon fonctionnement de Docker ;
- le démarrage du cluster local Minikube ;
- la disponibilité de Terraform et Ansible.

## Difficultés rencontrées

- Mise en route initiale plus longue à cause du nombre d'outils à installer.
- Quelques vérifications supplémentaires nécessaires pour confirmer que Docker et Minikube fonctionnaient bien ensemble.

## Solutions apportées

- Validation progressive outil par outil.
- Tests simples après chaque installation pour éviter de découvrir plusieurs problèmes en même temps.

## Conclusion

L'environnement local a été préparé correctement et a servi de base stable pour la suite du projet.

# 01 - Pipeline CI/CD multi-stages

## Objectif

Mettre en place une première pipeline CI/CD autour de l'application et valider la conteneurisation de base.

## Réalisation

Les éléments suivants ont été mis en place :

- validation locale de l'application Node ;
- vérification des endpoints `/`, `/health` et `/metrics` ;
- validation du `Dockerfile` ;
- construction de l'image Docker ;
- création du workflow GitHub Actions principal.

Le pipeline a été structuré autour de quatre grandes étapes :

1. tests ;
2. build ;
3. sécurité ;
4. déploiement simulé.

## Validation

Les validations réalisées ont été les suivantes :

- `npm test`
- `npm start`
- vérification des endpoints avec `curl`
- `docker build`
- exécution du workflow sur GitHub Actions

## Difficultés rencontrées

- Première mise en place du workflow GitHub Actions.
- Quelques erreurs de résolution d'actions et d'organisation du `ci.yml`.

## Solutions apportées

- Ajustement progressif du workflow.
- Vérification locale avant chaque push vers GitHub.

## Conclusion

L'application a été validée localement et la première base CI/CD a été mise en place avec succès.

# 02 - GitHub Actions avancé

## Objectif

Faire évoluer la pipeline pour la rendre plus propre, plus modulaire et plus proche d'une organisation réelle.

## Réalisation

Cette étape a permis d'ajouter :

- un workflow Docker réutilisable ;
- une action composite locale ;
- deux environnements GitHub : `staging` et `production` ;
- un déploiement séparé pour `staging` et `production`.

Le comportement attendu a été défini de la manière suivante :

- `staging` : exécution simple ;
- `production` : approbation et temporisation.

## Validation

Le comportement de la pipeline a été vérifié :

- sur `develop`, avec exécution jusqu'au staging ;
- sur `main`, avec validation du déploiement `production` via approbation.

## Difficultés rencontrées

- Certaines actions GitHub utilisées dans le workflow ne fonctionnaient pas immédiatement.
- Le rendu du pipeline a demandé plusieurs ajustements pour correspondre aux consignes.

## Solutions apportées

- Mise à jour des actions utilisées.
- Relecture du pipeline étape par étape jusqu'à obtenir un comportement cohérent.

## Conclusion

La pipeline est devenue plus propre, plus lisible et mieux structurée.

# 03 - Terraform - Fondamentaux

## Objectif

Découvrir Terraform avec une première configuration simple pour piloter des ressources Docker.

## Réalisation

Une structure Terraform de base a été créée avec :

- `main.tf`
- `variables.tf`
- `dev.tfvars`
- `prod.tfvars`

Le scénario réalisé a consisté à créer :

- une image Docker ;
- un conteneur ;
- une ressource réseau.

## Validation

Le cycle complet Terraform a été validé :

- `terraform init`
- `terraform plan`
- `terraform apply`
- vérification des ressources
- `terraform destroy`

## Difficultés rencontrées

- La version initiale de Terraform dans l'environnement n'était pas suffisante.

## Solutions apportées

- Mise à jour de Terraform avant de poursuivre.
- Validation progressive du cycle complet avant d'ajouter plus de complexité.

## Conclusion

Cette étape a permis de valider le fonctionnement de Terraform sur un cas simple et complet.

# 04 - Terraform - Modules

## Objectif

Passer d'une configuration simple à une structure plus propre, basée sur des modules réutilisables.

## Réalisation

Deux modules principaux ont été créés :

- `webapp`
- `database`

Un environnement `dev` a ensuite été monté à partir de ces modules.

## Validation

Les validations ont été réalisées sur l'environnement `dev` :

- `terraform init`
- `terraform plan`
- `terraform apply`
- vérification des conteneurs et services
- `terraform destroy`

## Difficultés rencontrées

- Les providers Docker n'étaient pas totalement alignés avec la structure modulaire au début.

## Solutions apportées

- Correction des déclarations de provider.
- Validation des modules avant leur utilisation dans l'environnement final.

## Conclusion

La structure Terraform a été rendue plus claire et plus proche d'un usage réel grâce aux modules.

# 05 - Ansible - Playbooks & Roles

## Objectif

Mettre en place une base Ansible avec inventaire, playbooks et rôles.

## Réalisation

Une structure Ansible complète a été créée dans `infra/ansible` avec :

- un `docker-compose.yml` de test ;
- un inventaire ;
- des playbooks ;
- des rôles `base`, `nginx` et `app`.

Un `site.yml` a ensuite servi de point d'entrée principal.

## Validation

Les validations principales ont été :

- démarrage des conteneurs de test ;
- `ansible all -m ping`
- exécution de `site.yml`
- seconde exécution pour vérifier l'idempotence

L'idempotence a été confirmée au second passage.

## Difficultés rencontrées

- Les conteneurs de test n'avaient pas tous les prérequis nécessaires dès le départ.

## Solutions apportées

- Ajustement du `docker-compose.yml`.
- Ajout d'un `ansible.cfg` plus adapté au contexte local.

## Conclusion

La base Ansible a été validée avec succès, y compris sur le point important de l'idempotence.

# 06 - Docker avancé

## Objectif

Comparer une image mal construite avec une image optimisée, puis valider une stack locale plus complète.

## Réalisation

Les éléments suivants ont été ajoutés :

- `Dockerfile.bad`
- `Dockerfile` optimisé multi-stage
- `.dockerignore`
- `docker-compose.yml`
- `nginx/default.conf`

Une stack locale avec application, PostgreSQL, Redis et Nginx a été testée.

## Validation

Les deux images ont été construites et comparées :

- `app:bad` = `1.57GB`
- `app:optimized` = `194MB`

La stack Compose a également été validée avec :

- `docker compose up -d`
- `docker compose ps`
- `curl http://localhost:80`
- `curl http://localhost:80/health`
- `docker compose down -v`

## Difficultés rencontrées

- Le `Dockerfile.bad` original était très lourd à construire.
- Le `Dockerfile` optimisé devait rester fidèle au document tout en fonctionnant avec la structure réelle du projet.

## Solutions apportées

- Conservation du code du professeur autant que possible.
- Adaptations minimales sur le Dockerfile optimisé pour garantir un build fonctionnel.

## Conclusion

Cette étape a permis de montrer de manière concrète l'intérêt d'une image optimisée.

# 07 - Kubernetes - Déployer une application

## Objectif

Déployer l'application sur Kubernetes avec une structure volontairement simple.

## Réalisation

Des manifestes Kubernetes ont été créés dans `k8s/` pour :

- le `ConfigMap`
- le `Secret`
- PostgreSQL
- l'application

Le déploiement a été fait dans le namespace `devops-training`.

## Validation

Les validations ont porté sur :

- la création du namespace ;
- le déploiement des pods ;
- les services ;
- le `port-forward` ;
- le scaling ;
- le rolling update ;
- le rollback.

## Difficultés rencontrées

- Nécessité de vérifier à nouveau Minikube avant de commencer la partie Kubernetes.

## Solutions apportées

- Validation du cluster avant application des manifestes.
- Choix de manifestes simples et lisibles.

## Conclusion

Le premier déploiement Kubernetes a été validé sur Minikube.

# 08 - Helm & Kustomize

## Objectif

Structurer le déploiement Kubernetes de façon plus propre avec Helm et Kustomize.

## Réalisation

Un chart Helm simple a été créé, avec :

- un `Chart.yaml`
- des templates de base
- des `values` par environnement

Une structure Kustomize a également été ajoutée avec :

- `base`
- `overlays/dev`
- `overlays/prod`

## Validation

Les validations ont été réalisées avec :

- `helm lint`
- `helm template`
- `helm install`
- `helm upgrade`
- `helm rollback`
- `kubectl apply -k`

## Difficultés rencontrées

- Le chart généré automatiquement était trop chargé pour un premier niveau.

## Solutions apportées

- Simplification volontaire du chart pour garder un niveau compréhensible et cohérent avec le reste du projet.

## Conclusion

Cette étape a permis de découvrir deux approches différentes pour organiser un déploiement Kubernetes.

# 09 - Prometheus & Grafana

## Objectif

Mettre en place une base de monitoring locale avec Prometheus, Grafana et AlertManager.

## Réalisation

Une stack de monitoring a été créée dans `monitoring/` avec :

- Prometheus
- Grafana
- AlertManager
- node-exporter
- webhook-mock

## Validation

Les points suivants ont été validés :

- targets Prometheus en `UP`
- dashboard Grafana provisionné automatiquement
- règles d'alerte chargées
- déclenchement réel de l'alerte `AppDown`
- réception des webhooks `firing` puis `resolved`

## Difficultés rencontrées

- Il fallait vérifier non seulement l'affichage du monitoring, mais aussi la chaîne complète d'alerte.

## Solutions apportées

- Mise en place d'un `webhook-mock` pour rendre la validation plus claire.
- Test volontaire d'une panne contrôlée de l'application.

## Conclusion

Le monitoring et le système d'alertes ont été validés de manière concrète.

# 10 - DevSecOps - Scan & Conformité

## Objectif

Ajouter une première couche de sécurité au projet et au pipeline.

## Réalisation

Cette étape a ajouté :

- Trivy
- Gitleaks
- OPA / Conftest
- une checklist sécurité
- un reporting SARIF dans le pipeline

Des politiques simples ont été créées pour le Dockerfile et les manifestes Kubernetes.

## Validation

Les validations locales ont confirmé :

- absence de fuite de secrets ;
- absence de vulnérabilité `CRITICAL` dans l'image applicative ;
- absence de misconfiguration critique dans le Dockerfile et Terraform ;
- politiques OPA valides.

## Difficultés rencontrées

- Les scans de sécurité remontaient des résultats qui devaient être interprétés correctement, notamment sur la base Node.

## Solutions apportées

- Choix d'un seuil bloquant sur les vulnérabilités `CRITICAL`.
- Conservation d'un reporting plus large pour garder de la visibilité sur les `HIGH`.

## Conclusion

La partie DevSecOps a été intégrée de manière simple mais cohérente avec le projet.

# 11 - GitOps avec ArgoCD

## Objectif

Mettre en place une logique GitOps sur le cluster local avec ArgoCD.

## Réalisation

Une structure GitOps a été créée dans `gitops/` avec :

- une base applicative ;
- des overlays `dev`, `staging` et `prod` ;
- un `AppProject` ;
- plusieurs `Application` ArgoCD.

ArgoCD a été installé dans Minikube et configuré pour suivre le dépôt Git.

## Validation

La validation principale a été la suivante :

- installation d'ArgoCD ;
- création de l'application `dev` ;
- synchronisation de l'état du dépôt ;
- modification du nombre de replicas dans Git ;
- passage en `OutOfSync` ;
- resynchronisation automatique.

## Difficultés rencontrées

- Mise en place plus délicate qu'en environnement distant, car tout devait fonctionner sur Minikube local.

## Solutions apportées

- Adaptation simple du scénario GitOps au cluster local.
- Utilisation de `minikube image load` pour rendre l'image disponible dans le cluster.

## Conclusion

La logique GitOps avec ArgoCD a été validée sur un cas concret et compréhensible.

# Compléments optionnels réalisés

## Terraform Workspaces

Un bonus a été ajouté avec l'utilisation de workspaces Terraform, notamment un workspace `staging` séparé du `default`.

La validation a montré :

- des noms distincts ;
- des ports distincts ;
- un cycle `apply` / `destroy` propre ;
- une séparation logique entre environnements.

## Ingress Kubernetes

Un `Ingress` a également été ajouté dans Kubernetes.

Le routage a été validé avec :

- le controller Nginx ;
- un `Host` `devops.local` ;
- un test `curl` concluant via `port-forward`.

## Fichier `.trivyignore`

Un fichier `.trivyignore` a été ajouté pour préparer une gestion future d'exceptions Trivy, même s'il reste volontairement simple à ce stade.

## Conclusion

Ces compléments optionnels n'ont pas changé la logique générale du projet, mais ils ont permis de renforcer certains points pratiques de l'environnement DevOps mis en place.

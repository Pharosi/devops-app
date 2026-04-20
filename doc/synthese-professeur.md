# Synthèse du projet DevOps

Ce document présente une synthèse courte du travail réalisé dans le projet. La documentation détaillée reste disponible dans `doc/documentation-detaillee-projet-devops.md`.

## Ce qui a été fait

Le projet a été réalisé jusqu'aux consignes `00` à `11`, avec quelques compléments optionnels. L'objectif a été de partir d'une application simple, puis de construire autour d'elle une chaîne DevOps complète.

Les éléments principaux déjà mis en place sont les suivants :

- préparation de l'environnement local ;
- pipeline CI/CD avec GitHub Actions ;
- infrastructure simple avec Terraform, puis structure modulaire ;
- base Ansible avec playbooks, rôles et test d'idempotence ;
- conteneurisation avec Docker et Docker Compose ;
- déploiement sur Kubernetes avec Minikube ;
- utilisation de Helm, Kustomize, Prometheus, Grafana, Trivy et ArgoCD.

## Comment le projet a été construit

Le travail a été fait progressivement, en suivant l'ordre des consignes. Le but n'était pas seulement d'avoir une application qui fonctionne, mais aussi de montrer comment la tester, l'automatiser, la déployer et la superviser.

Le pipeline GitHub Actions a été organisé de façon simple :

1. exécution des tests ;
2. build de l'image Docker ;
3. vérifications de sécurité ;
4. préparation du déploiement sur `staging` puis `production`.

L'idée du CI/CD dans ce projet a donc été d'automatiser les contrôles et de rendre le passage entre développement et déploiement plus clair et plus fiable.

## Choix des outils

Les outils retenus sont ceux qui correspondaient le mieux aux consignes et à une logique DevOps classique :

- `GitHub Actions` pour la pipeline CI/CD ;
- `Docker` et `Docker Compose` pour la conteneurisation et les tests locaux ;
- `Terraform` pour l'infrastructure as code ;
- `Ansible` pour l'automatisation de la configuration ;
- `Minikube` pour le cluster Kubernetes local ;
- `Helm` et `Kustomize` pour organiser les déploiements Kubernetes ;
- `Prometheus` et `Grafana` pour le monitoring ;
- `Trivy`, `Gitleaks` et `OPA / Conftest` pour la sécurité ;
- `ArgoCD` pour la partie GitOps.

## Difficultés rencontrées

Les principales difficultés ont surtout été liées à l'environnement local et à l'intégration entre les outils.

- Au début du projet, il a fallu installer et valider plusieurs outils en parallèle sur macOS, ce qui a demandé du temps avant d'avoir un environnement vraiment stable.
- La configuration GitHub et GitHub Actions a demandé plusieurs ajustements, notamment pour l'authentification SSH, certaines actions introuvables, et quelques références de versions qui ne fonctionnaient pas directement.
- La partie Terraform a demandé des adaptations sur la version de l'outil, la structure modulaire, puis sur les tests avec les workspaces pour bien séparer les environnements.
- Avec Docker, certaines constructions d'images étaient plus lourdes que prévu, en particulier la comparaison entre une image volontairement mauvaise et une image optimisée.
- Sur Kubernetes et ArgoCD, la difficulté principale a été de faire fonctionner correctement un environnement local Minikube, avec plusieurs étapes de vérification avant d'obtenir un déploiement stable.
- D'une manière générale, plusieurs exemples du cours ont dû être légèrement adaptés pour fonctionner avec la structure réelle du projet, tout en essayant de rester le plus fidèle possible aux consignes du professeur.

## Solutions apportées

Pour avancer proprement, chaque étape a été validée progressivement avec des tests simples : `curl`, `docker ps`, `kubectl`, `terraform plan/apply/destroy`, `ansible-playbook`, interfaces web quand c'était utile, et vérification du pipeline GitHub Actions.

- Pour l'environnement local, la solution a été de vérifier les outils un par un et de ne passer à l'étape suivante qu'une fois le fonctionnement confirmé.
- Pour GitHub et GitHub Actions, les problèmes ont été résolus en corrigeant progressivement les workflows, en mettant à jour certaines actions et en ajustant la configuration SSH quand c'était nécessaire.
- Pour Terraform, la méthode utilisée a été de travailler par petites validations successives : `init`, `plan`, `apply`, vérification, puis `destroy`, avant d'ajouter les modules et les workspaces.
- Pour Docker, la solution a été de garder une approche simple : comparer clairement une image non optimisée et une image multi-stage plus propre, avec des tests réels sur le build et la taille finale.
- Pour Kubernetes, Helm, le monitoring et ArgoCD, la logique a été la même : commencer avec une version simple et fonctionnelle, puis ajouter les éléments plus avancés seulement après validation.
- Quand une adaptation était nécessaire, l'objectif a toujours été de rester au plus proche du document du cours, avec des modifications minimales et justifiées. Cela a permis de garder un projet cohérent, compréhensible et réellement exécutable.

## Résultat actuel

À ce stade, le projet montre une chaîne DevOps complète autour d'une application simple :

- développement et versionnement ;
- pipeline CI/CD ;
- infrastructure et automatisation ;
- conteneurisation ;
- déploiement Kubernetes ;
- monitoring ;
- sécurité ;
- GitOps.

Des éléments optionnels ont aussi été ajoutés, comme un `Ingress` Kubernetes, des workspaces Terraform et un fichier `.trivyignore`, pour compléter le projet sans en changer l'esprit.

En résumé, l'objectif a été moins de produire une application complexe que de construire un environnement DevOps complet, progressif et cohérent autour d'une application volontairement simple.

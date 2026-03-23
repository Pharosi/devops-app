# Mise en place de l'environnement

## Contexte

Ce rapport présente le travail réalisé à partir du document de consignes `00-environnement.md`. L'objectif était de préparer un environnement local complet pour la suite du projet DevOps, avec les outils nécessaires, Docker opérationnel, un cluster Kubernetes local et une vérification finale des composants principaux.

## Travaux réalisés

Les outils suivants ont été vérifiés et/ou installés sur l'environnement local macOS :

- Git
- Docker
- Docker Compose
- kubectl
- Terraform
- Ansible
- Helm
- ArgoCD CLI
- Minikube

L'application de base du projet était déjà présente dans le dossier de travail, ce qui a permis de considérer la partie relative à la récupération du starter applicatif comme déjà satisfaite pour cette étape.

## Difficultés rencontrées

Plusieurs difficultés ont été rencontrées pendant la préparation de l'environnement :

- Au départ, Docker était installé mais le daemon n'était pas encore lancé.
- Certains outils demandés par les consignes n'étaient pas installés au moment de la première vérification, notamment Terraform, Ansible, Helm et ArgoCD CLI.
- Le choix de l'outil pour le cluster Kubernetes local a dû être clarifié afin de rester conforme au document fourni.
- La partie du document concernant le clonage du dépôt de formation pouvait prêter à confusion, car le projet de base était déjà disponible dans le dossier courant.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- Docker Desktop a été démarré pour rendre le moteur Docker accessible.
- Les outils manquants ont été installés afin d'aligner l'environnement local avec les prérequis du document.
- Le choix du cluster local a finalement été porté sur **Minikube**, car le document `00-environnement.md` le présente explicitement comme **Option A**.
- La partie `git clone ...` et `cp -R starter-code/devops-app app` a été interprétée comme une instruction générale du cours ; dans notre cas, le starter applicatif étant déjà présent, cette étape n'était pas nécessaire pour poursuivre le travail.

## Justification du choix de Minikube

Le choix de **Minikube** a été retenu pour les raisons suivantes :

- le document de référence le présente comme l'**Option A** ;
- cela permet de rester cohérent avec la méthodologie attendue dans le cadre du cours ;
- cela limite les écarts entre l'environnement utilisé pour les démonstrations pédagogiques et l'environnement local utilisé pour le projet.

## Tests de validation réalisés

Les vérifications suivantes ont été effectuées avec succès :

### Vérification des versions

- `git --version`
- `docker --version`
- `docker compose version`
- `kubectl version --client`
- `terraform --version`
- `ansible --version`
- `helm version --short`
- `argocd version --client`
- `minikube version`

### Validation de Docker

La commande suivante a été exécutée :

```bash
docker run --rm hello-world
```

Résultat :

- téléchargement de l'image `hello-world` ;
- démarrage correct du conteneur ;
- message de confirmation indiquant que l'installation Docker fonctionne correctement.

### Validation du cluster Kubernetes local

Les commandes suivantes ont permis de confirmer le bon fonctionnement du cluster Minikube :

```bash
minikube status
kubectl config current-context
kubectl cluster-info
kubectl get nodes
```

Résultats obtenus :

- le contexte Kubernetes actif est `minikube` ;
- le cluster local est démarré ;
- le control plane est accessible ;
- le node `minikube` est dans l'état `Ready`.

### Validation de Terraform

Un test simple a été réalisé avec le fichier suivant :

```hcl
output "hello" { value = "world" }
```

Commandes exécutées :

```bash
terraform init
terraform apply -auto-approve
```

Résultat :

- initialisation Terraform réussie ;
- application réussie ;
- sortie attendue affichée : `hello = "world"`.

## Conclusion

L'étape `00-environnement.md` peut être considérée comme terminée. L'environnement local est désormais prêt pour la suite du projet, avec l'ensemble des outils principaux disponibles, Docker fonctionnel, Minikube opérationnel et les validations de base exécutées avec succès.

# Pipeline CI/CD multi-stages

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document de consignes `01-pipeline-cicd.md`. L'objectif principal était de valider l'application localement, vérifier la conteneurisation avec Docker, mettre en place un pipeline CI/CD sur GitHub Actions et s'assurer que les principales étapes du flux d'intégration continue fonctionnent correctement.

## Travaux réalisés

Les éléments suivants ont été réalisés pendant cette étape :

- validation de l'application Node.js en local ;
- exécution des tests automatisés ;
- vérification des endpoints `/`, `/health` et `/metrics` ;
- vérification du `Dockerfile` multi-stage ;
- construction de l'image Docker ;
- création du workflow GitHub Actions dans `.github/workflows/ci.yml` ;
- publication du projet sur un dépôt GitHub personnel ;
- exécution du pipeline CI/CD sur GitHub Actions.

## Validation locale de l'application

L'application a été testée localement à l'aide des commandes suivantes :

```bash
npm test
npm start
```

Résultats obtenus :

- les 3 tests unitaires ont réussi ;
- le serveur HTTP a démarré correctement sur le port `3000`.

Les endpoints suivants ont ensuite été vérifiés :

```bash
curl http://localhost:3000/
curl http://localhost:3000/health
curl http://localhost:3000/metrics
```

Résultats observés :

- `/` retourne un JSON valide avec le statut `ok` et le résultat attendu ;
- `/health` retourne un JSON indiquant un état sain ;
- `/metrics` retourne les métriques au format Prometheus.

## Vérification du Dockerfile

Le `Dockerfile` du projet a été relu et validé. Il correspond bien à une structure **multi-stage** :

- un stage `test` qui installe les dépendances, copie le code source et les tests, puis exécute `npm test` ;
- un stage `production` qui prépare l'image finale, définit `NODE_ENV=production`, expose le port `3000` et configure un `HEALTHCHECK`.

Cette structure est conforme à l'esprit du document `01-pipeline-cicd.md`.

## Construction de l'image Docker

La construction de l'image Docker a été testée avec la commande suivante :

```bash
docker build -t devops-app:1.0.0 .
```

Résultat :

- le build s'est exécuté avec succès ;
- l'image `devops-app:1.0.0` a été générée correctement ;
- la conteneurisation de l'application a donc été validée.

## Mise en place du pipeline GitHub Actions

Un workflow GitHub Actions a été créé dans le fichier `.github/workflows/ci.yml`.

Le pipeline comprend les étapes suivantes :

- `test` : exécution des tests sur plusieurs versions de Node.js ;
- `build` : construction de l'image Docker ;
- `security` : scan de sécurité des fichiers du projet avec Trivy ;
- `deploy` : déploiement simulé sur la branche `main`.

Le workflow a été configuré pour respecter la structure attendue par le document de consignes, avec l'application regroupée dans le dossier `app/`.

## Difficultés rencontrées

Plusieurs difficultés ont été rencontrées au cours de cette étape :

- une première erreur lors de la commande `docker build`, due à l'exécution depuis le mauvais dossier ;
- l'absence initiale du dépôt GitHub distant ;
- la nécessité d'utiliser les identifiants personnels GitHub pour ce projet ;
- un blocage de la connexion SSH vers GitHub sur le port `22` ;
- un échec initial du job `security` dans GitHub Actions, lié à une référence de version non résolue pour Trivy ;
- des avertissements de dépréciation sur certaines actions GitHub utilisant encore Node.js 20.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- la commande Docker a été relancée depuis le bon dossier du projet ;
- le dépôt a été initialisé localement avec Git ;
- la configuration locale Git a été adaptée pour utiliser les informations personnelles suivantes :
  - `Raphael Personnel`
  - `pharosi.raphael@gmail.com`
- un dépôt GitHub personnel `devops-app` a été créé ;
- la configuration SSH personnelle a été adaptée pour utiliser `ssh.github.com` sur le port `443`, ce qui a permis de contourner le blocage réseau sur le port `22` ;
- le pipeline GitHub Actions a été corrigé pour rendre le job `security` fonctionnel avec une installation directe de Trivy sur le runner ;
- les versions de plusieurs actions GitHub ont également été mises à jour afin d'améliorer la compatibilité du workflow.

## Tests et validation du pipeline

Après correction du workflow, le pipeline GitHub Actions a été exécuté avec succès.

Les étapes validées sont les suivantes :

- `test` : réussi ;
- `build` : réussi ;
- `security` : réussi ;
- `deploy` : exécuté conformément à la logique du workflow.

Un avertissement subsiste concernant certaines actions Docker encore liées à Node.js 20, mais cela n'a pas empêché l'exécution correcte du pipeline. À ce stade, ce point est considéré comme non bloquant pour la livraison pédagogique du projet.

## Conclusion

L'étape `01-pipeline-cicd.md` peut être considérée comme terminée. L'application a été validée localement, le `Dockerfile` multi-stage a été confirmé, l'image Docker a été construite avec succès et le pipeline CI/CD a été mis en place puis exécuté correctement sur GitHub Actions.

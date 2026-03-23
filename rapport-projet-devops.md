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

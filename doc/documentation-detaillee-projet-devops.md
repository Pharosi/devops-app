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

# GitHub Actions avancé

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `02-github-actions.md`. L'objectif était d'aller plus loin dans l'utilisation de GitHub Actions en mettant en place un workflow réutilisable, des environnements protégés, une action composite locale et une pipeline plus modulaire.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création d'un workflow réutilisable pour la construction Docker ;
- modification du pipeline principal pour appeler ce workflow réutilisable ;
- ajout de deux étapes de déploiement distinctes : `staging` et `production` ;
- création d'une action composite locale pour préparer et vérifier certains outils DevOps ;
- intégration de cette action composite dans le pipeline ;
- configuration des environnements `staging` et `production` dans GitHub ;
- validation du comportement du pipeline sur les branches `develop` et `main`.

## Workflow réutilisable

Un fichier `.github/workflows/reusable-docker.yml` a été créé afin d'extraire la logique de build Docker hors du workflow principal.

Ce workflow réutilisable reçoit notamment :

- le nom de l'image ;
- le contexte Docker ;
- le nom du `Dockerfile`.

Il centralise les opérations suivantes :

- récupération du code ;
- génération des métadonnées Docker ;
- préparation de Buildx ;
- construction de l'image avec cache GitHub Actions.

Cette approche permet d'éviter la duplication du code de build et rend la pipeline plus claire et plus maintenable.

## Adaptation du workflow principal

Le fichier `.github/workflows/ci.yml` a été modifié pour que le job `build` appelle désormais le workflow réutilisable.

Le pipeline principal conserve les étapes suivantes :

- `test`
- `build`
- `security`
- `deploy-staging`
- `deploy-production`

Le comportement attendu a été conservé, mais avec une meilleure organisation interne.

## Action composite locale

Une action composite locale a été créée dans `.github/actions/setup-tools/action.yml`.

Cette action permet :

- d'installer Terraform ;
- de vérifier la disponibilité de certains outils comme Terraform, Docker et kubectl.

Elle a ensuite été intégrée dans le job `security` du workflow principal.

## Environnements GitHub

Deux environnements ont été configurés dans les paramètres du dépôt GitHub :

### `staging`

Configuration appliquée :

- aucune règle de protection ;
- déploiement automatique autorisé.

### `production`

Configuration appliquée :

- un reviewer requis ;
- un délai d'attente de 5 minutes ;
- validation manuelle nécessaire avant la poursuite du déploiement.

Cette configuration correspond aux consignes du document de référence.

## Validation du comportement de la pipeline

### Validation sur `develop`

Une exécution de la pipeline a été observée sur la branche `develop`.

Résultats :

- `test` : réussi ;
- `build / docker-build` : réussi ;
- `security` : réussi ;
- `deploy-staging` : réussi ;
- `deploy-production` : non exécuté, ce qui est normal car il est réservé à la branche `main`.

### Validation sur `main`

Une validation a ensuite été réalisée sur la branche `main`.

Résultats :

- `test` : réussi ;
- `build / docker-build` : réussi ;
- `security` : réussi ;
- `deploy-staging` : réussi ;
- `deploy-production` : déclenché avec protection active.

Lors de cette exécution, le déploiement vers `production` a nécessité une approbation manuelle, puis a respecté le délai d'attente configuré. Ce comportement confirme que les règles de protection de l'environnement `production` fonctionnent correctement.

## Difficultés rencontrées

Plusieurs points ont demandé une attention particulière :

- compréhension du rôle exact d'un workflow réutilisable ;
- adaptation du pipeline à la structure réelle du projet ;
- gestion correcte de la distinction entre `staging` et `production` ;
- validation du comportement réel du déploiement protégé dans GitHub Actions.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- séparation claire de la logique Docker dans un workflow dédié ;
- intégration progressive des nouvelles fonctionnalités sans casser le pipeline existant ;
- test sur `develop` pour valider le flux standard ;
- test sur `main` pour valider les protections de l'environnement `production`.

## Conclusion

L'étape `02-github-actions.md` peut être considérée comme terminée. Le projet dispose désormais d'un workflow Docker réutilisable, d'une action composite locale, d'environnements GitHub correctement configurés et d'une pipeline avancée validée sur `develop` et `main`.

# Terraform — Fondamentaux

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `03-terraform-init.md`. L'objectif était de créer une première infrastructure locale avec Terraform, comprendre le cycle `init -> plan -> apply -> destroy` et manipuler le state généré par Terraform.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création du dossier `infra/terraform` ;
- création du fichier `main.tf` ;
- création du fichier `variables.tf` ;
- création des fichiers `dev.tfvars` et `prod.tfvars` ;
- initialisation de Terraform ;
- exécution du plan ;
- application de l'infrastructure en environnement `dev` ;
- vérification du conteneur et de l'URL exposée ;
- consultation du state Terraform ;
- destruction complète des ressources créées.

## Configuration Terraform créée

La configuration a été construite en suivant le code proposé dans le document.

Les ressources principales définies sont :

- un provider Docker local ;
- un réseau Docker nommé `devops-network` ;
- une image Docker `nginx:alpine` ;
- un conteneur Docker nommé dynamiquement selon l'environnement ;
- des outputs pour l'URL d'accès et l'identifiant du conteneur.

Des variables ont également été introduites pour :

- le nom de l'application ;
- le port web exposé ;
- l'environnement (`dev`, `staging`, `prod`).

Deux fichiers de variables ont été créés :

- `dev.tfvars`
- `prod.tfvars`

## Difficultés rencontrées

Deux difficultés principales sont apparues pendant cette étape :

- la version initiale de Terraform installée sur la machine était `1.5.7`, alors que le document exigeait `>= 1.6` ;
- l'initialisation Terraform a ensuite été bloquée par l'impossibilité de télécharger le provider Docker sans accès réseau.

## Solutions apportées

Les solutions suivantes ont été appliquées :

- mise à jour de Terraform vers une version compatible ;
- relance de `terraform init` avec téléchargement correct du provider `kreuzwerker/docker` ;
- reprise normale du cycle Terraform après résolution des blocages.

## Validation du cycle Terraform

### Initialisation

La commande suivante a été exécutée avec succès :

```bash
terraform -chdir=infra/terraform init
```

Résultat :

- installation du provider Docker ;
- génération du fichier `.terraform.lock.hcl`.

### Plan

La commande suivante a été exécutée :

```bash
terraform -chdir=infra/terraform plan -var-file=dev.tfvars
```

Le plan a correctement annoncé la création de :

- `docker_network.app_network`
- `docker_image.nginx`
- `docker_container.web`

L'output attendu `web_url = http://localhost:8080` a également été affiché.

### Apply

La commande suivante a été exécutée :

```bash
terraform -chdir=infra/terraform apply -auto-approve -var-file=dev.tfvars
```

Résultat :

- création du réseau Docker ;
- récupération de l'image `nginx:alpine` ;
- création du conteneur `devops-app-dev` ;
- génération des outputs `web_url` et `container_id`.

### Vérifications après apply

Les validations suivantes ont été réalisées :

```bash
curl http://localhost:8080
docker ps
terraform -chdir=infra/terraform show
terraform -chdir=infra/terraform state list
```

Résultats obtenus :

- l'URL `http://localhost:8080` répond correctement ;
- le conteneur `devops-app-dev` est bien lancé ;
- le state contient les ressources attendues ;
- la configuration Terraform correspond bien à l'infrastructure créée.

### Destroy

La commande suivante a été exécutée :

```bash
terraform -chdir=infra/terraform destroy -auto-approve -var-file=dev.tfvars
```

Résultat :

- suppression du conteneur ;
- suppression de l'image ;
- suppression du réseau créé par Terraform.

Une vérification finale avec `docker ps` et `docker network ls` a confirmé que les ressources créées pour cette étape avaient bien été nettoyées.

## Conclusion

L'étape `03-terraform-init.md` peut être considérée comme terminée. La configuration Terraform de base a été créée avec succès, le cycle complet `init -> plan -> apply -> destroy` a été validé, et le fonctionnement du provider Docker ainsi que la gestion du state ont été correctement vérifiés.

# Terraform — Modules & Remote State

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `04-terraform-modules.md`. L'objectif principal était de transformer la configuration Terraform initiale en une structure modulaire, avec des modules réutilisables et un environnement `dev` dédié utilisant ces modules.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création du module `webapp` ;
- création du module `database` ;
- création de l'environnement `dev` ;
- intégration des modules dans l'environnement `dev` ;
- validation du cycle `init -> plan -> apply -> destroy` sur cette nouvelle structure ;
- gestion correcte d'une variable sensible pour le mot de passe de la base de données.

## Structure modulaire créée

La structure suivante a été ajoutée dans le projet :

- `infra/terraform/modules/webapp`
- `infra/terraform/modules/database`
- `infra/terraform/environments/dev`

Le module `webapp` gère :

- l'image Docker de l'application ;
- plusieurs conteneurs web selon le nombre de réplicas ;
- les ports exposés ;
- les labels liés à l'application et à l'environnement.

Le module `database` gère :

- l'image PostgreSQL ;
- le conteneur de base de données ;
- les variables d'environnement PostgreSQL ;
- le volume de persistance local ;
- la chaîne de connexion exposée en output sensible.

L'environnement `dev` instancie les deux modules au sein d'un réseau Docker dédié.

## Difficultés rencontrées

Une difficulté importante a été rencontrée lors de l'initialisation de l'environnement modulaire :

- Terraform essayait de résoudre le provider `hashicorp/docker` à l'intérieur des modules, alors que le projet utilise `kreuzwerker/docker`.

## Solutions apportées

Pour corriger ce problème, une déclaration explicite du provider `kreuzwerker/docker` a été ajoutée dans les modules `webapp` et `database`.

Après cette correction :

- `terraform init` a fonctionné correctement ;
- les modules ont pu être initialisés sans ambiguïté ;
- le plan Terraform a été généré normalement.

## Validation de l'environnement `dev`

### Initialisation

La commande suivante a été exécutée :

```bash
terraform -chdir=infra/terraform/environments/dev init
```

Résultat :

- initialisation correcte de l'environnement ;
- chargement des modules locaux ;
- installation du provider Docker.

### Plan

Le plan a été exécuté avec un mot de passe transmis comme variable sensible temporaire :

```bash
TF_VAR_db_password=secret123 terraform -chdir=infra/terraform/environments/dev plan -var-file=terraform.tfvars
```

Le plan a correctement annoncé la création de :

- un réseau Docker `devops-dev` ;
- deux conteneurs web ;
- un conteneur PostgreSQL ;
- les outputs `web_urls` et `db_connection`.

### Apply

La commande suivante a été exécutée :

```bash
TF_VAR_db_password=secret123 terraform -chdir=infra/terraform/environments/dev apply -auto-approve -var-file=terraform.tfvars
```

Résultat :

- création de deux conteneurs web :
  - `devops-app-dev-0`
  - `devops-app-dev-1`
- création du conteneur de base de données :
  - `devops-app-db-dev`
- exposition correcte des ports `8080`, `8081` et `5432`.

### Vérifications après apply

Les validations suivantes ont été réalisées :

```bash
curl http://localhost:8080
curl http://localhost:8081
docker ps
terraform -chdir=infra/terraform/environments/dev state list
```

Résultats observés :

- les deux endpoints web répondent correctement ;
- les trois conteneurs attendus sont présents ;
- le state contient bien le réseau, les conteneurs et les images gérés par les modules.

### Destroy

Le nettoyage complet a été exécuté avec la commande suivante :

```bash
TF_VAR_db_password=secret123 terraform -chdir=infra/terraform/environments/dev destroy -auto-approve -var-file=terraform.tfvars
```

Résultat :

- suppression des deux conteneurs web ;
- suppression du conteneur PostgreSQL ;
- suppression des images gérées par Terraform ;
- suppression du réseau `devops-dev`.

Une vérification finale avec `docker ps` et `docker network ls` a confirmé que les ressources de cette étape avaient bien été supprimées.

## Conclusion

L'étape `04-terraform-modules.md` peut être considérée comme terminée. La configuration Terraform a été refactorisée en modules réutilisables, l'environnement `dev` a été validé avec succès, et le cycle complet `init -> plan -> apply -> destroy` a été exécuté correctement dans la nouvelle structure modulaire.

# Ansible — Playbooks & Roles

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `05-ansible-playbook.md`. L'objectif était de mettre en place une base Ansible fonctionnelle avec des conteneurs Docker jouant le rôle de serveurs cibles, puis de valider l'utilisation des playbooks, des handlers, des roles et de l'idempotence.

## Travaux réalisés

Les éléments suivants ont été créés dans `infra/ansible` :

- une infrastructure de test avec `docker-compose.yml` ;
- un inventaire Ansible avec deux groupes de machines ;
- un playbook de base ;
- un playbook Nginx avec handler ;
- une structure en roles (`base`, `nginx`, `app`) ;
- un playbook principal `site.yml` ;
- un fichier `ansible.cfg` pour stabiliser l'exécution locale.

## Infrastructure de test

Deux conteneurs Docker ont été utilisés comme serveurs cibles :

- `ansible-node1`
- `ansible-node2`

Ils sont reliés via le réseau Docker `ansible-net`.

Afin de rendre les conteneurs Ubuntu réellement utilisables par Ansible, la configuration de démarrage a été adaptée pour installer automatiquement :

- `python3`
- `sudo`

Cette adaptation était nécessaire car les images Ubuntu minimales ne disposaient pas des prérequis Ansible au démarrage.

## Inventaire et connectivité

L'inventaire a été structuré en deux groupes :

- `webservers`
- `appservers`

La connexion a été configurée avec :

```yaml
ansible_connection: docker
```

Après ajustement de la configuration Ansible locale, la commande suivante a été validée :

```bash
ansible all -i inventory.yml -m ping
```

Résultat :

- `ansible-node1` : `pong`
- `ansible-node2` : `pong`

## Playbooks et roles

Les éléments suivants ont été mis en place :

### Playbook de base

Le fichier `playbook-base.yml` permet :

- la mise à jour du cache `apt` ;
- l'installation de paquets de base ;
- la création du répertoire `/opt/app` ;
- le déploiement d'un fichier `.env`.

### Playbook Nginx

Le fichier `playbook-nginx.yml` permet :

- l'installation de Nginx ;
- le déploiement de la configuration du site ;
- le déploiement d'une page HTML ;
- le redémarrage de Nginx via un handler.

### Roles

Les roles suivants ont été structurés :

- `base`
- `nginx`
- `app`

Le role `nginx` utilise des templates Jinja2 pour :

- la configuration Nginx ;
- la page d'accueil HTML.

Le role `app` a été gardé simple afin de rester cohérent avec le document tout en évitant un role vide.

## Exécution du playbook principal

Le playbook principal `site.yml` a été exécuté avec succès.

Il applique :

- `base` sur tous les noeuds ;
- `nginx` sur `webservers` ;
- `app` sur `appservers`.

### Première exécution

La première exécution a correctement appliqué les changements attendus :

- installation des paquets ;
- installation de Nginx ;
- déploiement des fichiers de configuration ;
- exécution du handler Nginx ;
- création des fichiers applicatifs sur le serveur d'application.

### Deuxième exécution

La seconde exécution a permis de démontrer l'idempotence :

- `ansible-node1` : `changed=0`
- `ansible-node2` : `changed=0`

Ce résultat confirme que le playbook n'applique plus de modifications inutiles une fois la configuration souhaitée atteinte.

## Difficultés rencontrées

Plusieurs difficultés pratiques ont été rencontrées :

- les conteneurs Ubuntu minimaux ne contenaient pas Python ;
- Ansible cherchait à utiliser des répertoires temporaires non accessibles dans le contexte d'exécution local ;
- l'initialisation des deux conteneurs n'a pas été parfaitement synchrone, ce qui a nécessité une attente supplémentaire avant validation complète.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- ajout de l'installation automatique de `python3` et `sudo` dans les conteneurs ;
- création d'un `ansible.cfg` local utilisant `/tmp` pour les fichiers temporaires ;
- validation de la connectivité seulement après installation effective des prérequis dans les conteneurs.

## Nettoyage

Une fois la validation terminée, l'environnement de test a été nettoyé avec :

```bash
docker compose down
```

Résultat :

- suppression des conteneurs `ansible-node1` et `ansible-node2` ;
- suppression du réseau `ansible-net`.

## Conclusion

L'étape `05-ansible-playbook.md` peut être considérée comme terminée. L'infrastructure de test, l'inventaire, les playbooks, les roles et la démonstration d'idempotence ont été validés avec succès dans un environnement Docker local.

# Docker avancé

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `06-docker-avance.md`. L'objectif était de comparer une image Docker volontairement non optimisée avec une image multi-stage plus propre, puis de valider une stack complète avec Docker Compose, PostgreSQL, Redis et Nginx.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création du fichier `app/Dockerfile.bad` selon l'anti-pattern proposé dans le document ;
- adaptation du `app/Dockerfile` multi-stage pour rester au plus proche des consignes tout en conservant un build fonctionnel sur le projet réel ;
- mise à jour de `app/.dockerignore` ;
- création de `docker-compose.yml` à la racine ;
- création de `nginx/default.conf` ;
- validation du build des images et de la stack complète.

## Image non optimisée

Le fichier `app/Dockerfile.bad` a été conservé dans une version fidèle au document de consignes :

```dockerfile
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y nodejs npm curl wget git python3
COPY . /app
WORKDIR /app
RUN npm install
EXPOSE 3000
CMD ["node", "src/index.js"]
```

Cette image a bien été construite jusqu'au bout. La build s'est révélée très lente sur le réseau disponible, ce qui confirme le caractère peu optimisé de cette approche.

Résultat observé :

- `app:bad` = `1.57GB`

## Dockerfile optimisé multi-stage

Le fichier `app/Dockerfile` a été structuré en trois stages :

- `deps`
- `test`
- `production`

Les points principaux validés sont les suivants :

- utilisation d'une image Alpine plus légère ;
- séparation des dépendances, des tests et de la production ;
- exécution du conteneur avec un utilisateur non-root `appuser` ;
- présence d'un `HEALTHCHECK` ;
- réduction importante de la taille de l'image finale.

Une légère adaptation technique a été conservée pour le projet réel afin de permettre la présence du répertoire `node_modules` dans le stage `deps`, tout en gardant la logique du document.

Résultat observé :

- `app:optimized` = `194MB`

## Comparaison des tailles

La comparaison finale des tailles montre un écart très important entre les deux approches :

- `app:bad` = `1.57GB`
- `app:optimized` = `194MB`

Cette comparaison valide l'intérêt du multi-stage build et d'une image de production plus minimale.

## Sécurité et inspection de l'image optimisée

Les vérifications suivantes ont été effectuées :

```bash
docker run --rm app:optimized whoami
docker history app:optimized
```

Résultats :

- le conteneur optimisé s'exécute avec l'utilisateur `appuser` ;
- l'historique des layers confirme une image plus propre et mieux structurée que l'image non optimisée.

## Validation de la stack Docker Compose

La stack suivante a été mise en place :

- `app`
- `postgres`
- `redis`
- `nginx`

La commande suivante a été exécutée :

```bash
docker compose up -d
```

Puis les vérifications suivantes ont été réalisées :

```bash
docker compose ps
docker compose logs app
curl http://localhost:80
curl http://localhost:80/health
```

Résultats observés :

- les quatre services ont démarré correctement ;
- l'application a bien démarré sur le port `3000` ;
- Nginx a correctement joué le rôle de reverse proxy ;
- `curl http://localhost:80` a retourné un statut `200 OK` avec le JSON attendu ;
- `curl http://localhost:80/health` a retourné un statut `200 OK`.

## Difficultés rencontrées

Plusieurs difficultés ont été rencontrées pendant cette étape :

- le `Dockerfile.bad` original s'est révélé extrêmement lent à construire sur le réseau disponible ;
- le `Dockerfile` optimisé fourni par le document supposait l'existence directe de `node_modules` dans le stage `deps`, ce qui ne fonctionnait pas tel quel avec le projet réel ;
- la comparaison avant/après a nécessité plusieurs itérations afin de conserver au maximum le code du professeur tout en gardant des builds exploitables localement.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- le `Dockerfile.bad` a été conservé dans sa version d'origine afin de rester fidèle au document, et la build a été menée jusqu'au bout malgré sa lenteur ;
- le `Dockerfile` optimisé a été adapté de manière minimale pour garantir la présence du répertoire `node_modules` dans le stage `deps`, sans modifier l'intention pédagogique du multi-stage ;
- la validation de la stack Docker Compose a été effectuée une fois les images et la configuration stabilisées.

## Nettoyage

Une fois la validation terminée, la stack a été arrêtée avec :

```bash
docker compose down -v
```

Résultat :

- suppression des conteneurs ;
- suppression du réseau ;
- suppression du volume PostgreSQL utilisé pour les tests.

## Conclusion

L'étape `06-docker-avance.md` peut être considérée comme terminée. La comparaison entre une image non optimisée et une image multi-stage a été validée, l'exécution non-root a été confirmée, et la stack complète avec Docker Compose, PostgreSQL, Redis et Nginx a été testée avec succès.

# Kubernetes — Déployer une application

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `07-kubernetes-deploy.md`. L'objectif était de déployer une application multi-tiers sur Kubernetes avec des manifestes YAML simples, en utilisant un namespace dédié, une ConfigMap, un Secret, un déploiement PostgreSQL et un déploiement applicatif.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création du namespace `devops-training` ;
- création du fichier `k8s/configmap.yaml` ;
- création du Secret `app-secrets` en ligne de commande ;
- création du fichier `k8s/postgres.yaml` avec PVC, Deployment et Service ;
- création du fichier `k8s/app.yaml` avec Deployment et Service ;
- chargement des images locales dans Minikube ;
- validation du déploiement de l'application ;
- démonstration du scaling, du rolling update et du rollback.

## Namespace, ConfigMap et Secret

Le namespace dédié a été créé avec :

```bash
kubectl create namespace devops-training
kubectl config set-context --current --namespace=devops-training
```

La ConfigMap a été définie dans `k8s/configmap.yaml` pour regrouper les variables de configuration principales de l'application.

Le Secret a été créé en ligne de commande, conformément au document, afin d'éviter de committer les identifiants dans un fichier YAML :

```bash
kubectl create secret generic app-secrets \
  --namespace=devops-training \
  --from-literal=DB_USER=appuser \
  --from-literal=DB_PASSWORD=supersecret123
```

## Déploiement PostgreSQL

Le fichier `k8s/postgres.yaml` contient :

- un `PersistentVolumeClaim` ;
- un `Deployment` PostgreSQL ;
- un `Service` `ClusterIP`.

Le pod PostgreSQL a été validé avec :

- la montée du conteneur ;
- le `readinessProbe` en état `Ready` ;
- l'attachement correct du volume persistant.

## Déploiement de l'application

Le fichier `k8s/app.yaml` contient :

- un `Deployment` `devops-app` avec `3` replicas ;
- un `Service` `ClusterIP` `devops-app-svc` ;
- les variables d'environnement injectées à partir de la ConfigMap et du Secret ;
- une `readinessProbe` et une `livenessProbe` ;
- des limites et réservations de ressources ;
- une stratégie `RollingUpdate`.

L'image locale `devops-app:1.0.0` a été chargée dans Minikube avant le déploiement.

## Vérification du déploiement

Les commandes suivantes ont été utilisées pour vérifier le déploiement :

```bash
kubectl get pods
kubectl get svc
kubectl logs -l app=devops-app --tail=50
kubectl port-forward svc/devops-app-svc 8080:80
curl http://localhost:8080
```

Résultats observés :

- les pods PostgreSQL et application sont passés à l'état `Running` puis `Ready` ;
- les services `postgres-svc` et `devops-app-svc` ont été créés correctement ;
- les logs de l'application montrent le démarrage du serveur sur le port `3000` ;
- l'accès via `port-forward` a retourné `200 OK` avec la réponse attendue.

## Scaling et rolling update

La partie finale du document a également été testée :

```bash
kubectl scale deployment devops-app --replicas=5
kubectl set image deployment/devops-app app=devops-app:1.0.1
kubectl rollout status deployment/devops-app
kubectl rollout undo deployment/devops-app
kubectl rollout history deployment/devops-app
```

Résultats observés :

- le déploiement a bien été scalé à `5` replicas ;
- le rolling update vers l'image `devops-app:1.0.1` a été lancé puis validé ;
- le rollback a été exécuté avec succès ;
- l'historique du déploiement a bien affiché plusieurs révisions.

## Difficultés rencontrées

Plusieurs difficultés ont été rencontrées pendant cette étape :

- Minikube était arrêté au début, il a donc fallu relancer le cluster avant tout déploiement ;
- le contexte Kubernetes était revenu sur le namespace `default` ;
- la partie `Ingress` n'a pas été activée, car elle reste optionnelle et dépend de la présence d'un ingress controller déjà installé ;
- les pods ont nécessité quelques secondes supplémentaires pour passer complètement à l'état `Ready` après l'application des manifestes et après le rollback.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- redémarrage de Minikube puis vérification de `kubectl` avant de créer les manifestes ;
- application des fichiers dans un ordre simple et proche du document ;
- utilisation de `port-forward` pour tester rapidement l'application sans ajouter d'Ingress inutile à ce stade ;
- validation complète du cycle `deploy -> scale -> update -> rollback` pour s'assurer que le déploiement reste fonctionnel.

## Conclusion

L'étape `07-kubernetes-deploy.md` peut être considérée comme validée dans sa partie principale. Le namespace, la ConfigMap, le Secret, le déploiement PostgreSQL, le déploiement applicatif, l'exposition du service, le scaling, le rolling update et le rollback ont été testés avec succès sur Minikube.

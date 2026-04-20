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

# Helm & Kustomize

## Contexte

Cette partie du rapport présente le travail réalisé à partir du document `08-helm-charts.md`. L'objectif était de transformer le déploiement Kubernetes précédent en chart Helm simple, puis de découvrir Kustomize comme alternative plus légère.

## Travaux réalisés

Les éléments suivants ont été mis en place :

- création d'un chart Helm `devops-app-chart` ;
- simplification de la structure générée par `helm create` pour garder un niveau débutant et lisible ;
- personnalisation de `Chart.yaml` et `values.yaml` ;
- ajout de `values-dev.yaml` et `values-prod.yaml` ;
- ajout de templates Helm simples pour l'application, PostgreSQL, la ConfigMap, le Secret, le Service, l'Ingress et le HPA ;
- création d'une structure Kustomize `base` / `overlays`.

## Chart Helm

Le chart Helm créé contient les éléments principaux suivants :

- `Chart.yaml`
- `values.yaml`
- `values-dev.yaml`
- `values-prod.yaml`
- `templates/configmap.yaml`
- `templates/secret.yaml`
- `templates/postgres-pvc.yaml`
- `templates/postgres-deployment.yaml`
- `templates/postgres-service.yaml`
- `templates/deployment.yaml`
- `templates/service.yaml`
- `templates/ingress.yaml`
- `templates/hpa.yaml`

Le choix a été fait de garder un chart simple, sans surcharger la structure avec des templates supplémentaires peu utiles pour cette étape.

## Values par environnement

Deux fichiers de valeurs ont été ajoutés :

- `values-dev.yaml`
- `values-prod.yaml`

Le fichier `values-dev.yaml` conserve une configuration légère, avec une seule réplique et des ressources réduites.

Le fichier `values-prod.yaml` applique une configuration plus ambitieuse :

- plus de ressources ;
- davantage de réplicas ;
- activation de l'autoscaling.

## Validation Helm

Les validations suivantes ont été effectuées :

```bash
helm lint devops-app-chart
helm template devops-app devops-app-chart -f devops-app-chart/values-dev.yaml --set secret.dbPassword=secret123
helm install devops-app devops-app-chart -f devops-app-chart/values-dev.yaml -n devops-training --set secret.dbPassword=secret123
helm list -n devops-training
helm upgrade devops-app devops-app-chart -f devops-app-chart/values-prod.yaml -n devops-training --set secret.dbPassword=secret123
helm rollback devops-app 1 -n devops-training
helm history devops-app -n devops-training
```

Résultats observés :

- `helm lint` a été validé ;
- le rendu YAML avec `helm template` a été généré correctement ;
- l'installation du chart dans le namespace `devops-training` a réussi ;
- l'upgrade a créé une nouvelle révision ;
- le rollback a été exécuté avec succès ;
- l'historique de la release a bien montré les révisions successives.

## Kustomize

La structure suivante a été ajoutée :

- `k8s/base`
- `k8s/overlays/dev`
- `k8s/overlays/prod`

Le but est de garder une alternative simple à Helm pour montrer une autre manière de gérer des variantes d'environnement.

La validation suivante a été faite :

```bash
kubectl kustomize k8s/overlays/dev
kubectl apply -k k8s/overlays/dev
```

Résultats observés :

- le rendu Kustomize du dossier `dev` est correct ;
- l'overlay `dev` a pu être appliqué au cluster.

## Comparaison Helm vs Kustomize

Le travail réalisé permet de comparer les deux approches :

- **Helm** est plus adapté lorsqu'il faut gérer des variables, des releases, des upgrades et des rollbacks ;
- **Kustomize** est plus simple pour modifier quelques ressources YAML existantes avec des overlays.

Dans ce projet, Helm apparaît comme la solution la plus complète pour la suite, tandis que Kustomize reste une bonne alternative légère pour des cas simples.

## Difficultés rencontrées

Plusieurs difficultés ont été rencontrées pendant cette étape :

- le chart généré automatiquement par `helm create` contenait plusieurs fichiers inutiles ou trop avancés pour cette étape ;
- certains noms de ressources pouvaient entrer en conflit avec ceux déjà créés dans l'étape `07` ;
- le template de test généré par défaut faisait référence aux anciens helpers du chart ;
- l'autoscaling activé dans la version `prod` reste dépendant du contexte du cluster et des métriques disponibles.

## Solutions apportées

Les solutions suivantes ont été mises en place :

- simplification du chart pour garder uniquement les fichiers réellement utiles ;
- renommage de certaines ressources Helm pour éviter les conflits avec les manifestes Kubernetes déjà présents ;
- suppression du test généré automatiquement qui n'était plus cohérent après simplification ;
- validation progressive avec `helm lint`, `helm template`, `helm install`, `helm upgrade`, `helm rollback` et `helm history`.

## Conclusion

L'étape `08-helm-charts.md` peut être considérée comme validée. Un chart Helm simple et fonctionnel a été créé, les valeurs `dev` et `prod` ont été testées, le cycle `install -> upgrade -> rollback` a été validé et une alternative Kustomize a également été mise en place.

# 09 - Prometheus & Grafana

## Objectif

L'objectif de cette étape était de mettre en place une stack de monitoring locale avec Prometheus pour la collecte de métriques, Grafana pour la visualisation et AlertManager pour la gestion des alertes.

## Mise en place réalisée

Les éléments suivants ont été créés :

- `monitoring/docker-compose.yml`
- `monitoring/prometheus/prometheus.yml`
- `monitoring/prometheus/alerts.yml`
- `monitoring/alertmanager/alertmanager.yml`
- `monitoring/grafana/provisioning/datasources/prometheus.yml`
- `monitoring/grafana/provisioning/dashboards/default.yml`
- `monitoring/grafana/dashboards/app-overview.json`
- `monitoring/.env.example`

La stack mise en place contient les services suivants :

- `prometheus`
- `grafana`
- `alertmanager`
- `node-exporter`
- `webhook-mock`
- `app`

Le choix a été fait de garder une structure simple et proche du document du professeur, avec des fichiers lisibles et peu de personnalisation inutile.

## Configuration Prometheus

Prometheus a été configuré pour scraper :

- lui-même sur `localhost:9090`
- `node-exporter` sur `node-exporter:9100`
- l'application sur `app:3000/metrics`

Le fichier `alerts.yml` contient bien les 5 règles d'alertes demandées :

- `AppDown`
- `HighLatency`
- `HighErrorRate`
- `HighCPU`
- `DiskAlmostFull`

## Configuration Grafana

Grafana a été provisionné automatiquement avec :

- une datasource Prometheus ;
- un dashboard `DevOps App Overview`.

Le dashboard défini dans `app-overview.json` permet de visualiser :

- le taux de requêtes ;
- la latence P95 ;
- le taux d'erreur ;
- le nombre d'instances actives.

## Configuration AlertManager

AlertManager a été configuré avec :

- un receiver par défaut ;
- un receiver dédié aux alertes `critical` ;
- un envoi des webhooks vers `http://webhook-mock:5001/webhook`.

Le service `webhook-mock` a été utilisé pour vérifier localement que les notifications étaient bien envoyées.

## Validation réalisée

Les validations suivantes ont été effectuées :

```bash
cd monitoring
docker compose up -d
docker compose ps
curl http://localhost:9090/api/v1/targets
curl http://localhost:3001/login
curl http://localhost:9093
curl http://localhost:3000/health
curl http://localhost:9090/api/v1/rules
curl http://localhost:9090/api/v1/alerts
docker compose logs webhook-mock
```

Résultats observés :

- tous les services de la stack ont démarré correctement ;
- les targets Prometheus étaient bien en état `UP` ;
- Grafana était accessible sur `http://localhost:3001` ;
- AlertManager était accessible sur `http://localhost:9093` ;
- l'application monitorée répondait correctement sur `/health`.

## Vérification des alertes

Pour valider concrètement la chaîne d'alerte, l'application a été arrêtée temporairement avec :

```bash
docker compose stop app
```

Après le délai prévu par la règle `AppDown`, les vérifications suivantes ont été observées :

- Prometheus indiquait l'alerte `AppDown` en état `firing` ;
- `webhook-mock` recevait bien un `POST /webhook` avec l'alerte critique ;
- après redémarrage de l'application, l'alerte passait ensuite en `resolved` ;
- `webhook-mock` recevait également le webhook de résolution.

Cette vérification permet de confirmer que l'intégration Prometheus -> AlertManager -> webhook fonctionne correctement.

## Requêtes PromQL utilisées

Plusieurs requêtes PromQL du document ont été reprises pour cette étape, notamment :

```promql
rate(http_requests_total[5m])
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100
```

Ces requêtes permettent de suivre respectivement :

- le taux de requêtes ;
- la latence ;
- le taux d'erreur.

## Difficultés rencontrées

Les principales difficultés rencontrées pendant cette étape ont été les suivantes :

- il fallait garder une stack de monitoring simple sans rendre la structure trop avancée ;
- la validation de l'alerte `AppDown` demandait d'attendre réellement le temps défini dans la règle ;
- il fallait vérifier non seulement le déclenchement de l'alerte, mais aussi la réception du webhook par le service mock ;
- il fallait ensuite confirmer que l'alerte repassait correctement en `resolved`.

## Solutions apportées

Les solutions suivantes ont été retenues :

- conservation d'une configuration proche du document du professeur ;
- ajout d'un service `webhook-mock` très simple pour visualiser clairement les notifications ;
- validation progressive de chaque composant avant de tester l'alerte complète ;
- arrêt temporaire du service `app` pour provoquer un cas réel d'indisponibilité ;
- redémarrage du service pour vérifier aussi la résolution de l'alerte.

## Conclusion

L'étape `09-prometheus-grafana.md` peut être considérée comme validée. La stack Prometheus + Grafana + AlertManager fonctionne localement, les règles d'alertes sont chargées, le dashboard Grafana est provisionné et l'envoi des webhooks vers `webhook-mock` a été vérifié en situation réelle.

# 10 - DevSecOps - Scan & Conformité

## Objectif

L'objectif de cette étape était d'intégrer des vérifications de sécurité plus complètes dans le projet, à la fois dans le pipeline CI/CD et dans les fichiers du dépôt.

## Éléments ajoutés

Les éléments suivants ont été créés ou mis à jour :

- mise à jour du job `security` dans `.github/workflows/ci.yml` ;
- création de `policies/dockerfile.rego` ;
- création de `policies/k8s.rego` ;
- création de `SECURITY-CHECKLIST.md`.

Le but a été de rester proche du document du professeur tout en gardant une mise en œuvre simple et lisible.

## Intégration Trivy

Le job `security` du pipeline a été enrichi avec plusieurs contrôles Trivy :

- scan du filesystem de l'application ;
- scan de configuration du Dockerfile ;
- scan de configuration des fichiers IaC ;
- build d'une image temporaire `devops-app:scan` ;
- génération d'un rapport SARIF ;
- scan de l'image Docker avec seuil bloquant sur les vulnérabilités `CRITICAL`.

Le rapport SARIF est ensuite envoyé à GitHub et également conservé comme artefact.

## Détection de secrets

La détection de secrets a été ajoutée au pipeline avec `gitleaks/gitleaks-action@v2`.

Une vérification locale a aussi été réalisée pour confirmer qu'aucun secret réel n'était présent dans le dépôt au moment du test.

## Politiques OPA / Conftest

Deux fichiers de politiques ont été ajoutés :

- `policies/dockerfile.rego`
- `policies/k8s.rego`

Les règles mises en place permettent notamment de vérifier :

- qu'un conteneur ne tourne pas en `root` ;
- qu'un `USER` est bien défini dans le Dockerfile ;
- qu'une image n'utilise pas `:latest` ;
- qu'un `HEALTHCHECK` est présent ;
- qu'un déploiement Kubernetes ne déclare pas de conteneur privilégié ;
- que les deployments Kubernetes possèdent des `resource limits` ;
- que les images Kubernetes ont bien un tag explicite.

## Checklist sécurité

Un fichier `SECURITY-CHECKLIST.md` a été ajouté pour récapituler l'état actuel du projet sur :

- les images Docker ;
- Kubernetes ;
- le pipeline ;
- l'infrastructure.

Cette checklist a été remplie de manière honnête selon l'état réel du projet à cette étape.

## Validation réalisée

Les validations suivantes ont été effectuées localement :

```bash
docker build -t devops-app:scan app/
docker run --rm -v "$PWD:/project" -w /project aquasec/trivy:latest fs --scanners vuln --severity HIGH,CRITICAL --exit-code 1 --format table app/
docker run --rm -v "$PWD:/project" -w /project aquasec/trivy:latest config --severity HIGH,CRITICAL --exit-code 0 app/Dockerfile
docker run --rm -v "$PWD:/project" -w /project aquasec/trivy:latest config --severity HIGH,CRITICAL --exit-code 0 infra/
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --scanners vuln --severity CRITICAL --exit-code 1 --format table devops-app:scan
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:/project" -w /project aquasec/trivy:latest image --scanners vuln --severity HIGH,CRITICAL --format sarif --output /project/trivy-results.sarif devops-app:scan
docker run --rm -v "$PWD:/repo" zricethezav/gitleaks:latest detect --source /repo --verbose
docker run --rm -v "$PWD:/project" -w /project openpolicyagent/conftest test app/Dockerfile --policy policies --namespace dockerfile --parser dockerfile
docker run --rm -v "$PWD:/project" -w /project openpolicyagent/conftest test k8s/app.yaml k8s/postgres.yaml --policy policies --namespace kubernetes
```

Résultats observés :

- l'image `devops-app:scan` a été construite correctement ;
- le scan Trivy du Dockerfile n'a remonté aucune misconfiguration `HIGH` ou `CRITICAL` ;
- le scan Trivy de l'infrastructure Terraform n'a remonté aucune misconfiguration `HIGH` ou `CRITICAL` ;
- le scan Trivy de l'image n'a remonté aucune vulnérabilité `CRITICAL` ;
- un fichier SARIF a bien été généré ;
- Gitleaks n'a détecté aucune fuite de secret ;
- les politiques OPA / Conftest sont passées avec succès.

## Point important sur le scan d'image

Le scan détaillé de l'image Docker a tout de même remonté des vulnérabilités `HIGH` venant de composants inclus dans l'image Node de base, en particulier dans l'écosystème `npm`.

Dans ce contexte, le choix retenu a été le suivant :

- continuer à générer un rapport SARIF avec le niveau `HIGH,CRITICAL` ;
- conserver une visibilité complète sur ces vulnérabilités ;
- ne rendre le pipeline bloquant que sur les vulnérabilités `CRITICAL` pour l'image.

Cette approche garde le pipeline utile et réaliste pour le projet, sans masquer les informations de sécurité importantes.

## Difficultés rencontrées

Les principales difficultés rencontrées pendant cette étape ont été les suivantes :

- il fallait intégrer plusieurs outils de sécurité sans alourdir excessivement la structure du projet ;
- certaines vulnérabilités `HIGH` provenaient de la base Node de l'image et non du code applicatif lui-même ;
- le dépôt ne contient pas de dépendances externes Node.js, ce qui rend le scan filesystem moins démonstratif sur la partie dépendances ;
- il fallait garder des politiques OPA simples, compréhensibles et adaptées au niveau du projet.

## Solutions apportées

Les solutions suivantes ont été retenues :

- réutilisation du job `security` existant plutôt que création d'un pipeline parallèle ;
- ajout d'une génération SARIF pour garder une trace exploitable dans GitHub ;
- utilisation d'un seuil bloquant `CRITICAL` pour l'image, tout en conservant le reporting `HIGH,CRITICAL` ;
- écriture de politiques Rego courtes et très proches des exemples du document ;
- ajout d'une checklist sécurité simple pour visualiser ce qui est déjà couvert et ce qui reste à améliorer.

## Conclusion

L'étape `10-devsecops-scan.md` peut être considérée comme validée. Le pipeline intègre désormais Trivy, Gitleaks et des contrôles OPA / Conftest, une checklist sécurité a été ajoutée et les vérifications principales ont été testées localement avec succès.

# 11 - GitOps avec ArgoCD

## Objectif

L'objectif de cette étape était de mettre en place une logique GitOps avec ArgoCD, c'est-à-dire utiliser Git comme source de vérité pour le déploiement Kubernetes.

## Choix retenu pour le projet

Le document propose soit un dépôt GitOps séparé, soit un dossier `gitops/` dans le projet. Le choix retenu a été de créer un dossier `gitops/` directement dans ce dépôt afin de garder une structure simple et facile à suivre.

L'image applicative utilisée pour la démonstration est `devops-app:1.0.1`. Dans ce contexte de formation sur Minikube, l'image a été chargée localement dans le cluster avec `minikube image load`, ce qui a permis de valider le workflow sans dépendre d'une registry externe.

## Structure GitOps mise en place

La structure suivante a été ajoutée :

- `gitops/apps/devops-app/base`
- `gitops/apps/devops-app/overlays/dev`
- `gitops/apps/devops-app/overlays/staging`
- `gitops/apps/devops-app/overlays/prod`
- `gitops/argocd/project.yaml`
- `gitops/argocd/app-dev.yaml`
- `gitops/argocd/app-staging.yaml`
- `gitops/argocd/app-prod.yaml`

Le dossier `base` contient :

- un `Deployment` simple ;
- un `Service` ;
- un `kustomization.yaml`.

Chaque overlay permet de faire varier :

- le namespace ;
- le préfixe de nom ;
- le nombre de replicas.

## Installation ArgoCD

ArgoCD a été installé dans le cluster Minikube avec les étapes suivantes :

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=240s
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
kubectl port-forward svc/argocd-server -n argocd 8443:443
argocd login localhost:8443 --insecure --username admin --password <password>
```

ArgoCD a bien été rendu accessible localement et le login CLI a été validé.

## Projet et application ArgoCD

Un `AppProject` a été créé avec le nom :

- `devops-training`

Puis une application ArgoCD `devops-app-dev` a été créée pour l'overlay `dev`.

Les paramètres principaux sont :

- `repoURL` : `https://github.com/Pharosi/devops-app.git`
- `path` : `gitops/apps/devops-app/overlays/dev`
- `syncPolicy.automated`
- `CreateNamespace=true`

## Validation réalisée

Les validations suivantes ont été effectuées :

```bash
kubectl kustomize gitops/apps/devops-app/overlays/dev
kubectl kustomize gitops/apps/devops-app/overlays/staging
kubectl kustomize gitops/apps/devops-app/overlays/prod
minikube image load devops-app:1.0.1
kubectl apply -f gitops/argocd/project.yaml
kubectl apply -f gitops/argocd/app-dev.yaml
argocd app list --server localhost:8443 --insecure
argocd app get devops-app-dev --server localhost:8443 --insecure
argocd app history devops-app-dev --server localhost:8443 --insecure
kubectl get deployment dev-devops-app -n devops-dev
```

Résultats observés :

- les trois overlays Kustomize ont été rendus correctement ;
- l'image `devops-app:1.0.1` a été chargée dans Minikube ;
- l'application `devops-app-dev` a été créée avec succès ;
- ArgoCD affichait l'application en état `Synced` et `Healthy` ;
- le deployment `dev-devops-app` a bien été créé dans le namespace `devops-dev`.

## Démonstration GitOps

Pour démontrer le fonctionnement GitOps, une modification a été faite dans le dépôt sur :

- `gitops/apps/devops-app/overlays/dev/replicas-patch.yaml`

La valeur est passée de :

- `replicas: 1`

à :

- `replicas: 2`

Après push du commit sur la branche suivie par ArgoCD, les constats suivants ont été observés :

- l'application est d'abord passée en `OutOfSync` ;
- ArgoCD a ensuite resynchronisé automatiquement l'application ;
- l'historique ArgoCD montrait une nouvelle révision ;
- le deployment Kubernetes est bien passé à `2` replicas prêts.

Cette partie valide concrètement le principe GitOps : modification du dépôt -> détection du changement -> synchronisation du cluster.

## Difficultés rencontrées

Les principales difficultés rencontrées pendant cette étape ont été les suivantes :

- l'installation initiale d'ArgoCD via `kubectl apply` a remonté une erreur sur la taille d'une annotation CRD ;
- il fallait garder une structure GitOps simple, sans introduire trop d'éléments avancés ;
- le document suppose une image disponible dans une registry, alors que la validation locale a été faite sur Minikube ;
- le polling automatique d'ArgoCD peut prendre un peu de temps avant de détecter un nouveau commit.

## Solutions apportées

Les solutions suivantes ont été retenues :

- reprise de l'installation avec `kubectl apply --server-side` pour contourner le problème du CRD ;
- choix d'une structure `gitops/` intégrée au dépôt plutôt qu'un second repository séparé ;
- chargement local de l'image dans Minikube avec `minikube image load` ;
- utilisation d'un refresh ArgoCD pour accélérer la détection du nouveau commit pendant la démonstration, tout en laissant la synchronisation en mode automatique.

## Conclusion

L'étape `11-gitops-argocd.md` peut être considérée comme validée. ArgoCD a été installé dans Minikube, une structure GitOps simple a été créée dans le dépôt, une application `dev` a été synchronisée avec succès et une modification du dépôt a bien provoqué une mise à jour automatique du déploiement.

# Compléments optionnels réalisés

## 04 - Bonus Terraform Workspaces

Le bonus `workspaces` de l'étape `04` a été complété avec :

- création des workspaces `dev` et `staging` dans `infra/terraform/environments/dev` ;
- ajout du fichier `workspace-staging.tfvars` ;
- application d'un environnement `staging` isolé avec :
  - `environment = "staging"`
  - `web_port = 8180`
  - `db_port = 5433`

Validation effectuée :

```bash
cd infra/terraform/environments/dev
terraform workspace new dev
terraform workspace new staging
terraform apply -auto-approve -var-file=workspace-staging.tfvars -var="db_password=secret456"
curl -I http://localhost:8180
terraform destroy -auto-approve -var-file=workspace-staging.tfvars -var="db_password=secret456"
terraform workspace select default
```

Résultats observés :

- les workspaces ont bien été créés ;
- l'environnement `staging` a été déployé sans entrer en conflit avec `dev` ;
- l'accès HTTP sur `http://localhost:8180` a répondu correctement ;
- les ressources `staging` ont ensuite été détruites pour laisser un environnement propre.

## 07 - Ingress optionnel Kubernetes

L'Ingress optionnel de l'étape `07` a également été ajouté avec :

- création de `k8s/ingress.yaml` ;
- activation de l'addon `ingress` dans Minikube ;
- déploiement de l'Ingress `devops-app-ingress`.

Validation effectuée :

```bash
minikube addons enable ingress
kubectl apply -f k8s/ingress.yaml
kubectl get ingress devops-app-ingress -n devops-training
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8088:80
curl -I -H "Host: devops.local" http://localhost:8088
```

Résultats observés :

- le controller ingress NGINX a été démarré ;
- l'Ingress a bien obtenu une adresse dans son status ;
- le routage a été validé avec un `curl` utilisant le host `devops.local` ;
- la réponse HTTP était `200 OK`.

## 10 - Fichier `.trivyignore`

Le document `10` proposait un fichier `.trivyignore` en aide. Un fichier a été ajouté à la racine du projet.

Choix retenu :

- le fichier est présent ;
- aucune vulnérabilité n'y est ignorée pour le moment ;
- des exemples commentés ont été laissés pour montrer le mécanisme sans masquer artificiellement des résultats.

## Conclusion

Ces compléments optionnels permettent de renforcer encore le projet :

- démonstration des workspaces Terraform ;
- ajout d'un Ingress Kubernetes fonctionnel ;
- préparation propre d'un mécanisme `.trivyignore` sans contourner les scans existants.

# Checklist Sécurité DevOps

## Images Docker
- [x] Base image minimale (alpine)
- [x] Pas de tag :latest
- [x] User non-root
- [x] HEALTHCHECK présent
- [x] Scan Trivy sans vulnérabilité critique
- [x] .dockerignore complet

## Kubernetes
- [x] Resource limits sur chaque conteneur
- [x] Pas de conteneur privilégié
- [ ] NetworkPolicies en place
- [x] Secrets via Secret Kubernetes (pas en clair dans les manifests)
- [ ] RBAC configuré

## Pipeline
- [x] Secrets dans GitHub Secrets (GITHUB_TOKEN)
- [x] Scan de dépendances automatique
- [x] Scan d'image automatique
- [x] Détection de secrets (gitleaks)
- [x] Environnements avec protection

## Infrastructure
- [ ] State Terraform chiffré
- [ ] Pas de credentials en dur dans les fichiers IaC
- [ ] Principe du moindre privilège (IAM)

# Pratiquons CI/CD

## Description du projet

Ce projet est un clone du **Symfony Demo**, l'application de référence officielle publiée par l'équipe Symfony, mis à jour et personnalisé.

## Prérequis

- Git installé sur votre machine
- Composer installé
- (Optionnel, mais recommandé) la CLI Symfony installée

## Étape 1 — Récupérer le projet

Clonez le dépôt du cours, puis installez les dépendances PHP :

```bash
git clone https://github.com/romyklk/sym-demo-ci-cd.git
cd sym-demo-ci-cd
composer install
```

## Étape 2 — Ce qui est déjà en place dans le dépôt

Avant de démarrer les exercices, voici un récapitulatif de ce qui a déjà été préparé pour vous dans ce dépôt, afin que vous sachiez exactement sur quelle base vous travaillez.


- **Une suite de tests PHPUnit fonctionnelle** est déjà présente et exécutable immédiatement.
- **PHP CS Fixer est déjà installé** comme dépendance de développement, prêt à formater le code.
- **PHPStan est déjà installé et configuré**, via le fichier `phpstan.dist.neon`, avec un niveau de rigueur fixé à `6` sur une échelle de `0` à `9`.
- **Les linters Symfony** (Twig, YAML, container de services, entités Doctrine) sont utilisables immédiatement via les commandes `bin/console`, sans configuration supplémentaire.

## Étape 3 — Lancer le projet et vérifier l'installation

Démarrez l'application en local, avec l'une de ces deux méthodes :

```bash
# Avec le serveur PHP intégré
php -S localhost:8000 -t public/

# Ou avec la CLI Symfony
symfony serve -d
```

### Les tests unitaires

Puis lancez la suite de tests fournie, pour vérifier que votre environnement fonctionne correctement :

```bash
php bin/phpunit
```

Si cette commande s'exécute sans erreur, vous pouvez passer aux exercices suivants.

## Étape 4 — Formater le code avec PHP CS Fixer

PHP CS Fixer est un outil qui reformate automatiquement le code PHP pour le rendre conforme à des règles de style prédéfinies (indentation, espacement, placement des accolades, etc.). C'est un outil de **correction automatique** : contrairement à un simple linter, il modifie directement les fichiers.


**Vérification sans modification :** Cette commande permet de vérifier si le code respecte déjà les règles de style, sans apporter de modifications aux fichiers.
```bash
vendor/bin/php-cs-fixer fix --dry-run
```

**Vérification et correction :** Cette commande permet de vérifier le code et d'appliquer automatiquement les corrections nécessaires.
```bash
vendor/bin/php-cs-fixer fix
```



## Étape 5 — Analyser le code avec PHPStan

PHPStan est un outil d'**analyse statique** : il examine le code sans l'exécuter, pour détecter des erreurs potentielles avant même de lancer l'application. Il peut par exemple repérer un appel à une méthode qui n'existe pas sur un objet, ou une incohérence de type entre une variable déclarée et sa valeur réelle.


```bash
vendor/bin/phpstan analyse
```

Cette commande analyse les dossiers définis dans `phpstan.dist.neon` (`bin`, `config`, `public`, `src`, `tests`), avec le niveau `6` déjà configuré dans le projet.

Un point important à retenir : PHPStan est un outil d'**analyse uniquement**. Contrairement à PHP CS Fixer, il ne corrige jamais le code automatiquement : il se contente de signaler les problèmes, et c'est à vous de les corriger manuellement. L'option `--fix` existe encore dans certaines versions, mais elle ne déclenche plus rien : elle affiche simplement un message invitant à utiliser **PHPStan Pro**, une offre payante avec interface web, qui n'est pas nécessaire pour ce cours.

## Étape 6 — Vérifier le code avec les linters

Les linters analysent le code source pour repérer des erreurs de syntaxe ou des problèmes de style, sans jamais corriger automatiquement les fichiers : ils se contentent de signaler ce qui ne va pas.

### Linter Twig

```bash
bin/console lint:twig templates/
```

### Linter YAML

```bash
bin/console lint:yaml config/
```

L'option `--parse-tags` va plus loin : elle interprète également les balises spécifiques présentes dans les fichiers YAML, pour détecter des erreurs supplémentaires liées à leur contenu.

```bash
bin/console lint:yaml config/ --parse-tags
```

### Linter du container de services

```bash
bin/console lint:container --no-debug
```

### Vérification des entités Doctrine

```bash
bin/console doctrine:schema:validate
bin/console doctrine:schema:validate --skip-sync
bin/console doctrine:schema:validate --skip-sync -vvv --no-interaction
```

Si cette commande renvoie l'erreur `[ERROR] The database schema is not in sync with the current mapping file`, c'est normal à ce stade : cela signifie simplement que la base de données locale n'a pas encore été créée ou mise à jour avec les entités actuelles du projet. Ce projet n'utilise pas de système de migrations, uniquement les commandes `doctrine:schema:*`.

Pour prévisualiser le SQL qui serait exécuté pour synchroniser la base de données, sans rien modifier réellement :

```bash
bin/console doctrine:schema:update --dump-sql
```

Pour appliquer réellement cette synchronisation :

```bash
bin/console doctrine:schema:update --force
```

## Ce qu'il faut retenir avant de continuer

À ce stade, vous disposez d'un projet Symfony fonctionnel, sans workflow CI/CD, mais avec plusieurs outils de qualité déjà installés et configurés : tests (PHPUnit), formatage automatique (PHP CS Fixer), analyse statique (PHPStan), et linters (Twig, YAML, container, entités). Ce sont exactement les briques que nous allons intégrer, une par une, dans un pipeline GitHub Actions au fil des prochains TP.

# 🚀 Guide Pas à Pas - GitHub + Base + Farcaster

## 📋 Table des Matières

1. [GitHub - Hébergement Code](#1-github)
2. [Base - Déploiement Smart Contracts](#2-base)
3. [Farcaster - Intégration Sociale](#3-farcaster)
4. [Troubleshooting](#troubleshooting)

---

# 1. GITHUB - Hébergement Code

## 🎯 Pourquoi GitHub ?
- ✅ Héberger ton code gratuitement
- ✅ Versionning (historique des changements)
- ✅ Collaboration
- ✅ GitHub Pages (hébergement web gratuit)
- ✅ Crédibilité pour investisseurs

---

## ÉTAPE 1A: Créer un Compte GitHub

### 1. Aller sur GitHub
```
🌐 https://github.com
```

### 2. Cliquer "Sign up"
```
Écran de bienvenue:
┌────────────────────────────────┐
│  Welcome to GitHub             │
│                                │
│  Email: [votre@email.com]      │
│                                │
│  [Continue]                    │
└────────────────────────────────┘
```

### 3. Remplir les infos
```bash
Email: votre@email.com
Password: MotDePasseSecure123!
Username: power-wash-pro (ou autre)

# Conseils:
✅ Username court et mémorable
✅ Éviter caractères spéciaux
✅ Minuscules recommandées
```

### 4. Vérifier l'email
```
📧 Ouvrir votre boîte mail
📩 Chercher email de GitHub
🔗 Cliquer sur le lien de vérification
```

### 5. Configuration initiale
```
Répondre aux questions:
- What do you want to do? → Create a project
- How many people will work? → Just me
- Student/Teacher? → Skip ou répondre
```

---

## ÉTAPE 1B: Installer Git sur Ton Ordinateur

### Sur Windows 🪟

```bash
# 1. Télécharger Git
🌐 https://git-scm.com/download/win

# 2. Lancer l'installateur
- Clic droit → "Run as administrator"
- Next, Next, Next (garder les options par défaut)
- Installer

# 3. Vérifier installation
# Ouvrir "Command Prompt" ou "PowerShell"
git --version
# Résultat attendu: git version 2.43.0
```

### Sur Mac 🍎

```bash
# 1. Ouvrir Terminal
# Applications → Utilities → Terminal

# 2. Installer Homebrew (si pas déjà installé)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Installer Git
brew install git

# 4. Vérifier
git --version
```

### Sur Linux 🐧

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# Fedora
sudo dnf install git

# Arch
sudo pacman -S git

# Vérifier
git --version
```

---

## ÉTAPE 1C: Configurer Git

```bash
# Ouvrir terminal/command prompt

# 1. Configuration nom (utilise ton vrai nom)
git config --global user.name "Ton Nom"

# 2. Configuration email (même que GitHub)
git config --global user.email "votre@email.com"

# 3. Vérifier configuration
git config --list

# Résultat attendu:
# user.name=Ton Nom
# user.email=votre@email.com
```

---

## ÉTAPE 1D: Créer le Repository sur GitHub

### 1. Aller sur GitHub.com

```
🔑 Se connecter avec ton compte
```

### 2. Créer un nouveau repository

```
Interface GitHub:
┌──────────────────────────────────────┐
│ [+] New repository                    │
└──────────────────────────────────────┘

Ou cliquer sur ton avatar (coin supérieur droit)
→ Your repositories
→ New (bouton vert)
```

### 3. Remplir les détails

```
Repository name: power-wash-pro-web3
Description: 🎮 Power Wash Pro - Web3 Game on Base Network

☑️ Public (gratuit, tout le monde peut voir)
   ou
☐ Private ($, seulement toi)

☑️ Add a README file
☐ Add .gitignore (on va le faire manuellement)
☐ Choose a license → MIT License

[Create repository] ← Cliquer
```

### 4. Repository créé !

```
Tu verras:
┌────────────────────────────────────────┐
│ power-wash-pro-web3                    │
│ 🎮 Power Wash Pro - Web3 Game...      │
│                                        │
│ Code  Issues  Pull requests           │
│                                        │
│ README.md                              │
│ LICENSE                                │
└────────────────────────────────────────┘
```

---

## ÉTAPE 1E: Cloner le Repository Localement

### 1. Copier l'URL du repository

```
Sur la page du repository:
┌────────────────────────────────────┐
│ [Code ▼] bouton vert               │
│                                    │
│ HTTPS                              │
│ https://github.com/ton-username/   │
│ power-wash-pro-web3.git            │
│ [📋 Copy]                          │
└────────────────────────────────────┘
```

### 2. Ouvrir terminal dans le dossier où tu veux travailler

```bash
# Windows
cd C:\Users\TonNom\Documents
# ou utiliser l'explorateur de fichiers:
# Clic droit dans le dossier → "Open in Terminal"

# Mac/Linux
cd ~/Documents
```

### 3. Cloner le repository

```bash
git clone https://github.com/ton-username/power-wash-pro-web3.git

# Tu verras:
Cloning into 'power-wash-pro-web3'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Receiving objects: 100% (3/3), done.
```

### 4. Entrer dans le dossier

```bash
cd power-wash-pro-web3

# Vérifier qu'on est au bon endroit
ls
# Tu devrais voir: README.md  LICENSE
```

---

## ÉTAPE 1F: Ajouter Tes Fichiers

### 1. Copier tous tes fichiers dans le dossier

```
Structure finale:
power-wash-pro-web3/
├── README.md (déjà là)
├── LICENSE (déjà là)
├── power-wash-pro-web3.html (TON FICHIER)
├── contracts/
│   ├── PowerWashNFT.sol
│   ├── WashToken.sol
│   ├── PowerWashMarketplace.sol
│   └── PowerWashRewards.sol
├── WEB3_COMPLETE_README.md
├── WEB3_MONETIZATION_STRATEGY.md
├── AUDIO_GUIDE.md
├── .gitignore (on va créer)
└── .env.example (on va créer)
```

### 2. Créer .gitignore

```bash
# Dans le dossier power-wash-pro-web3
# Créer le fichier .gitignore

# Windows (Command Prompt)
echo. > .gitignore

# Mac/Linux
touch .gitignore
```

### 3. Éditer .gitignore

```bash
# Ouvrir avec notepad (Windows) ou nano (Mac/Linux)
notepad .gitignore  # Windows
nano .gitignore     # Mac/Linux

# Ajouter ces lignes:
node_modules/
.env
.env.local
.env.*.local
cache/
artifacts/
deployed-addresses.json
coverage/
typechain/
*.log
.DS_Store
.idea/
.vscode/
```

### 4. Créer .env.example

```bash
# Créer le fichier
touch .env.example   # Mac/Linux
echo. > .env.example # Windows

# Éditer
nano .env.example    # Mac/Linux
notepad .env.example # Windows

# Contenu:
# Copy to .env and fill with your values
PRIVATE_KEY=your_private_key_without_0x
BASESCAN_API_KEY=your_basescan_api_key
ALCHEMY_API_KEY=your_alchemy_key_optional
```

---

## ÉTAPE 1G: Pousser (Push) le Code sur GitHub

### 1. Vérifier les fichiers modifiés

```bash
git status

# Tu verras en rouge tous les nouveaux fichiers:
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        power-wash-pro-web3.html
        contracts/
        WEB3_COMPLETE_README.md
        ...
```

### 2. Ajouter tous les fichiers

```bash
git add .

# Le point (.) = tous les fichiers

# Vérifier
git status

# Maintenant tout devrait être en VERT:
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   power-wash-pro-web3.html
        new file:   contracts/PowerWashNFT.sol
        ...
```

### 3. Créer un commit

```bash
git commit -m "🎮 Initial commit - Power Wash Pro Web3 complete integration"

# Message de commit clair et descriptif
# Emoji optionnel mais cool 😎
```

### 4. Pousser vers GitHub

```bash
git push origin main

# Ou si la branche s'appelle "master":
git push origin master

# Tu verras:
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (12/12), done.
Writing objects: 100% (14/14), 50.23 KiB | 5.02 MiB/s, done.
Total 14 (delta 0), reused 0 (delta 0)
To https://github.com/ton-username/power-wash-pro-web3.git
   abc1234..def5678  main -> main
```

### 5. Vérifier sur GitHub

```
🌐 Aller sur https://github.com/ton-username/power-wash-pro-web3

Tu devrais voir tous tes fichiers ! 🎉
```

---

## ÉTAPE 1H: Activer GitHub Pages (Hébergement Gratuit)

### 1. Aller dans Settings

```
Sur ton repository GitHub:
┌──────────────────────────────────┐
│ Code Issues Pull requests        │
│                                  │
│ [Settings] ← Cliquer ici         │
└──────────────────────────────────┘
```

### 2. Aller dans Pages

```
Menu de gauche:
┌────────────────────┐
│ General            │
│ Access             │
│ ...                │
│ Pages  ← Cliquer   │
│ ...                │
└────────────────────┘
```

### 3. Configurer Pages

```
Source: Deploy from a branch
Branch: main (ou master)
Folder: / (root)

[Save]
```

### 4. Attendre 2-3 minutes

```
Actualiser la page

Tu verras:
┌────────────────────────────────────────┐
│ ✅ Your site is live at:              │
│ https://ton-username.github.io/        │
│ power-wash-pro-web3/                   │
└────────────────────────────────────────┘
```

### 5. Renommer ton fichier HTML

```bash
# GitHub Pages cherche "index.html" par défaut
# Renommer ton fichier:

mv power-wash-pro-web3.html index.html

# Puis commit et push
git add .
git commit -m "📝 Rename to index.html for GitHub Pages"
git push origin main
```

### 6. Accéder à ton jeu en ligne !

```
🌐 https://ton-username.github.io/power-wash-pro-web3/

TON JEU EST MAINTENANT EN LIGNE ! 🎮🌐
```

---

## ÉTAPE 1I: Commandes Git Essentielles

```bash
# Vérifier l'état
git status

# Voir l'historique
git log

# Ajouter fichiers
git add nomfichier.js
git add .  # tous les fichiers

# Créer un commit
git commit -m "Description du changement"

# Pousser vers GitHub
git push origin main

# Récupérer les changements
git pull origin main

# Créer une branche
git branch nouvelle-feature
git checkout nouvelle-feature

# Revenir à main
git checkout main

# Fusionner une branche
git merge nouvelle-feature

# Annuler les changements non commités
git checkout -- nomfichier.js

# Voir les différences
git diff
```

---

# 2. BASE - Déploiement Smart Contracts

## 🎯 Pourquoi Base ?
- ✅ L2 Ethereum (gas fees 100x moins chers)
- ✅ Soutenu par Coinbase
- ✅ Compatible EVM
- ✅ Liquide (beaucoup d'utilisateurs)
- ✅ Intégration Farcaster native

---

## ÉTAPE 2A: Obtenir un Wallet

### 1. Installer MetaMask

```
🌐 https://metamask.io/download

Support:
- Chrome/Edge/Brave
- Firefox
- Mobile (iOS/Android)
```

### 2. Créer un nouveau wallet

```
Ouvrir MetaMask
┌──────────────────────────────────┐
│ Welcome to MetaMask              │
│                                  │
│ [Create a new wallet]            │
│ [Import existing wallet]         │
└──────────────────────────────────┘

Cliquer: Create a new wallet
```

### 3. Créer mot de passe

```
┌──────────────────────────────────┐
│ Create password                   │
│                                  │
│ Password: [•••••••••••]          │
│ Confirm:  [•••••••••••]          │
│                                  │
│ ☑️ I agree to Terms of Use       │
│                                  │
│ [Create]                         │
└──────────────────────────────────┘

⚠️ Mot de passe FORT recommandé!
```

### 4. Sauvegarder la Seed Phrase

```
┌──────────────────────────────────┐
│ Secret Recovery Phrase            │
│                                  │
│ [Reveal Secret Words]            │
│                                  │
│ 1. apple    7. ocean             │
│ 2. banana   8. mountain          │
│ 3. cherry   9. river             │
│ 4. dragon  10. sunset            │
│ 5. eagle   11. thunder           │
│ 6. falcon  12. waterfall         │
│                                  │
│ ⚠️ NEVER share these words!      │
│ ⚠️ Write them down on paper!     │
│                                  │
│ [Next]                           │
└──────────────────────────────────┘

🚨 CRITIQUE:
✅ Écrire sur papier
✅ Stocker en lieu sûr
✅ JAMAIS digital
✅ JAMAIS screenshot
✅ JAMAIS partager
```

### 5. Confirmer la Seed Phrase

```
Cliquer sur les mots dans le bon ordre
pour prouver que tu les as sauvegardés

[Confirm]
```

### 6. Wallet créé ! 🎉

```
Tu verras:
┌──────────────────────────────────┐
│ Account 1                        │
│ 0x742d...a8f3                    │
│                                  │
│ Balance: 0 ETH                   │
│                                  │
│ [Send] [Receive] [Buy]           │
└──────────────────────────────────┘
```

---

## ÉTAPE 2B: Ajouter le Réseau Base à MetaMask

### Option 1: Automatique (Recommandé)

```
1. Aller sur: https://chainlist.org
2. Chercher "Base"
3. Cliquer "Add to MetaMask"
4. Approuver dans MetaMask
```

### Option 2: Manuelle

```
Dans MetaMask:
1. Cliquer sur le réseau (en haut)
   [Ethereum Mainnet ▼]

2. [Add network]

3. [Add a network manually]

4. Remplir:

Network Name: Base Mainnet
New RPC URL: https://mainnet.base.org
Chain ID: 8453
Currency Symbol: ETH
Block Explorer: https://basescan.org

[Save]
```

### Pour Base Sepolia (Testnet)

```
Network Name: Base Sepolia
New RPC URL: https://sepolia.base.org
Chain ID: 84532
Currency Symbol: ETH
Block Explorer: https://sepolia.basescan.org

[Save]
```

---

## ÉTAPE 2C: Obtenir des ETH pour Gas

### Sur Base Sepolia (Testnet - GRATUIT)

```
🌐 https://www.coinbase.com/faucets/base-ethereum-goerli-faucet

1. Connecter ton wallet
2. Cliquer "Send me ETH"
3. Attendre 30 secondes - 2 minutes
4. Vérifier balance dans MetaMask

Tu recevras: ~0.05 ETH testnet
```

### Sur Base Mainnet (Production - PAYANT)

#### Méthode 1: Bridge depuis Ethereum L1

```
🌐 https://bridge.base.org

1. Connecter wallet
2. Sélectionner "Ethereum" → "Base"
3. Montant: 0.1 ETH minimum
4. [Bridge]
5. Temps: 1-5 minutes
6. Frais: ~$3-10
```

#### Méthode 2: Acheter sur Coinbase puis retirer

```
1. Créer compte Coinbase
2. Acheter ETH ($50-100)
3. Withdraw:
   - Network: Base
   - Address: Ton adresse MetaMask
4. Temps: 5-10 minutes
5. Frais: Minimaux
```

#### Méthode 3: Utiliser un échange

```
Binance, Kraken, etc:
1. Acheter ETH
2. Retirer vers Base network
3. Copier ton adresse MetaMask
4. Sélectionner "Base" comme network
```

---

## ÉTAPE 2D: Préparer les Fichiers pour Déploiement

### 1. Structure du Projet

```bash
# Dans ton dossier GitHub
cd power-wash-pro-web3

# Vérifier structure
ls

# Tu devrais avoir:
contracts/
  PowerWashNFT.sol
  WashToken.sol
  PowerWashMarketplace.sol
  PowerWashRewards.sol
```

### 2. Initialiser Hardhat

```bash
# Installer Node.js d'abord si pas installé
# https://nodejs.org (version LTS)

# Vérifier installation
node --version  # v18.0.0 ou plus
npm --version   # 9.0.0 ou plus

# Initialiser npm
npm init -y

# Installer Hardhat
npm install --save-dev hardhat

# Initialiser Hardhat
npx hardhat init

# Choisir:
? What do you want to do? › 
  ❯ Create a JavaScript project
    Create a TypeScript project
    Create an empty hardhat.config.js

# Sélectionner: TypeScript project
# Appuyer Enter pour tout accepter
```

### 3. Installer Dépendances

```bash
# OpenZeppelin (pour les contrats)
npm install @openzeppelin/contracts

# Plugins Hardhat
npm install --save-dev @nomicfoundation/hardhat-toolbox
npm install --save-dev @nomicfoundation/hardhat-verify

# Autres
npm install --save-dev dotenv ethers@^5.7.2
```

### 4. Créer fichier .env

```bash
# Créer
touch .env  # Mac/Linux
echo. > .env  # Windows

# Éditer (avec ton éditeur préféré)
nano .env

# Contenu:
PRIVATE_KEY=ta_private_key_ici
BASESCAN_API_KEY=ta_basescan_api_key_ici
```

### 5. Obtenir ta Private Key

```
⚠️ ATTENTION: NE JAMAIS PARTAGER!

Dans MetaMask:
1. Cliquer sur les 3 points (...)
2. Account details
3. Export private key
4. Entrer mot de passe MetaMask
5. COPIER la clé (sans le 0x)
6. COLLER dans .env

Exemple:
PRIVATE_KEY=abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890
```

### 6. Obtenir Basescan API Key

```
1. Aller sur: https://basescan.org

2. Créer un compte:
   - [Sign In]
   - [Click to sign up]
   - Email + Password
   - Vérifier email

3. Obtenir API Key:
   - [My Profile] (coin supérieur droit)
   - [API Keys] (menu gauche)
   - [+ Add] (bouton)
   - App Name: "Power Wash Pro"
   - [Create New API Key]
   - COPIER la clé
   - COLLER dans .env

Exemple:
BASESCAN_API_KEY=ABC123DEF456GHI789JKL012MNO345
```

---

## ÉTAPE 2E: Configurer Hardhat

### 1. Créer hardhat.config.ts

```typescript
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  
  networks: {
    hardhat: {
      chainId: 31337,
    },
    
    baseSepolia: {
      url: "https://sepolia.base.org",
      chainId: 84532,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
    
    base: {
      url: "https://mainnet.base.org",
      chainId: 8453,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
  },
  
  etherscan: {
    apiKey: {
      baseSepolia: process.env.BASESCAN_API_KEY || "",
      base: process.env.BASESCAN_API_KEY || "",
    },
    customChains: [
      {
        network: "baseSepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org",
        },
      },
    ],
  },
};

export default config;
```

### 2. Créer scripts/deploy.ts

```typescript
import { ethers } from "hardhat";

async function main() {
  console.log("🚀 Starting deployment...\n");

  const [deployer] = await ethers.getSigners();
  console.log("📝 Deploying with account:", deployer.address);
  
  const balance = await deployer.getBalance();
  console.log("💰 Account balance:", ethers.utils.formatEther(balance), "ETH\n");

  // Deploy WashToken
  console.log("1️⃣  Deploying WashToken...");
  const WashToken = await ethers.getContractFactory("WashToken");
  const token = await WashToken.deploy();
  await token.deployed();
  console.log("✅ WashToken:", token.address);

  // Deploy PowerWashNFT
  console.log("\n2️⃣  Deploying PowerWashNFT...");
  const NFT = await ethers.getContractFactory("PowerWashNFT");
  const nft = await NFT.deploy(
    "Power Wash Pro NFT",
    "PWPNFT",
    "https://api.powerwashpro.com/metadata/"
  );
  await nft.deployed();
  console.log("✅ PowerWashNFT:", nft.address);

  // Deploy Marketplace
  console.log("\n3️⃣  Deploying Marketplace...");
  const Marketplace = await ethers.getContractFactory("PowerWashMarketplace");
  const marketplace = await Marketplace.deploy(nft.address);
  await marketplace.deployed();
  console.log("✅ Marketplace:", marketplace.address);

  // Deploy Rewards
  console.log("\n4️⃣  Deploying Rewards...");
  const Rewards = await ethers.getContractFactory("PowerWashRewards");
  const rewards = await Rewards.deploy(token.address);
  await rewards.deployed();
  console.log("✅ Rewards:", rewards.address);

  // Configure
  console.log("\n🔧 Configuring...");
  await token.addMinter(rewards.address);
  console.log("✅ Rewards added as minter");

  // Summary
  console.log("\n" + "=".repeat(50));
  console.log("📋 DEPLOYMENT COMPLETE");
  console.log("=".repeat(50));
  console.log("WashToken:    ", token.address);
  console.log("PowerWashNFT: ", nft.address);
  console.log("Marketplace:  ", marketplace.address);
  console.log("Rewards:      ", rewards.address);
  console.log("=".repeat(50));
  
  console.log("\n🎉 Success! Update your frontend with these addresses.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

---

## ÉTAPE 2F: Compiler les Contrats

```bash
# Compiler
npx hardhat compile

# Tu verras:
Compiling 4 files with 0.8.20
Compilation finished successfully

# Si erreur:
- Vérifier imports OpenZeppelin
- Vérifier version Solidity
- Vérifier syntaxe
```

---

## ÉTAPE 2G: Déployer sur Base Sepolia (Testnet)

```bash
# Vérifier balance
npx hardhat run scripts/checkBalance.ts --network baseSepolia

# Si balance > 0, déployer:
npx hardhat run scripts/deploy.ts --network baseSepolia

# ATTENDRE (2-5 minutes)

# Tu verras:
🚀 Starting deployment...

📝 Deploying with account: 0x742d...a8f3
💰 Account balance: 0.05 ETH

1️⃣  Deploying WashToken...
✅ WashToken: 0x1234...5678

2️⃣  Deploying PowerWashNFT...
✅ PowerWashNFT: 0x9abc...def0

3️⃣  Deploying Marketplace...
✅ Marketplace: 0x1111...2222

4️⃣  Deploying Rewards...
✅ Rewards: 0x3333...4444

==================================================
📋 DEPLOYMENT COMPLETE
==================================================
WashToken:     0x1234...5678
PowerWashNFT:  0x9abc...def0
Marketplace:   0x1111...2222
Rewards:       0x3333...4444
==================================================

🎉 Success!
```

### Vérifier sur Basescan

```
🌐 https://sepolia.basescan.org

1. Copier une address (ex: 0x1234...5678)
2. Chercher dans la barre de recherche
3. Tu devrais voir ton contrat !

Transaction status: Success ✅
```

---

## ÉTAPE 2H: Vérifier les Contrats

```bash
# Vérifier WashToken
npx hardhat verify --network baseSepolia 0x1234...5678

# Vérifier NFT (avec paramètres du constructeur)
npx hardhat verify --network baseSepolia 0x9abc...def0 "Power Wash Pro NFT" "PWPNFT" "https://api.powerwashpro.com/metadata/"

# Vérifier Marketplace
npx hardhat verify --network baseSepolia 0x1111...2222 0x9abc...def0

# Vérifier Rewards
npx hardhat verify --network baseSepolia 0x3333...4444 0x1234...5678

# Chaque commande prend ~30 secondes

# Succès:
Successfully verified contract PowerWashNFT on Etherscan.
https://sepolia.basescan.org/address/0x9abc...def0#code
```

---

## ÉTAPE 2I: Mettre à Jour le Frontend

```javascript
// Dans index.html (ou power-wash-pro-web3.html)

const CONFIG = {
  CHAIN_ID: 84532, // Base Sepolia (testnet)
  // CHAIN_ID: 8453, // Base Mainnet (production)
  
  CONTRACTS: {
    NFT: '0x9abc...def0',      // TON ADRESSE
    TOKEN: '0x1234...5678',    // TON ADRESSE
    MARKETPLACE: '0x1111...2222', // TON ADRESSE
    REWARDS: '0x3333...4444',  // TON ADRESSE
  },
};
```

### Tester

```
1. Ouvrir index.html dans navigateur
2. Cliquer "Connect Wallet"
3. Changer réseau vers "Base Sepolia"
4. Tester mint NFT
5. Vérifier transaction sur Basescan
```

---

## ÉTAPE 2J: Déployer sur Base Mainnet (Production)

⚠️ **CHECKLIST AVANT MAINNET:**

```
✅ Contrats testés pendant 1+ semaine sur testnet
✅ Audit sécurité complété
✅ Tous les bugs corrigés
✅ Frontend testé à 100%
✅ 0.05-0.1 ETH sur Base Mainnet pour gas
✅ Backup de private key
✅ Plan d'urgence en cas de problème
```

### Déploiement

```bash
# 1. Changer réseau dans MetaMask vers "Base Mainnet"

# 2. Vérifier balance
# Tu devrais avoir 0.05-0.1 ETH

# 3. DÉPLOYER (point of no return!)
npx hardhat run scripts/deploy.ts --network base

# ATTENDRE 2-5 minutes
# COÛT: ~0.02-0.05 ETH (~$60-150)

# 4. NOTER LES ADDRESSES IMMÉDIATEMENT
WashToken:     0x...
PowerWashNFT:  0x...
Marketplace:   0x...
Rewards:       0x...

# 5. Vérifier sur Basescan
npx hardhat verify --network base 0x... [args]

# 6. Mettre à jour frontend avec addresses mainnet

# 7. Commit et push sur GitHub
git add .
git commit -m "🚀 Mainnet deployment"
git push origin main
```

---

# 3. FARCASTER - Intégration Sociale

## 🎯 Pourquoi Farcaster ?
- ✅ Réseau social décentralisé
- ✅ Intégration Base native
- ✅ Frames (mini-apps dans les posts)
- ✅ Crypto-native audience
- ✅ Viral potential

---

## ÉTAPE 3A: Créer un Compte Farcaster

### 1. Télécharger Warpcast

```
📱 iOS: App Store → Chercher "Warpcast"
🤖 Android: Play Store → Chercher "Warpcast"
💻 Web: https://warpcast.com
```

### 2. S'inscrire

```
Ouvrir Warpcast
┌────────────────────────────────┐
│ Welcome to Farcaster           │
│                                │
│ [Sign up]                      │
│ [Sign in]                      │
└────────────────────────────────┘

Cliquer: Sign up
```

### 3. Choisir Username

```
┌────────────────────────────────┐
│ Choose your username           │
│                                │
│ @[powerwashpro]                │
│   ✅ Available                 │
│                                │
│ [Continue]                     │
└────────────────────────────────┘

Conseils:
✅ Court et mémorable
✅ Lié au jeu
✅ Facile à taper
```

### 4. Configuration Profile

```
┌────────────────────────────────┐
│ Set up your profile            │
│                                │
│ Display name: Power Wash Pro   │
│ Bio: 🎮 Web3 cleaning game     │
│      on Base. Play to Earn!    │
│                                │
│ [Add photo] (logo du jeu)      │
│                                │
│ [Continue]                     │
└────────────────────────────────┘
```

### 5. Payer les Frais (One-time)

```
┌────────────────────────────────┐
│ Registration Fee               │
│                                │
│ Pay once: $5                   │
│ (prevents spam)                │
│                                │
│ Payment options:               │
│ • Credit Card                  │
│ • Crypto                       │
│                                │
│ [Pay with Card]                │
└────────────────────────────────┘

Payer avec carte de crédit
C'est un paiement unique à vie
```

### 6. Connecter Wallet (Optionnel mais recommandé)

```
Settings → Connected Wallets → Add Wallet
Connecter ton MetaMask avec Base
```

---

## ÉTAPE 3B: Créer un Frame pour le Jeu

### Qu'est-ce qu'un Frame ?

```
Un Frame = Mini-app interactive dans un post Farcaster
Exemples:
- Jouer à un jeu
- Mint un NFT
- Voir des stats
- Voter dans un poll
```

### 1. Structure d'un Frame Simple

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head>
  <!-- Meta tags pour Frame -->
  <meta property="fc:frame" content="vNext" />
  <meta property="fc:frame:image" content="https://ton-site.com/game-preview.png" />
  <meta property="fc:frame:button:1" content="🎮 Play Now" />
  <meta property="fc:frame:button:1:action" content="link" />
  <meta property="fc:frame:button:1:target" content="https://ton-site.com/game" />
  
  <title>Power Wash Pro</title>
</head>
<body>
  <!-- Ton jeu ici -->
</body>
</html>
```

### 2. Créer Image de Preview

```
Dimensions: 1200x630px (ratio 1.91:1)

Contenu suggéré:
┌─────────────────────────────────────────┐
│                                         │
│     🎮 POWER WASH PRO                   │
│                                         │
│     Play to Earn on Base                │
│     💎 Mint NFTs • 🪙 Earn $WASH       │
│                                         │
│     [Gameplay Screenshot]               │
│                                         │
└─────────────────────────────────────────┘

Outils:
- Canva.com (gratuit, templates)
- Figma (plus avancé)
- Photoshop
```

### 3. Héberger l'Image

```
Options:
1. GitHub Pages (déjà fait!)
   https://ton-username.github.io/power-wash-pro-web3/preview.png

2. Imgur
   - Upload image
   - Copier direct link
   
3. IPFS (décentralisé)
   - https://nft.storage (gratuit)
   - Upload image
   - Obtenir ipfs:// URL
```

### 4. Mettre à Jour index.html

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Farcaster Frame Meta Tags -->
  <meta property="fc:frame" content="vNext" />
  <meta property="fc:frame:image" content="https://ton-username.github.io/power-wash-pro-web3/preview.png" />
  <meta property="fc:frame:image:aspect_ratio" content="1.91:1" />
  
  <!-- Button 1: Play Game -->
  <meta property="fc:frame:button:1" content="🎮 Play Game" />
  <meta property="fc:frame:button:1:action" content="link" />
  <meta property="fc:frame:button:1:target" content="https://ton-username.github.io/power-wash-pro-web3/" />
  
  <!-- Button 2: View NFTs -->
  <meta property="fc:frame:button:2" content="🎨 View NFTs" />
  <meta property="fc:frame:button:2:action" content="link" />
  <meta property="fc:frame:button:2:target" content="https://basescan.org/address/0xTON_NFT_ADDRESS" />
  
  <!-- Button 3: Learn More -->
  <meta property="fc:frame:button:3" content="ℹ️ Learn More" />
  <meta property="fc:frame:button:3:action" content="link" />
  <meta property="fc:frame:button:3:target" content="https://github.com/ton-username/power-wash-pro-web3" />
  
  <!-- OpenGraph (pour autres réseaux sociaux) -->
  <meta property="og:title" content="Power Wash Pro - Web3 Game" />
  <meta property="og:description" content="🎮 Play to Earn cleaning game on Base. Mint NFTs, earn $WASH tokens!" />
  <meta property="og:image" content="https://ton-username.github.io/power-wash-pro-web3/preview.png" />
  
  <title>Power Wash Pro - Web3 Game on Base</title>
  
  <!-- Ton CSS et JS ici -->
</head>
<body>
  <!-- Ton jeu ici -->
</body>
</html>
```

### 5. Tester le Frame

```
1. Aller sur: https://warpcast.com/~/developers/frames

2. Entrer ton URL:
   https://ton-username.github.io/power-wash-pro-web3/

3. Cliquer [Validate Frame]

4. Tu verras un aperçu:
┌─────────────────────────────────┐
│ [Image Preview]                 │
│                                 │
│ [🎮 Play Game]                  │
│ [🎨 View NFTs]                  │
│ [ℹ️ Learn More]                 │
└─────────────────────────────────┘

5. Si ça marche → ✅ Frame valide!
   Si erreur → Corriger les meta tags
```

---

## ÉTAPE 3C: Poster sur Farcaster

### 1. Créer un Post de Lancement

```
Ouvrir Warpcast
┌──────────────────────────────────────┐
│ What's happening?                    │
│                                      │
│ 🎮 POWER WASH PRO IS LIVE!          │
│                                      │
│ Play to Earn cleaning game on Base  │
│ 💎 Mint NFTs with boosts            │
│ 🪙 Earn $WASH tokens                │
│ 🏪 Trade on marketplace             │
│                                      │
│ Try it now! 👇                       │
│ https://ton-username.github.io/...  │
│                                      │
│ #Base #Web3Gaming #PlayToEarn       │
└──────────────────────────────────────┘

[Post]
```

### 2. Ton URL se Transforme en Frame !

```
Après avoir posté, tu verras:
┌─────────────────────────────────┐
│ @powerwashpro                   │
│ 🎮 POWER WASH PRO IS LIVE!      │
│ Play to Earn cleaning game...   │
│                                 │
│ ┌───────────────────────────┐   │
│ │ [Image de ton jeu]        │   │
│ │                           │   │
│ │ [🎮 Play Game]            │   │
│ │ [🎨 View NFTs]            │   │
│ │ [ℹ️ Learn More]           │   │
│ └───────────────────────────┘   │
│                                 │
│ 💬 12  🔄 34  ❤️ 56             │
└─────────────────────────────────┘

Les utilisateurs peuvent cliquer directement!
```

---

## ÉTAPE 3D: Marketing sur Farcaster

### Stratégie de Contenu

#### Post 1: Annonce (Jour 1)
```
🚨 BIG ANNOUNCEMENT 🚨

Power Wash Pro is LIVE on Base! 🎮

The first play-to-earn cleaning game where you:
✅ Clean virtual spaces
✅ Earn $WASH tokens
✅ Collect rare NFT skins
✅ Trade on marketplace

Built on @base 💙

Play now 👇
[ton-url]

#BaseGaming #PlayToEarn
```

#### Post 2: Tutorial (Jour 3)
```
🎓 HOW TO PLAY Power Wash Pro

1. Connect your wallet
2. Start cleaning (use mouse/touch)
3. Complete levels to earn $WASH
4. Mint NFT skins for gameplay boosts
5. Stake tokens for passive income

Tutorial video 👇
[lien vidéo ou gif]

Questions? Drop them below! 💬
```

#### Post 3: Stats (Jour 7)
```
📊 WEEK 1 STATS

Players: 1,234 🎮
NFTs Minted: 567 💎
$WASH Earned: 89,500 🪙
Volume: 12 ETH 💰

Thank you fam! This is just the beginning 🚀

New feature coming next week... 👀

[capture d'écran du jeu]
```

#### Post 4: Giveaway (Jour 14)
```
🎁 MEGA GIVEAWAY 🎁

We're giving away:
🥇 1x Legendary NFT (worth 0.5 ETH)
🥈 3x Epic NFTs
🥉 10x Rare NFTs

To enter:
1. ❤️ Like this cast
2. 🔄 Recast
3. 💬 Tag 2 friends
4. 🎮 Play the game (screenshot your score)

Winner announced in 48h! GL! 🍀
```

### Engagement Best Practices

```
✅ Poster 1-2x par jour
✅ Répondre aux comments rapidement
✅ Partager des memes du jeu
✅ Montrer les high scores
✅ Spotlight sur les top players
✅ Behind-the-scenes dev updates
✅ Polls pour nouvelles features
✅ Weekly tournaments avec prizes

❌ Éviter:
- Spam
- Trop de marketing
- Ignorer les questions
- Promesses impossibles
```

---

## ÉTAPE 3E: Créer une Frame Interactive Avancée

### Option 1: Frame Simple (déjà fait)

```html
<!-- Juste des boutons qui lient vers ton site -->
<meta property="fc:frame:button:1" content="Play" />
<meta property="fc:frame:button:1:action" content="link" />
```

### Option 2: Frame avec Actions

```html
<!-- Mini-jeu DANS le Frame -->
<meta property="fc:frame" content="vNext" />
<meta property="fc:frame:image" content="https://ton-site.com/frame-1.png" />
<meta property="fc:frame:post_url" content="https://ton-site.com/api/frame" />

<!-- Actions -->
<meta property="fc:frame:button:1" content="Clean!" />
<meta property="fc:frame:button:1:action" content="post" />

<meta property="fc:frame:button:2" content="Next Level" />
<meta property="fc:frame:button:2:action" content="post" />
```

### Backend pour Frame Interactif

```javascript
// api/frame.js (si tu utilises Vercel/Netlify)
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  
  const { buttonIndex, fid } = req.body; // fid = Farcaster ID
  
  // Logique du jeu
  let imageUrl = '';
  let score = 0;
  
  if (buttonIndex === 1) {
    // User clicked "Clean!"
    score += 10;
    imageUrl = `https://ton-site.com/frames/score-${score}.png`;
  }
  
  // Retourner nouvelle Frame
  res.status(200).send(`
    <!DOCTYPE html>
    <html>
      <head>
        <meta property="fc:frame" content="vNext" />
        <meta property="fc:frame:image" content="${imageUrl}" />
        <meta property="fc:frame:button:1" content="Clean Again!" />
        <meta property="fc:frame:button:1:action" content="post" />
        <meta property="fc:frame:button:2" content="Claim Reward" />
        <meta property="fc:frame:button:2:action" content="tx" />
        <meta property="fc:frame:button:2:target" content="https://ton-site.com/api/claim" />
      </head>
    </html>
  `);
}
```

---

## ÉTAPE 3F: Lier Farcaster au Jeu

### 1. Ajouter Sign In with Farcaster

```html
<!-- Dans ton jeu -->
<button id="farcasterSignIn">
  Sign in with Farcaster
</button>

<script>
  document.getElementById('farcasterSignIn').addEventListener('click', async () => {
    // Utiliser AuthKit de Farcaster
    // https://docs.farcaster.xyz/auth-kit/introduction
    
    const { data } = await signIn();
    
    if (data) {
      console.log('Farcaster user:', data.username);
      // Associer avec wallet
      // Donner bonus pour sign-in
    }
  });
</script>
```

### 2. Partage de Score Automatique

```javascript
// Après compléter un niveau
async function shareScore(score, level) {
  const text = `🎮 Just scored ${score} on level ${level} in Power Wash Pro!
  
Can you beat me? 👇
https://ton-site.com`;
  
  // Ouvrir Warpcast avec pre-filled text
  window.open(
    `https://warpcast.com/~/compose?text=${encodeURIComponent(text)}`,
    '_blank'
  );
}
```

### 3. Leaderboard Farcaster

```javascript
// Afficher top players avec usernames Farcaster
async function getLeaderboard() {
  const response = await fetch('https://ton-api.com/leaderboard');
  const players = await response.json();
  
  // players = [
  //   { fid: 1234, username: "alice", score: 50000 },
  //   { fid: 5678, username: "bob", score: 45000 },
  // ]
  
  displayLeaderboard(players);
}
```

---

## ÉTAPE 3G: Créer des Channels

### 1. Qu'est-ce qu'un Channel ?

```
Un Channel = Subreddit/Discord channel sur Farcaster
Exemples:
- /base (pour tout Base)
- /gaming (pour jeux)
- /nfts (pour NFTs)
```

### 2. Créer Ton Channel

```
Sur Warpcast:
1. Aller dans Settings
2. Channels → Create Channel
3. Remplir:

Name: Power Wash Pro
Handle: /powerwashpro
Description: 🎮 Official channel for Power Wash Pro
             Web3 cleaning game on Base
             
[Create]
```

### 3. Promouvoir Ton Channel

```
Poster dans d'autres channels:
┌────────────────────────────────────┐
│ Hey /base fam! 👋                  │
│                                    │
│ We just launched Power Wash Pro,  │
│ a play-to-earn game on Base!      │
│                                    │
│ Join our channel /powerwashpro    │
│ for updates, tournaments, and     │
│ exclusive drops!                   │
│                                    │
│ [frame avec jeu]                   │
└────────────────────────────────────┘
```

### 4. Animer le Channel

```
Posts réguliers:
- Daily challenges
- Weekly tournaments
- Developer updates
- Community highlights
- Bug reports & fixes
- Feature requests
- Memes & fan art
```

---

# TROUBLESHOOTING

## Problèmes GitHub

### "Permission denied (publickey)"

```bash
# Générer SSH key
ssh-keygen -t ed25519 -C "votre@email.com"

# Copier la clé
cat ~/.ssh/id_ed25519.pub

# Ajouter sur GitHub:
Settings → SSH and GPG keys → New SSH key → Paste
```

### "Fatal: not a git repository"

```bash
# Tu n'es pas dans le bon dossier
cd chemin/vers/ton/projet

# Vérifier
git status
```

### "Refusing to merge unrelated histories"

```bash
git pull origin main --allow-unrelated-histories
```

---

## Problèmes Base/Hardhat

### "Insufficient funds"

```bash
# Vérifier balance
npx hardhat console --network baseSepolia
> const [owner] = await ethers.getSigners()
> await owner.getBalance()

# Solution: Ajouter plus d'ETH au wallet
```

### "Contract deployment failed"

```bash
# Augmenter gas limit dans hardhat.config.ts
gas: 5000000,
gasPrice: ethers.utils.parseUnits('10', 'gwei')
```

### "Module not found"

```bash
# Réinstaller dépendances
rm -rf node_modules
npm install
```

---

## Problèmes Farcaster

### "Frame not showing"

```bash
# Vérifier meta tags
# Valider sur: https://warpcast.com/~/developers/frames

# Image doit être:
- Format: PNG ou JPG
- Taille: < 10MB
- Dimensions: 1200x630px recommandé
- HTTPS (pas HTTP)
```

### "Buttons not working"

```html
<!-- Vérifier action type -->
<meta property="fc:frame:button:1:action" content="link" />
<!-- Options: link, post, mint, tx -->

<!-- Vérifier target -->
<meta property="fc:frame:button:1:target" content="https://..." />
<!-- Doit être URL complète avec https:// -->
```

---

# RÉSUMÉ RAPIDE

## Commandes Essentielles

### GitHub
```bash
git add .
git commit -m "message"
git push origin main
```

### Base Déploiement
```bash
npm install
npx hardhat compile
npx hardhat run scripts/deploy.ts --network baseSepolia
npx hardhat verify --network baseSepolia <ADDRESS>
```

### Maintenance
```bash
# Mettre à jour code
git pull origin main
npm install
npx hardhat compile

# Redéployer si nécessaire
npx hardhat run scripts/deploy.ts --network baseSepolia
```

---

# 🎉 FÉLICITATIONS !

Tu sais maintenant:
✅ Mettre du code sur GitHub
✅ Déployer smart contracts sur Base
✅ Créer des Frames Farcaster
✅ Marketing Web3

**TON JEU EST PRÊT À GÉNÉRER DES REVENUS ! 🚀💰**

---

# CHECKLIST FINALE

## GitHub ✅
- [ ] Repository créé
- [ ] Code pushé
- [ ] GitHub Pages activé
- [ ] Jeu accessible en ligne

## Base ✅
- [ ] Wallet créé (MetaMask)
- [ ] ETH pour gas obtenu
- [ ] Contrats déployés sur testnet
- [ ] Contrats vérifiés sur Basescan
- [ ] Frontend mis à jour avec addresses
- [ ] Tout testé sur testnet
- [ ] (Optionnel) Déployé sur mainnet

## Farcaster ✅
- [ ] Compte Warpcast créé
- [ ] Profile configuré
- [ ] Frame meta tags ajoutés
- [ ] Frame testé et validé
- [ ] Post de lancement publié
- [ ] Channel créé
- [ ] Engagement daily

---

**Prêt à dominer le Web3 gaming ! 🎮🚀💎**

Questions ? Relis les sections pertinentes !

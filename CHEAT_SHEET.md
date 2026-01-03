# 🚀 CHEAT SHEET - Déploiement Express

## 📋 Vue d'Ensemble

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   GITHUB    │────>│    BASE     │────>│  FARCASTER  │
│  (Code)     │     │ (Blockchain)│     │  (Social)   │
└─────────────┘     └─────────────┘     └─────────────┘
    1-2h               2-3h               30 min
```

---

# 1️⃣ GITHUB (Hébergement Code)

## Quick Start (15 min)

```bash
# 1. Créer compte sur github.com
# 2. Créer repository "power-wash-pro-web3"
# 3. Dans terminal:

git config --global user.name "Ton Nom"
git config --global user.email "ton@email.com"
git clone https://github.com/TON-USERNAME/power-wash-pro-web3.git
cd power-wash-pro-web3

# 4. Copier tes fichiers dans ce dossier
# 5. Push:

git add .
git commit -m "🎮 Initial commit"
git push origin main
```

## GitHub Pages (5 min)

```
1. Settings → Pages
2. Source: main branch
3. Renommer fichier → index.html
4. Attendre 2 min
5. Accéder: https://TON-USERNAME.github.io/power-wash-pro-web3/
```

✅ **RÉSULTAT:** Ton jeu est en ligne gratuitement !

---

# 2️⃣ BASE (Smart Contracts)

## Setup (30 min)

```bash
# 1. Installer MetaMask (chrome extension)
# 2. Créer wallet + sauvegarder seed phrase
# 3. Ajouter Base Sepolia network:
#    - Chain ID: 84532
#    - RPC: https://sepolia.base.org

# 4. Obtenir ETH testnet (gratuit):
#    https://www.coinbase.com/faucets/base-ethereum-goerli-faucet

# 5. Setup projet:
npm init -y
npm install hardhat @openzeppelin/contracts ethers dotenv
npx hardhat init
```

## Configuration (10 min)

```bash
# Créer .env
PRIVATE_KEY=ta_private_key_sans_0x
BASESCAN_API_KEY=ta_basescan_key

# Obtenir private key:
# MetaMask → ... → Account details → Export private key

# Obtenir Basescan key:
# https://basescan.org → Register → API Keys
```

## Déploiement (5 min)

```bash
# Compiler
npx hardhat compile

# Déployer sur testnet
npx hardhat run scripts/deploy.ts --network baseSepolia

# Noter les addresses:
# WashToken: 0x1234...
# PowerWashNFT: 0x5678...
# Marketplace: 0x9abc...
# Rewards: 0xdef0...

# Vérifier
npx hardhat verify --network baseSepolia 0x1234...
```

## Update Frontend (2 min)

```javascript
// Dans index.html
const CONFIG = {
  CHAIN_ID: 84532,
  CONTRACTS: {
    NFT: '0x5678...',      // TON ADRESSE
    TOKEN: '0x1234...',    // TON ADRESSE
    MARKETPLACE: '0x9abc...',
    REWARDS: '0xdef0...',
  },
};
```

✅ **RÉSULTAT:** Smart contracts déployés et vérifiés !

---

# 3️⃣ FARCASTER (Marketing)

## Setup Compte (10 min)

```
1. Télécharger Warpcast (App Store / Play Store)
2. Sign up → choisir @powerwashpro
3. Payer $5 (one-time registration)
4. Setup profile:
   - Display name: Power Wash Pro
   - Bio: 🎮 Web3 cleaning game on Base
   - Photo: Logo du jeu
```

## Créer Frame (10 min)

```html
<!-- Ajouter dans <head> de index.html -->

<!-- Farcaster Frame -->
<meta property="fc:frame" content="vNext" />
<meta property="fc:frame:image" content="https://TON-SITE/preview.png" />
<meta property="fc:frame:button:1" content="🎮 Play Now" />
<meta property="fc:frame:button:1:action" content="link" />
<meta property="fc:frame:button:1:target" content="https://TON-SITE/" />
```

## Créer Preview Image (15 min)

```
1. Aller sur canva.com
2. Créer design 1200x630px
3. Ajouter:
   - Logo du jeu
   - Titre: POWER WASH PRO
   - Texte: Play to Earn on Base
   - Screenshot du jeu
4. Download PNG
5. Upload sur GitHub (dans ton repo)
6. URL: https://TON-USERNAME.github.io/power-wash-pro-web3/preview.png
```

## Premier Post (5 min)

```
Sur Warpcast:

🚨 LAUNCHING NOW 🚨

Power Wash Pro is LIVE on Base! 🎮

✅ Play to Earn
✅ Mint NFTs
✅ Trade on marketplace
✅ Stake for rewards

Built on @base 💙

Try it now 👇
[ton URL github.io]

#BaseGaming #PlayToEarn
```

✅ **RÉSULTAT:** Jeu partagé avec Frame interactif !

---

# ⚡ WORKFLOW COMPLET

## Jour 1 - GitHub
```bash
[Matin]
☐ Créer compte GitHub
☐ Créer repository
☐ Push code
☐ Activer GitHub Pages
☐ Tester en ligne
```

## Jour 2 - Base Testnet
```bash
[Matin]
☐ Créer MetaMask
☐ Setup Hardhat
☐ Obtenir ETH testnet

[Après-midi]
☐ Déployer contracts
☐ Vérifier sur Basescan
☐ Update frontend
☐ Tester mint NFT
```

## Jour 3 - Farcaster
```bash
[Matin]
☐ Créer compte Warpcast
☐ Setup profile
☐ Créer preview image
☐ Ajouter Frame meta tags

[Après-midi]
☐ Post de lancement
☐ Créer channel
☐ Engager avec community
```

## Jour 4-7 - Tests & Marketing
```bash
☐ Tester toutes features
☐ Corriger bugs
☐ Posts daily sur Farcaster
☐ Répondre aux comments
☐ Préparer giveaway
```

## Semaine 2 - Mainnet (Optionnel)
```bash
☐ Audit sécurité
☐ Acheter 0.1 ETH
☐ Bridge vers Base
☐ Deploy mainnet
☐ Annoncer sur Farcaster
```

---

# 🔥 COMMANDES QUOTIDIENNES

## GitHub
```bash
# Faire changements au code
git add .
git commit -m "Fix bug X"
git push origin main

# Attendre 1-2 min → Changements live!
```

## Vérifier Contracts
```bash
# Voir transactions
https://sepolia.basescan.org/address/TON_ADDRESS

# Vérifier balance
npx hardhat console --network baseSepolia
> const [owner] = await ethers.getSigners()
> await owner.getBalance()
```

## Marketing Farcaster
```bash
Routine:
☐ 1 post principal (matin)
☐ Répondre à tous les comments
☐ 1 recast de fan content
☐ 1 post stats/update (soir)
```

---

# 🆘 ERREURS COMMUNES

## Git: "Permission denied"
```bash
# Solution: HTTPS au lieu de SSH
git remote set-url origin https://github.com/TON-USERNAME/power-wash-pro-web3.git
```

## Hardhat: "Network not found"
```bash
# Solution: Vérifier .env
cat .env
# PRIVATE_KEY doit être là (sans 0x)
```

## MetaMask: "Insufficient funds"
```bash
# Solution: Vérifier network
# Tu dois être sur "Base Sepolia" (testnet)
# Demander plus d'ETH sur faucet
```

## Frame: "Not showing"
```bash
# Solution: Vérifier meta tags
# Image URL doit être HTTPS
# Tester sur: https://warpcast.com/~/developers/frames
```

---

# 📊 METRIQUES À TRACKER

## Semaine 1
```
GitHub:
☐ Stars: __
☐ Forks: __
☐ Visitors: __

Base:
☐ Transactions: __
☐ NFTs minted: __
☐ $WASH earned: __
☐ Unique wallets: __

Farcaster:
☐ Followers: __
☐ Channel members: __
☐ Casts: __
☐ Engagement rate: __%
```

## Objectifs Mois 1
```
✅ 100+ joueurs
✅ 50+ NFTs mintés
✅ 10 ETH volume
✅ 500+ Farcaster followers
✅ Featured in /base channel
```

---

# 🎯 CHECKLIST FINALE

## AVANT MAINNET
```
☐ Testé sur testnet 1+ semaine
☐ Aucun bug critique
☐ Audit sécurité fait
☐ Frontend 100% fonctionnel
☐ 0.1 ETH sur Base mainnet
☐ Plan marketing prêt
☐ Community > 100 personnes
☐ Backup de TOUT
```

## LANCEMENT MAINNET
```
☐ Deploy contracts
☐ Verify sur Basescan
☐ Update frontend
☐ Post announcement
☐ Create liquidity pool
☐ List on OpenSea
☐ Submit to CoinGecko
☐ Tweet lancement
```

## POST-LANCEMENT
```
☐ Monitor errors
☐ Customer support
☐ Daily posts
☐ Weekly tournaments
☐ Monthly updates
☐ Track metrics
☐ Iterate features
```

---

# 💡 TIPS FINAUX

## GitHub
```
✅ Commit souvent (plusieurs fois par jour)
✅ Messages clairs ("Fix login bug" pas "update")
✅ Créer branches pour features
✅ README attractif avec screenshots
✅ License MIT pour open source
```

## Base
```
✅ Toujours tester sur testnet d'abord
✅ Vérifier contracts sur Basescan
✅ Gas limit généreux (éviter échecs)
✅ Commenter ton code Solidity
✅ Suivre patterns OpenZeppelin
```

## Farcaster
```
✅ Authentique > Marketing
✅ Répondre rapidement
✅ Partager behind-the-scenes
✅ Collaborer avec autres builders
✅ Hosts giveaways réguliers
✅ Cross-post sur Twitter/X
```

---

# 🚀 READY TO LAUNCH!

```
┌────────────────────────────────────┐
│                                    │
│   Tu as maintenant TOUT            │
│   ce qu'il faut pour:              │
│                                    │
│   ✅ Héberger ton code             │
│   ✅ Déployer sur blockchain       │
│   ✅ Marketer le jeu               │
│   ✅ Générer des revenus           │
│                                    │
│   LET'S FUCKING GOOOO! 🚀🔥        │
│                                    │
└────────────────────────────────────┘
```

**Questions ?** Relis les sections du guide complet !

**Problèmes ?** Check la section Troubleshooting !

**Succès ?** Tag @powerwashpro sur Farcaster ! 🎮💎

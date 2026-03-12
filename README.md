# 🛡️ CLAW NFA PROTECTOR

> **The first OpenClaw skill that deploys a real AI agent on BNB Chain to protect Binance users 24/7.**

---

## The Problem

Binance users lose **billions every year** to:
- Rug pull tokens bought without auditing the contract
- P2P scammers who disappear after payment
- Leveraged positions liquidated while sleeping
- No understanding of what just happened to their money

**Existing tools are all reactive.** They show you what happened AFTER you lost. ChainGuard acts BEFORE.

---

## What Makes This Different

This is not a dashboard. Not a trading bot. Not a chat interface.

**It's a Non-Fungible Agent (NFA) — a living entity on BNB Chain that you own.**

- Deployed using **BAP-578** (BNB Chain Agent Standard, Feb 2026)
- Has its own **ERC-8004 identity** and wallet on-chain
- Runs autonomously even when OpenClaw is closed
- Logs every alert it fires as **immutable on-chain proof**
- You always approve before any action is taken

---

## 5 Commands, 5 Superpowers

| Command | What it does | Cost |
|---------|-------------|------|
| `/deploy` | Deploys your personal NFA on BNB Testnet | ~0.002 tBNB (free from faucet) |
| `/audit [address]` | Full rug pull / honeypot scan in 30s | Free — BSCScan API |
| `/p2p [username]` | P2P seller reputation scan before you pay | Free — Binance P2P public API |
| `/guard [symbol]` | 24/7 position monitoring + liquidation alerts | Free — Binance public API |
| `/explain [term]` | Any crypto concept in plain language | Free — AI |
| `/tax [year]` | Annual P&L and tax-ready CSV | Free — your read-only Binance key |

---

## Installation (3 commands, 5 minutes)

```bash
# 1. Install OpenClaw
npm i -g openclaw

# 2. Install this skill
clawhub install claw-nfa-protector

# 3. Install Python dependencies
pip install web3 requests python-dotenv

# 4. Get a free BSCScan API key at bscscan.com/register
# 5. Get free testnet BNB at faucet.bnbchain.org

# 6. Start
openclaw onboard
# Then in WhatsApp/Telegram say: "Déploie mon Protector NFA"
```

### Optional: Add to .env for full features
```
BSCSCAN_API_KEY=your_key        # Free at bscscan.com/register
NFA_CONTRACT_ADDRESS=0x...      # After deployment
BINANCE_API_KEY=your_read_key   # Optional, for /tax command only
BINANCE_API_SECRET=your_secret  # Optional, for /tax command only
```

---

## Total Cost

| Component | Cost |
|-----------|------|
| OpenClaw | Free (open source) |
| BSCScan API | Free (5 req/sec) |
| Binance P2P Public API | Free (no auth) |
| Binance Market Data API | Free (no auth) |
| BNB Testnet BNB | Free (faucet.bnbchain.org) |
| NFA Deployment | ~0.002 tBNB ≈ $0.001 |
| **TOTAL** | **$0.00** |

---

## Architecture

```
User (WhatsApp/Telegram)
        ↓
  OpenClaw (local on your machine)
        ↓
  claw-nfa-protector SKILL
        ├── SKILL.md        ← Instructions for OpenClaw
        ├── nfa_core.py     ← Core logic (web3, BSCScan, Binance APIs)
        └── NFAProtector.sol ← Smart contract (BAP-578 + ERC-8004)
                                    ↓
                          BNB Chain Testnet
                          (your NFA lives here)
```

---

## File Structure

```
claw-nfa-protector/
├── SKILL.md                    ← OpenClaw skill (the brain)
├── README.md                   ← This file
├── demo.html                   ← Interactive demo (open in browser)
├── scripts/
│   └── nfa_core.py            ← Python core (audit, p2p, guard, tax)
└── contracts/
    └── NFAProtector.sol       ← Solidity smart contract
```

---

## Why This Wins

1. **Uses BNB's NEW infrastructure** — BAP-578 + ERC-8004 launched Feb 2026. This hackathon was created to find people who build on top of it. We do.

2. **Solves the #1 real problem** — Not a dashboard, not educational. Active prevention of the actual losses Binance users suffer.

3. **Fully testable by the jury** — Open Telegram, talk to the bot, watch an NFA deploy on BSCScan testnet in real-time.

4. **OpenClaw is the perfect base** — Persistent memory, heartbeats, messaging apps, local execution. Everything we need is already there.

5. **Zero cost** — No subscription. No server. Runs on your laptop.

---

Built for the **OpenClaw × Binance AI Builder Challenge**, March 4–18, 2026.

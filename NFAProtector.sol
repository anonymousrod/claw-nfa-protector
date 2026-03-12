// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * ╔══════════════════════════════════════════════════════╗
 * ║          CLAW NFA PROTECTOR — BNB Chain             ║
 * ║    BAP-578 Non-Fungible Agent + ERC-8004 Identity   ║
 * ║                                                      ║
 * ║  Your personal AI guardian lives on-chain.          ║
 * ║  It watches. It warns. You always decide.           ║
 * ╚══════════════════════════════════════════════════════╝
 *
 * Compatible with:
 *   - BNB Chain (BSC mainnet / testnet)
 *   - BAP-578 Agent Standard (Feb 2026)
 *   - ERC-8004 Agent Identity
 *
 * Deploy cost: ~0.002 BNB (≈ $0.001 on testnet = FREE)
 */

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFAProtector is ERC721, Ownable {

    // ─── NFA Identity (ERC-8004) ───────────────────────────────
    struct AgentIdentity {
        string  name;           // e.g. "Mon Protecteur BNB"
        address wallet;         // NFA's own wallet address
        uint256 deployedAt;     // timestamp
        uint256 riskTolerance;  // 0-100, user defined
        bool    active;
    }

    // ─── Protection Log (on-chain proof) ──────────────────────
    struct AlertRecord {
        uint256 timestamp;
        string  alertType;   // "RUG_PULL" | "P2P_SCAM" | "LIQUIDATION" | "DELISTING"
        string  tokenOrUser; // what was scanned
        uint8   riskScore;   // 0-100
        bool    blocked;     // did NFA block the action?
    }

    // ─── State ─────────────────────────────────────────────────
    mapping(uint256 => AgentIdentity) public agents;       // tokenId → identity
    mapping(uint256 => AlertRecord[]) public alertHistory; // tokenId → alerts
    mapping(uint256 => uint256)       public scansCount;   // tokenId → total scans

    uint256 private _nextTokenId = 1;

    // ─── Events ────────────────────────────────────────────────
    event AgentDeployed(uint256 indexed tokenId, address owner, string name, address agentWallet);
    event AlertFired(uint256 indexed tokenId, string alertType, string target, uint8 riskScore, bool blocked);
    event AgentUpdated(uint256 indexed tokenId, uint256 newRiskTolerance);

    constructor() ERC721("CLAW NFA Protector", "NFAP") Ownable(msg.sender) {}

    // ─────────────────────────────────────────────────────────────
    //  DEPLOY YOUR PERSONAL NFA
    //  Called once by OpenClaw when user says "Déploie mon Protector"
    // ─────────────────────────────────────────────────────────────
    function deployAgent(
        string  memory _name,
        address _agentWallet,
        uint256 _riskTolerance   // 0-100
    ) external returns (uint256 tokenId) {
        require(_riskTolerance <= 100, "Risk tolerance must be 0-100");
        require(_agentWallet != address(0), "Invalid agent wallet");

        tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);

        agents[tokenId] = AgentIdentity({
            name:           _name,
            wallet:         _agentWallet,
            deployedAt:     block.timestamp,
            riskTolerance:  _riskTolerance,
            active:         true
        });

        emit AgentDeployed(tokenId, msg.sender, _name, _agentWallet);
        return tokenId;
    }

    // ─────────────────────────────────────────────────────────────
    //  LOG AN ALERT (called by OpenClaw when danger detected)
    //  Creates immutable proof on-chain that your NFA protected you
    // ─────────────────────────────────────────────────────────────
    function logAlert(
        uint256 tokenId,
        string  memory alertType,
        string  memory tokenOrUser,
        uint8   riskScore,
        bool    blocked
    ) external {
        require(ownerOf(tokenId) == msg.sender || agents[tokenId].wallet == msg.sender,
            "Only owner or NFA wallet can log alerts");
        require(agents[tokenId].active, "Agent not active");

        alertHistory[tokenId].push(AlertRecord({
            timestamp:   block.timestamp,
            alertType:   alertType,
            tokenOrUser: tokenOrUser,
            riskScore:   riskScore,
            blocked:     blocked
        }));

        scansCount[tokenId]++;

        emit AlertFired(tokenId, alertType, tokenOrUser, riskScore, blocked);
    }

    // ─────────────────────────────────────────────────────────────
    //  UPDATE RISK SETTINGS (user changes via chat)
    // ─────────────────────────────────────────────────────────────
    function updateRiskTolerance(uint256 tokenId, uint256 newTolerance) external {
        require(ownerOf(tokenId) == msg.sender, "Not your NFA");
        require(newTolerance <= 100, "Must be 0-100");
        agents[tokenId].riskTolerance = newTolerance;
        emit AgentUpdated(tokenId, newTolerance);
    }

    // ─────────────────────────────────────────────────────────────
    //  READ FUNCTIONS
    // ─────────────────────────────────────────────────────────────
    function getAlerts(uint256 tokenId) external view returns (AlertRecord[] memory) {
        return alertHistory[tokenId];
    }

    function getAgent(uint256 tokenId) external view returns (AgentIdentity memory) {
        return agents[tokenId];
    }

    function getStats(uint256 tokenId) external view returns (
        uint256 totalScans,
        uint256 totalAlerts,
        uint256 blockedCount
    ) {
        totalScans  = scansCount[tokenId];
        AlertRecord[] memory alerts = alertHistory[tokenId];
        totalAlerts = alerts.length;
        for (uint256 i = 0; i < alerts.length; i++) {
            if (alerts[i].blocked) blockedCount++;
        }
    }
}

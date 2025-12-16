// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title Veritas Blockchain Certification (SBT)
 * @author Ing. Fernando Gutiérrez Berumen (Daemon Tech)
 * @notice Protocolo de certificación Soulbound. Final Clean.
 */
contract VeritasSBT is ERC721, ERC721URIStorage, Ownable {
    
    uint256 private _nextTokenId;

    event CertificateIssued(address indexed recipient, uint256 tokenId, string ipfsUrl);
    event CertificateRevoked(uint256 tokenId, string reason);

    constructor(address initialOwner) ERC721("Veritas Certification", "VRT") Ownable(initialOwner) {}

    function issueCertificate(address recipient, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, uri);
        emit CertificateIssued(recipient, tokenId, uri);
        return tokenId;
    }

    /**
     * @dev CANDADO MAESTRO
     */
    function _update(address to, uint256 tokenId, address auth) internal override(ERC721) returns (address) {
        address from = _ownerOf(tokenId);
        if (from != address(0) && to != address(0)) {
            revert("VeritasSBT: Soulbound - No transferible.");
        }
        return super._update(to, tokenId, auth);
    }

    // --- BLOQUEOS SILENCIOSOS (Clean Code) ---

    // Al comentar los nombres de las variables /*variable*/, eliminamos los warnings.

    function transferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public pure override(ERC721, IERC721) {
        revert("VeritasSBT: Prohibido.");
    }

    function safeTransferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/, bytes memory /*data*/) public pure override(ERC721, IERC721) {
        revert("VeritasSBT: Prohibido.");
    }

    function safeTransferFrom(address /*from*/, address /*to*/, uint256 /*tokenId*/) public pure override(IERC721) {
        revert("VeritasSBT: Prohibido.");
    }

    // --- OVERRIDES OBLIGATORIOS ---

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function revokeCertificate(uint256 tokenId, string memory reason) public onlyOwner {
        _burn(tokenId);
        emit CertificateRevoked(tokenId, reason);
    }
}
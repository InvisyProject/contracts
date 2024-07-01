// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InvoiceNFT is ERC721, Ownable {
    uint256 public tokenIdCounter;

    struct Invoice {
        uint256 billAmount;
        string token;
        uint256 createdAt;
        uint256 dueDate;
        string uniqueId;
        address buyer;
        address seller;
        address payer;
        address payee;
        string status;
    }

    mapping(uint256 => Invoice) public invoices;

    event InvoiceMinted(
        uint256 tokenId,
        uint256 billAmount,
        string token,
        uint256 createdAt,
        uint256 dueDate,
        string uniqueId,
        address indexed buyer,
        address indexed seller,
        address indexed payer,
        address payee,
        string status
    );

    constructor(address initialOwner) ERC721("InvoiceNFT", "INFT")  Ownable(initialOwner) {
    }

    function mintInvoice(
        address to,
        uint256 billAmount,
        string memory token,
        uint256 dueDate,
        string memory uniqueId,
        address buyer,
        address seller,
        address payer,
        address payee,
        string memory status
    ) public onlyOwner {
        uint256 tokenId = tokenIdCounter++;
        _mint(to, tokenId);

        invoices[tokenId] = Invoice({
            billAmount: billAmount,
            token: token,
            createdAt: block.timestamp,
            dueDate: dueDate,
            uniqueId: uniqueId,
            buyer: buyer,
            seller: seller,
            payer: payer,
            payee: payee,
            status: status
        });

        emit InvoiceMinted(
            tokenId,
            billAmount,
            token,
            block.timestamp,
            dueDate,
            uniqueId,
            buyer,
            seller,
            payer,
            payee,
            status
        );
    }

    function getInvoiceDetails(uint256 tokenId) public view returns (Invoice memory) {
        return invoices[tokenId];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract InvoiceNFT is ERC721 {
    uint256 public tokenIdCounter;
    mapping(uint256 => Invoice) public invoices;

    struct Invoice {
        uint256 billAmount;
        string token;
        uint256 createdAt;
        uint256 dueDate;
        string uniqueId;
        string buyer;
        string seller;
        address payer;
        address payee;
        string status;
    }

    event InvoiceMinted(
        uint256 tokenId,
        uint256 billAmount,
        string token,
        uint256 createdAt,
        uint256 dueDate,
        string uniqueId,
        string buyer,
        string seller,
        address payer,
        address payee,
        string status
    );

    // Modifier to restrict function call to a specific address
    modifier onlyToAddress(address to) {
        require(msg.sender == to, "Caller is not the authorized address");
        _;
    }

    constructor() ERC721("InvoiceNFT", "INFT") {}

    function mintInvoice(
        address to,
        uint256 billAmount,
        string memory token,
        uint256 dueDate,
        string memory uniqueId,
        string memory buyer,
        string memory seller,
        address payer,
        address payee,
        string memory status
    ) public onlyToAddress(to) {
        uint256 tokenId = tokenIdCounter;
        _mint(to, tokenId);
        tokenIdCounter++;

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
}
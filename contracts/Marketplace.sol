// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvoiceNFT.sol";

contract InvoiceFactoringMarketplace {
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 minBid;
        bool active;
    }

    InvoiceNFT public invoiceNFT;
    mapping(uint256 => Listing) public listings;

    event InvoiceListed(uint256 indexed tokenId, address indexed seller, uint256 minBid);
    event InvoicePurchased(uint256 indexed tokenId, address indexed buyer, uint256 price);

    constructor(address _invoiceNFT) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
    }

    function listInvoice(uint256 tokenId, uint256 minBid) external {
        require(invoiceNFT.ownerOf(tokenId) == msg.sender, "Not the owner");
        invoiceNFT.transferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing({
            tokenId: tokenId,
            seller: msg.sender,
            minBid: minBid,
            active: true
        });
        emit InvoiceListed(tokenId, msg.sender, minBid);
    }

    function purchaseInvoice(uint256 tokenId) external payable {
        Listing memory listing = listings[tokenId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.minBid, "Bid too low");

        listing.active = false;
        listings[tokenId] = listing;

        invoiceNFT.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        emit InvoicePurchased(tokenId, msg.sender, msg.value);
    }
}

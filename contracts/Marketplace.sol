pragma solidity ^0.8.0;

import "./InvoiceNFT.sol";

contract Marketplace {
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 minBid;
        bool active;
    }

    InvoiceNFT public invoiceNFT;
    mapping(uint256 => Listing) public listings;

    event InvoiceListed(uint256 tokenId, address seller, uint256 minBid);
    event InvoiceSold(uint256 tokenId, address buyer, uint256 price);

    constructor(address _invoiceNFT) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
    }

    function listInvoice(uint256 tokenId, uint256 minBid) public {
        require(invoiceNFT.ownerOf(tokenId) == msg.sender, "Not the owner");
        invoiceNFT.transferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing(tokenId, msg.sender, minBid, true);
        emit InvoiceListed(tokenId, msg.sender, minBid);
    }

    function buyInvoice(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.minBid, "Bid too low");

        listing.active = false;
        listings[tokenId] = listing;

        invoiceNFT.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        emit InvoiceSold(tokenId, msg.sender, msg.value);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./InvoiceNFT.sol";

contract InvoiceMarketplace is ERC721Holder {
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 minBid;
        bool active;
        uint256 billAmount;
        string token;
        uint256 dueDate;
        string uniqueId;
        string invoiceBuyer;
        string invoiceSeller;
        address payer;
        address payee;
        string status;
    }

    uint256 public totalListings;

    InvoiceNFT public invoiceNFT;
    mapping(uint256 => Listing) public listings;

    event InvoiceListed(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 minBid,
        uint256 billAmount,
        string token,
        uint256 dueDate,
        string uniqueId,
        string invoiceBuyer,
        string invoiceSeller,
        address payer,
        address payee,
        string status
    );
    event InvoicePurchased(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 price
    );

    constructor(address _invoiceNFT) {
        invoiceNFT = InvoiceNFT(_invoiceNFT);
        totalListings = 0;
    }

    function mintAndListInvoice(
        address to,
        uint256 billAmount,
        string memory token,
        uint256 dueDate,
        string memory uniqueId,
        string memory invoiceBuyer,
        string memory invoiceSeller,
        address payer,
        address payee,
        string memory status,
        uint256 minBid
    ) external {
        // Mint the invoice NFT
        invoiceNFT.mintInvoice(
            address(this),
            billAmount,
            token,
            dueDate,
            uniqueId,
            invoiceBuyer,
            invoiceSeller,
            payer,
            payee,
            status
        );

        uint256 tokenId = invoiceNFT.tokenIdCounter() - 1;

        // List the invoice NFT on the marketplace
        listings[tokenId] = Listing({
            tokenId: tokenId,
            seller: to,
            minBid: minBid,
            active: true,
            billAmount: billAmount,
            token: token,
            dueDate: dueDate,
            uniqueId: uniqueId,
            invoiceBuyer: invoiceBuyer,
            invoiceSeller: invoiceSeller,
            payer: payer,
            payee: payee,
            status: status
        });

        totalListings++;

        emit InvoiceListed(
            tokenId,
            to,
            minBid,
            billAmount,
            token,
            dueDate,
            uniqueId,
            invoiceBuyer,
            invoiceSeller,
            payer,
            payee,
            status
        );
    }

    function purchaseInvoice(uint256 tokenId) external payable {
        Listing storage listing = listings[tokenId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.minBid, "Bid too low");

        listing.active = false;

        invoiceNFT.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);

        emit InvoicePurchased(tokenId, msg.sender, msg.value);
    }

    function getListing(uint256 tokenId) public view returns (Listing memory) {
        return listings[tokenId];
    }

    function getTotalListings() public view returns (uint256) {
        return totalListings;
    }
}

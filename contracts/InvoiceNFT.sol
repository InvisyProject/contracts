pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InvoiceNFT is ERC721, Ownable {
    uint256 public tokenIdCounter;

    struct Invoice {
        uint256 amount;
        uint256 dueDate;
        string payerDetails;
    }

    mapping(uint256 => Invoice) public invoices;

    constructor(address initialOwner) ERC721("InvoiceNFT", "INFT") {
        tokenIdCounter = 0;
        _mint(initialOwner, tokenIdCounter++);
    }

    function mintInvoice(
        address to,
        uint256 amount,
        uint256 dueDate,
        string memory payerDetails
    ) public onlyOwner {
        uint256 tokenId = tokenIdCounter++;
        _mint(to, tokenId);
        invoices[tokenId] = Invoice(amount, dueDate, payerDetails);
    }
}

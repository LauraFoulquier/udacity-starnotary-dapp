pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {
    
    struct Star {
        string name;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    // Implement Task 1 Add a name and symbol properties
    // name: Is a short name to your token
    // symbol: Is a short string like 'USD' -> 'American Dollar'
    constructor() public ERC721("Bored Star", "BOS") {}

    function createStar(string memory _name, uint256 _tokenId) public {
        Star memory newStar = Star(_name);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId); 
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You cannot sell a star that does not belong to you");
        starsForSale[_tokenId] = _price;
    }

    // function _make_payable(address x) internal pure returns (address payable){
    //     return address(uint160(x));
    // }

    function buyAStar(uint256 _tokenId) public payable {
        require(starsForSale[_tokenId] > 0, "this star is not for sale");

        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value >= starCost, "not enough money");

        transferFrom(ownerAddress, msg.sender, _tokenId);
        //address payable ownerAddressPayable = _make_payable(ownerAddress);
        payable(ownerAddress).transfer(starCost);

        if (msg.value > starCost){
            payable(msg.sender).transfer(msg.value - starCost);
        }
    }

    // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
        require(msg.sender == ownerOf(_tokenId1) || msg.sender == ownerOf(_tokenId2), "You are not allowed to transfer a star that does not belong to you.");
        //2. You don't have to check for the price of the token (star)
        //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId2)
        address owner1 = ownerOf(_tokenId1);
        address owner2 = ownerOf(_tokenId2);

        //4. Use _transferFrom function to exchange the tokens.
        transferFrom(owner1, owner2, _tokenId1);
        transferFrom(owner2, owner1, _tokenId2);
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId), 'You are not the owner');
        transferFrom(msg.sender, _to1, _tokenId);
    }
}
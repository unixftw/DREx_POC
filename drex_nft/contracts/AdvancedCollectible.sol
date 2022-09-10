// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AdvancedCollectible is ERC721, VRFConsumerBase {
    enum Breed {
        DREX1
    }
    // add other things
    IERC20 private _token;
    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    mapping(uint256 => address) public tokenToOwner;
    mapping(address => uint256) public ownerToValue;
    event RequestedCollectible(bytes32 indexed requestId);
    event TransferSent(address _from, address _destAddr, uint256 _amount);

    // New event from the video!
    event ReturnedCollectible(bytes32 indexed requestId, uint256 randomNumber);
    uint256 public tokenCounter;
    bytes32 internal keyHash;
    uint256 internal fee;

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyhash,
        IERC20 erc_token_address
    )
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("DREX", "DRx")
    {
        tokenCounter = 0;
        keyHash = _keyhash;
        fee = 0.1 * 10**18;
        _token = erc_token_address;
    }

    function createCollectible(string memory tokenURI)
        public
        returns (bytes32)
    {
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit RequestedCollectible(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        address DrexOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(DrexOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        Breed breed = Breed(randomNumber % 1);
        tokenIdToBreed[newItemId] = breed;
        requestIdToTokenId[requestId] = newItemId;
        tokenToOwner[newItemId] = DrexOwner; //no of tokens each nft holds or the amount of token user can mint
        tokenCounter = tokenCounter + 1;
        emit ReturnedCollectible(requestId, randomNumber);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    function updateERC20Balance() public {
        uint256 erc20balance = _token.balanceOf(address(this));
        uint256 curr_balance_for_each_holder = erc20balance /
            (tokenCounter - 1);
        for (uint256 holder = 0; holder < tokenCounter; holder++) {
            address token_owner = tokenToOwner[holder];
            ownerToValue[token_owner] += curr_balance_for_each_holder;
        }
    }

    function transferERC20(address payable to, uint256 amount) public {
        uint256 owner_balance = ownerToValue[to];
        require(
            amount <= owner_balance,
            "balanced exceded the allocated amount"
        );
        ownerToValue[to] -= amount;
        _token.transfer(to, amount);
        emit TransferSent(msg.sender, to, amount);
    }
}

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; // Import SafeERC20

contract VotingToken is ERC20 {
    using SafeERC20 for IERC20; // Add SafeERC20 library usage

    uint private immutable maximum_supply;
    uint public immutable priceForToken;

    constructor(string memory name, string memory symbol, uint max_supply, uint price) ERC20(name, symbol) {
        maximum_supply = max_supply;
        priceForToken = price;
    }

    function buyToken(uint _amount) public payable {
        require((totalSupply() + _amount) <= maximum_supply, "a");
        require(msg.value >= (_amount * priceForToken), "b");
        _mint(msg.sender, _amount);
    }
 
    function _safeTransfer(address from, address to, uint256 amount) public {
        IERC20(this).safeTransferFrom(from, to, amount);
    }
}

pragma solidity ^0.8.14;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract VotingToken is ERC20
{
      uint private immutable  maximum_supply;
    uint public immutable priceForToken;
    constructor(string memory name,string memory symbol,uint max_supply,uint price)  ERC20(name, symbol)
    {
        maximum_supply=max_supply;
        priceForToken=price;
    }
      function buyToken(uint _amount) public payable 
    {
        require((totalSupply()+_amount)<=maximum_supply,"a");
        require(msg.value>=(_amount*priceForToken),"b");
        _mint(msg.sender, _amount);
    }
    function stack_token(address ad,uint token_Stacked) public 
    {
        _transfer(ad, address(this),token_Stacked);
    }
   function unstack_token(address ad,uint token_Stacked) public 
    {
        _transfer(address(this),ad,token_Stacked);
    }

}

pragma solidity ^0.8.15;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Wallet is Ownable{

struct Token {
    bytes32 ticker;
    address tokenAddress;
}
mapping(bytes32 => Token) public tokenMapping;
bytes32[] public tokenList;

mapping(address => mapping( bytes32 => uint256 )) public balances;

modifier tokenExist(bytes32 ticker){
    require (tokenMapping[ticker].tokenAddress != address(0), "Token doesn't exist");
    _;
}

function addToken(bytes32 ticker, address tokenAddress) external onlyOwner{
    tokenMapping[ticker] = Token(ticker, tokenAddress);
    tokenList.push(ticker);
}

function deposit(uint amount, bytes32 ticker) external tokenExist(ticker) {
    IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
    balances[msg.sender][ticker] += amount;
}

function withdraw(uint amount, bytes32 ticker) external tokenExist(ticker) {
    require (balances[msg.sender][ticker] >= amount, "Balance not sufficient");
    balances[msg.sender][ticker] -= amount;
    IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);

}

}

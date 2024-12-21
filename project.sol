// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ARGame {
    string public name = "Augmented Reality Game Token";
    string public symbol = "ARGT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(bytes32 => bool) public visitedLocations;

    event RewardDistributed(address indexed player, uint256 amount);
    event LocationVisited(bytes32 locationHash, address indexed player);

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    function distributeReward(address _player, uint256 _amount, string memory _location) public onlyOwner {
        require(balanceOf[owner] >= _amount, "Not enough tokens to distribute");

        // Create a unique hash for the location
        bytes32 locationHash = keccak256(abi.encodePacked(_location, _player));
        require(!visitedLocations[locationHash], "Location already visited by this player");

        visitedLocations[locationHash] = true;
        balanceOf[owner] -= _amount;
        balanceOf[_player] += _amount;

        emit RewardDistributed(_player, _amount);
        emit LocationVisited(locationHash, _player);
    }

    function getPlayerBalance(address _player) public view returns (uint256) {
        return balanceOf[_player];
    }
}
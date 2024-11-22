// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MoodNFT} from "../src/MoodNFT.sol";


contract MintMoodNft is Script {
    function run () external {
        address mostRecentlyDeployedMoodNft = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
        mintNftOnContract(mostRecentlyDeployedMoodNft);
    }
    function mintNftOnContract (address MoodNFTAddress) public {
        console.log('this is the mostRecentDeployedMoodNft', MoodNFTAddress);
        console.log('Hi');
        vm.startBroadcast();
            MoodNFT(MoodNFTAddress).CreateAndMint("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
        vm.stopBroadcast();
    }
}

contract flipMoodNFTMood is Script {
    uint256 tokenId;
    function run () external {
         address mostRecentlyDeployedMoodNft = DevOpsTools.get_most_recent_deployment("MoodNFT", block.chainid);
         flipNFTMood(mostRecentlyDeployedMoodNft);
    }

    function flipNFTMood (address MoodNFTAddress) public {
        vm.startBroadcast ();
        MoodNFT(MoodNFTAddress).flipNFTMood(tokenId);
        vm.stopBroadcast();
    }
} 

//0x5FbDB2315678afecb367f032d93F642f64180aa3
//0x5FbDB2315678afecb367f032d93F642f64180aa3

//0x5fbdb2315678afecb367f032d93f642f64180aa3
//0x5FbDB2315678afecb367f032d93F642f64180aa3
//0x5FbDB2315678afecb367f032d93F642f64180aa3
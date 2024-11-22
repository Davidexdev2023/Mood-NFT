// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Imports 
import {Script,console} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
 
contract DeployMoodNFT is Script {
    MoodNFT moodNFT;

    function run () external returns (MoodNFT) {
        string memory happyImg = vm.readFile("./img/happy.svg");
        string memory sadImg = vm.readFile("./img/sad.svg");
        vm.startBroadcast();
        moodNFT = new MoodNFT (svgToImageURL(sadImg), svgToImageURL(happyImg));
        vm.stopBroadcast();
        return moodNFT;
    }

    
    function svgToImageURL (string memory svgToConvert) internal pure returns (string memory){
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(abi.encodePacked(svgToConvert));
        return (string.concat(baseURI, svgBase64Encoded));
    }
}
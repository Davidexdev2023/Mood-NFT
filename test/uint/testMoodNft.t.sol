// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol"; 
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract TestMoodNFT is Test {
    using Strings for uint256;
    DeployMoodNFT deployMoodNFT;
    MoodNFT moodNFT;

    string  expectedSadImageURL = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8c3ZnIHdpZHRoPSIxMDI0cHgiIGhlaWdodD0iMTAyNHB4IiB2aWV3Qm94PSIwIDAgMTAyNCAxMDI0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik01MTIgNjRDMjY0LjYgNjQgNjQgMjY0LjYgNjQgNTEyczIwMC42IDQ0OCA0NDggNDQ4IDQ0OC0yMDAuNiA0NDgtNDQ4Uzc1OS40IDY0IDUxMiA2NHptMCA4MjBjLTIwNS40IDAtMzcyLTE2Ni42LTM3Mi0zNzJzMTY2LjYtMzcyIDM3Mi0zNzIgMzcyIDE2Ni42IDM3MiAzNzItMTY2LjYgMzcyLTM3MiAzNzJ6Ii8+CiAgPHBhdGggZmlsbD0iI0U2RTZFNiIgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIvPgogIDxwYXRoIGZpbGw9IiMzMzMiIGQ9Ik0yODggNDIxYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHptMjI0IDExMmMtODUuNSAwLTE1NS42IDY3LjMtMTYwIDE1MS42YTggOCAwIDAgMCA4IDguNGg0OC4xYzQuMiAwIDcuOC0zLjIgOC4xLTcuNCAzLjctNDkuNSA0NS4zLTg4LjYgOTUuOC04OC42czkyIDM5LjEgOTUuOCA4OC42Yy4zIDQuMiAzLjkgNy40IDguMSA3LjRINjY0YTggOCAwIDAgMCA4LTguNEM2NjcuNiA2MDAuMyA1OTcuNSA1MzMgNTEyIDUzM3ptMTI4LTExMmE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6Ii8+Cjwvc3ZnPg==";
    string  expectedHappyImageUrl = "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";

    MoodNFT.MOOD moodNftMood;
    address USER = makeAddr('USER');
    
    
    function setUp () external {
        deployMoodNFT = new DeployMoodNFT () ;
        moodNFT = deployMoodNFT.run();
    }

    function createUrl(string memory des, string memory attribute, uint256 value) internal view returns (string memory) {
        string memory valueToString = value.toString();
        return string.concat(
            "data:application/json;base64,",
             Base64.encode(abi.encodePacked(
                 '{',
                    '"name":"', moodNFT.name(), '",',
                    '"description":"', des, '",',
                    '"attributes":[{"trait_type":"', attribute, '","value":"', valueToString, '"}],',
                    '"image":"', expectedHappyImageUrl, '"',
                    '}'
            ))
        );
    }

    function testImageURLNotEmpty () public view  {
        string memory moodNFTSadImageURL =  moodNFT.getSadImageURL();
        string memory moodNFTHappyImageURL = moodNFT.getHappyImageURL();
        assertEq (keccak256(abi.encodePacked(expectedSadImageURL)), keccak256(abi.encodePacked(moodNFTSadImageURL)));
        assertEq(keccak256(abi.encodePacked(expectedHappyImageUrl)), keccak256(abi.encodePacked(moodNFTHappyImageURL)));
    }

    function testCreateUriMetaDataToMint () public  {
        moodNftMood = MoodNFT.MOOD.HAPPY;
        string memory  expectedUri = createUrl("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
        string memory uriCreated = moodNFT.createUriMetaDataToMint("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000, moodNftMood );
        assertTrue(bytes(uriCreated).length > 0,"uriCreated should not be empty");
        assertEq(keccak256(abi.encodePacked(expectedUri)), keccak256(abi.encodePacked(uriCreated)));
    }

    function testCreateAndNMintFailsIfParamaterisEmpty () public {
        vm.expectRevert(MoodNFT.MoodNFT__DetailsCantMint.selector);
        moodNFT.CreateAndMint("", '[{"trait_type": "moodiness", "value": 100}]', 1000);

        vm.expectRevert(MoodNFT.MoodNFT__DetailsCantMint.selector);
        moodNFT.CreateAndMint("A simple Mood Nft", '', 1000);
    }

    function testNotEmpty () public  view  {
       bool  trueresult  = moodNFT.testNotEmpty("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
       bool  falseResult = moodNFT.testNotEmpty("", '[{"trait_type": "moodiness", "value": 100}]', 1000);
       assertTrue(trueresult,"notEmpty should return true for non-empty description, attribute, and positive value");
       assertFalse(falseResult, "notEmpty should return false for empty description, attribute, and positive value");
    }


    function testCounterIsUpdatedWhenCreateAndMintIsCalled () public {
        uint256 initialTokenCount = moodNFT.getS_Counter();

        vm.prank(USER);
        moodNFT.CreateAndMint("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);

        uint256 currentTokenCount = moodNFT.getS_Counter();

        assertTrue(currentTokenCount > initialTokenCount);
    }

    function testANonReturnAccountCannotMint () public {
        vm.prank(address(0));
        vm.expectRevert();
        moodNFT.CreateAndMint("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
    }
 
    function testURISavedToTokenId () public {
        string memory expectedURL = createUrl("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
        moodNFT.CreateAndMint("A simple Mood Nft", '[{"trait_type": "moodiness", "value": 100}]', 1000);
        string memory actualURL = moodNFT.tokenURI(0);
        console.log(expectedURL);
        console.log(actualURL);
       // assertEq(keccak256(abi.encodePacked(expectedURL)), keccak256(abi.encodePacked(actualURL)));
    }

}
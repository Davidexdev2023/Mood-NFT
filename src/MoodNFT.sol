// Layout of Contract:
// version
// imports
// interfaces, libraries, contracts
// errors
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @author Adeleye david
 * 
 */
contract MoodNFT is ERC721, Ownable  {
    using Strings for uint256;
    
    /////////////////////
    //      ERRORS     //
    /////////////////////
    error MoodNFT__TokenUriNotFound();
    error MoodNFT__DetailsCantMint ();
    error MoodNft__CantFlipMoodIfNotOwner();

    ///////////////////////
    //  TYPE DECLARATION //
    ///////////////////////
    enum MOOD {
        HAPPY,
        SAD
    }


    /////////////////////
    // STATE VARIABLES //
    /////////////////////
    string private s_sadImageURL;
    string private s_happyImageURL;
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private tokenIdToURL;
    mapping(uint256 => string) private tokenIdToDescription;
    mapping(uint256 => string) private tokenIdToAttribute;
    mapping(uint256 => uint256) private tokenIdToValue;
    mapping(uint256 => MOOD) private tokenIdToMood;

    //////////////////
    // CONSTRUCTOR //
    /////////////////
    constructor (string memory sadImageURI,  string memory happyImageURI) ERC721("Darvex NFT", "DX" ) Ownable(msg.sender) {
        s_sadImageURL = sadImageURI;
        s_happyImageURL = happyImageURI;
        s_tokenCounter = 0;
    }



    function _baseURI () internal pure override returns(string memory){
        // The ERC721 contract hes a _baseURI function which returns a string
        return "data:application/json;base64,";
        
    }


    
    ///////////////////////
    // PUBLIC FUNCTIONS //
    /////////////////////
    function createUriMetaDataToMint   (
        string memory description,
        string memory attribute,
        uint256 value,
        MOOD nftMood
    ) public returns (string memory) {
        string memory nftImageURL;
        // Specifying the imageURL
        if(nftMood == MOOD.SAD){
            nftImageURL = s_sadImageURL;
        }else{
            nftImageURL = s_happyImageURL;
        }

        //  include if statement that require the srtings not enpty
        tokenIdToDescription[s_tokenCounter] = description;
        tokenIdToAttribute[s_tokenCounter] = attribute;
        tokenIdToValue[s_tokenCounter] = value;
        string memory valueToString = value.toString();
        return
        string.concat(
            _baseURI(),
            Base64.encode( 
                abi.encodePacked(
                    '{',
                    '"name":"', name(), '",',
                    '"description":"', description, '",',
                    '"attributes":[{"trait_type":"', attribute, '","value":"', valueToString, '"}],',
                    '"image":"', nftImageURL, '"',
                    '}'
                    )     
            )
        );
    }

    function tokenURI (uint256 tokenId) public view override returns (string memory){
        if (ownerOf(tokenId) == address(0)) {
                revert MoodNFT__TokenUriNotFound();
            }
        string memory uri = tokenIdToURL[tokenId];
        return uri;
    }

    function testNotEmpty (string memory description , string memory attribute, uint256 value) public pure returns (bool) {
        return notEmpty(description, attribute, value);
    }

    function CreateAndMint (string memory description, string memory attribute, uint256 value) public  {
        //check to see if the  strings are not empty
        if(!notEmpty(description, attribute, value)){
             revert MoodNFT__DetailsCantMint ();
        }
        tokenIdToMood[s_tokenCounter] = MOOD.HAPPY;
        string memory URI = createUriMetaDataToMint(description, attribute, value , tokenIdToMood[s_tokenCounter]);
        _Mint(URI);   
    }
    
    function flipNFTMood (uint256 tokenId) public {
         if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
         }
        if(tokenIdToMood[s_tokenCounter] == MOOD.HAPPY){
            tokenIdToMood[s_tokenCounter] = MOOD.SAD;
        }else{
            tokenIdToMood[s_tokenCounter] == MOOD.HAPPY;
        }
    
        string memory description = tokenIdToDescription[s_tokenCounter];
        string memory attribute =  tokenIdToAttribute[s_tokenCounter];
        uint256 value = tokenIdToValue[s_tokenCounter];
        string memory tokenUri = createUriMetaDataToMint(description, attribute, value , tokenIdToMood[s_tokenCounter]);
        tokenIdToURL[s_tokenCounter] = tokenUri;
    }



    
    /////////////////////////
    // INTERNAL FUNCTIONS //
    ///////////////////////
    function notEmpty (string memory description , string memory attribute, uint256 value) internal pure returns (bool){
        bool checkDescription = bytes(description).length >0;
        bool checkattribute = bytes(attribute).length > 0;
        bool checkvalue = value > 0; 
        bool checkTotal = checkattribute && checkDescription && checkvalue;
        return checkTotal;
    }


    function _Mint (string memory tokenUri) internal {
        _mint(msg.sender , s_tokenCounter);
        tokenIdToURL[s_tokenCounter] = tokenUri;
        s_tokenCounter++;
    }

   




    //////////////////////
    // GETTER FUNCTIONS //
    /////////////////////

    function getSadImageURL () public view returns (string memory) {
        return s_sadImageURL;
    }

    function getS_Counter () public view returns (uint256) {
        return s_tokenCounter;
    }

     function getHappyImageURL () public view returns (string memory) {
        return s_happyImageURL;
    }

}
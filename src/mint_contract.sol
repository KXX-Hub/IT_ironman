// SPDX-License-Identifier: MIT 大家都可以使用在自己的合約上，代表開源
pragma solidity ^0.8.4; // solidity版本

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";//使用ERC-721功能
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";//使用ERC-721 Enumerable擴充功能
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";//使用ERC-721 URIStorage擴充功能
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";//持續追蹤NFT功能

contract KNFT is ERC721, ERC721Enumerable, ERC721URIStorage {//這邊因為要讓每個人都可以mint，因此我們將ownable方法刪除
    using Counters for Counters.Counter;//用來追蹤NFT

    Counters.Counter private _tokenIdCounter;//此功能只能在這個智能合約使用，繼承的合約不行使用和讀取
    uint256 MAX_SUPPLY = 10;//NFT最大供應量
    constructor() ERC721("KNFT", "K") {}//ERC-721的資料結構(名稱,代號)

    //safeMint

    function safeMint(address to, string memory uri) public  {//(錢包地址,之後要填入的MetaData)，這邊public是公開的，和後面的onlyowner牴觸，所以刪掉
        uint256 tokenId = _tokenIdCounter.current();
        require (tokenId <= MAX_SUPPLY , "All NFT have been minted");//這邊我追們加一個require語法，當NTF被mint完後，就會顯示已售完
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);//這邊(to 你的錢包地址 , token id)
        _setTokenURI(tokenId, uri);//()
    }

    // The following functions are overrides required by Solidity.

    //TokenTransfer
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal//internal 比較像pravite但是繼承的合約他可以讀取和使用
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    //Burn
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    //TokenURI
    function tokenURI(uint256 tokenId)
    public
    view//讀取區塊鏈上的資料，在自己的錢包讀取不需要支付gas
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    //supportsInterface
    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
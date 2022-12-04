// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tabenomics is ERC721A, Ownable, ERC721ABurnable, ERC721AQueryable{
    string public baseURI = "ipfs://bafybeig6fzsdgndbd7epi7mqvylqgz5eyomwfcnxqy4idgf3zovm4dymga/";
    uint256 constant MaxMint = 3;
    uint256 constant MaxNfts = 100;
    uint256 constant startTokenId = 1;
    uint256 nowTokenId = 0;
    uint256 totalNFTs = 0;
    uint256 constant TokenIdIncrement = 1;
    uint256 public quantity;
    address FreeMintAddress1 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address FreeMintAddress2 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    uint256 [] HaveToken;

    constructor() ERC721A("Tabenomics", "TBM") {
    }


    event MintLog(address from, address to, uint256 tokenId);

    /// @dev ベースURI:ipfs//~
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /// @dev URIのスタートナンバー
    function _startTokenId() internal view virtual override returns (uint256){
        //nowTokenId = startTokenId;
        return startTokenId;
    }

    /// @dev URI次のIdナンバー
    function _nextTokenId() internal view virtual override returns (uint256){
        return nowTokenId;
    }

    /// @dev Mintされた合計数
    function _totalMinted() internal view override returns (uint256){
        return totalNFTs;
    }

    /**
    * @dev
    * - 最大数までMintされていたらMintしない
    */
    modifier MaxMints(){
        require(MaxNfts >= totalSupply(),"sold out");
        _;
    }

    /**
    * @dev
    * - 最大数以上Mintしないよう制限
    */
    modifier NosingOverMints(uint256 quatity){
        require(quatity <= MaxNfts - totalSupply(),"Mints less please");
        _;
    }

    /**
    * @dev
    * -  フリーMintアドレスの確認
    */
    
    modifier FreeMintChake(address freeaddress){
        require((FreeMintAddress1 == freeaddress) || (FreeMintAddress2 == freeaddress),"No Free Mint Address It");
        _;
    }
    
    /**
    * @dev
    * - ユーザーMint
    * - 一度のMint最大数3
    * - 最大数以上Mintしないように制限
    */
    function mintUser(uint256 quantity) external
    MaxMints
    NosingOverMints(quantity) 
    {
        //require(MaxNfts >= totalNFTs,"sold out");
        require(MaxMint >= quantity, "MaxMint Over");
        _nextTokenId();
        _mint(msg.sender, quantity);
    }

    /**
    * @dev
    * - オーナーMint
    * - 一度のMint上限数なし
    * - 最大数以上Mintしないように制限
    */
    function mintOwner(uint256 quantity) external
     onlyOwner
     MaxMints
     NosingOverMints(quantity) 
     {
        //require(MaxNfts >= totalNFTs,"sold out");
        _nextTokenId();
        _mint(msg.sender, quantity);
    }

    /**
    * @dev
    * - フリーMint
    * - 特定アドレスのみフリーミント可能
    * - 最大数以上Mintしないように制限
    */
    function freemint(uint256 quantity) external
     MaxMints
     NosingOverMints(quantity)
     FreeMintChake(msg.sender)
     {
        _nextTokenId();
        _mint(msg.sender, quantity);
    }

/*
    function changeURI(string calldata seturi) external onlyOwner{
        baseURI = seturi;
        nowTokenId = startTokenId;
    }
*/
    function burn(uint256 tokenId, bool approvalCheck) internal virtual {
        _burn(tokenId, approvalCheck);
    }


    /**
    * @dev
    * - ここから送金等に関するスクリプト
    * - 特定アドレスのみフリーミント可能
    * - 最大数以上Mintしないように制限
    */

    // Tabenomicsコントラクトアドレスにetherを送金する関数
    function deposit() payable public {}

    // 接続アドレスのether残高を返す関数
    function getBalance() public view returns (uint256) {
        return msg.sender.balance;
    }

    function withdraw(uint _amount) public payable {
        (bool success, ) = payable(owner()).call{value: _amount}(
            ""
        );
        require(success);
    }


    function UserTransfer(
    uint256 tokenId
    ) public virtual{
        transferFrom(msg.sender, owner(), tokenId);
    }


    function OwnerTransfer(
    address to,
    uint256 tokenId
    ) public virtual onlyOwner{
        transferFrom(owner(), to, tokenId);
    }

    function _tokensOfOwner(address owner) external view returns (uint256[] memory){
        return HaveToken;
    }
}
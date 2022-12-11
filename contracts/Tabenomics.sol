// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tabenomics is ERC721A, Ownable, ERC721ABurnable, ERC721AQueryable{
    string public baseURI = "ipfs://bafybeibkhw6su5qahc3washzq4sxa4rwsjyapehejv7v5h7ib7ovbajh4q/metadata";   //ベースURI
    uint256 constant MaxMint = 3;   //1人辺りのミント最大数
    uint256 constant MaxNfts = 3000;   //NFTの総数
    uint256 constant startTokenId = 1;   //NFTミントスタートID
    uint256 constant NftSalePrice = 30000000000000000;   //プレセール値
    uint256 constant NftPrice = 50000000000000000;   //パブリックセール値
    uint256 cost = NftPrice;   //NFT価格初期設定
    uint256 nowTokenId = 0;
    uint256 totalNFTs = 0;
    address FreeMintAddress1 = 0xEBD831aA0343789150Cdffce067479Bb848C5aC8;   //フリーミントアドレス1
    address FreeMintAddress2 = 0x4CFaFBcE67942e79Edb1dd67eccC271a536D202D;   //フリーミントアドレス2
    uint256 totalMint;   //今までのミントされた合計数
    uint256[] MyNftTokenId;   //ユーザーの総トークンID
    address[] public whitelistedAddresses;   //ホワイトリストアドレス
    bool public onlyWhitelisted = false;   //ホワイトリストメンバーしかミントできない状態
    mapping(address => uint256) public WhitelistAddressMintedBalance;   //ホワイトリストMint数
    mapping(address => uint256) public addressMintedBalance;   //ユーザーMint数
    
    

    constructor() ERC721A("Tabenomics", "TBM") {
    }


    event MintLog(address to, uint256 quantity);
    event TransferLog(address from, address to, uint256 tokenId);
    event TokenTransfer(address from, address receiver, uint amount);

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
    * - プレセール、通常時の価格設定
    * - プレセールホワイトリスト切り替え
    */
    function PriceCange(bool sale)
    external
    onlyOwner
    {
        if(sale == true){
            cost = NftSalePrice;
            onlyWhitelisted = sale;
        }else{
            cost = NftPrice;
            onlyWhitelisted = sale;
        }
    }

    /**
    * @dev
    * - ホワイトリスト格納関数
    */
    function whitelistUsers(address[] calldata _users)public onlyOwner{
        delete whitelistedAddresses;
        whitelistedAddresses = _users;
    }

    /**
    * @dev
    * - ホワイトリスト格納関数
    */
    function isWhitelisted(address _user)public view returns(bool){
        for(uint i = 0; i < whitelistedAddresses.length; i++){
            if(whitelistedAddresses[i] == _user){
                return true;
            }
        }
        return false;
    }

    
    /**
    * @dev
    * - ユーザーMint
    * - 一度のMint最大数3
    * - 最大数以上Mintしないように制限
    * - プレセール時はホワイトリストメンバーのみ制限
    */
    function mintUser(uint256 quantity) external
    payable
    MaxMints
    NosingOverMints(quantity) 
    {
        uint256 MintCount = addressMintedBalance[msg.sender];
        require(MintCount + quantity <= MaxMint, "MaxMint Over");
        require(msg.value >= quantity * cost, "Not enough money");
        if(onlyWhitelisted == true){
            require(isWhitelisted(msg.sender),"user is not whitelisted");
            uint256 ownerMintedCount = WhitelistAddressMintedBalance[msg.sender];
            require(ownerMintedCount + quantity <= MaxMint, "MaxMint Over");
        }
        _nextTokenId();
        _mint(msg.sender, quantity);
        withdraw();
        if(onlyWhitelisted != true){
            addressMintedBalance[msg.sender] += quantity;
        }
        WhitelistAddressMintedBalance[msg.sender] += quantity;
        emit MintLog(msg.sender, quantity);
    }

    /**
    * @dev
    * - オーナーMint
    * - 一度のMint上限数なし
    * - 最大数以上Mintしないように制限
    * - Mintする
    */
    function mintOwner(address _to, uint256 quantity) external
     onlyOwner
     MaxMints
     NosingOverMints(quantity)
     {
        //require(MaxNfts >= totalNFTs,"sold out");
        _nextTokenId();
        _mint(_to, quantity);
        emit MintLog(_to, quantity);
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
        emit MintLog(msg.sender, quantity);
    }

    /**
    * @dev
    * - バーン関数
    * - 
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

    // 接続アドレスのether残高を返す関数
    function getBalance() public view returns (uint256) {
        return msg.sender.balance;
    }

    // オーナーアドレスへコントラクトアドレスのethを全て送金
    function withdraw() public payable {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    /**
    * @dev
    * - ユーザートランスファー
    * - ユーザーの持っているNFTの数とTokenIdを出す
    * - その後条件にかけてburn
    */
    function UserTransfer(
    uint256 quantity
    ) public virtual{
        uint256[] memory tokenNumber = MyTokenId();
        uint256 tokenleng = tokenNumber.length;
        uint256 index = 0;
        require(tokenleng >= quantity,"NFT Nons");
        while(quantity > index){
            transferFrom(msg.sender, owner(), tokenNumber[index]);
            emit TransferLog(msg.sender, owner(), tokenNumber[index]);
            index = index + 1;
        }
    }

    /**
    * @dev
    * - オーナートランスファー
    */
    function OwnerTransfer(
    address to,
    uint256 tokenId
    ) public virtual onlyOwner{
        transferFrom(owner(), to, tokenId);
        emit TransferLog(owner(), to, tokenId);
    }

    function BeforeTokenTransfers(
        address from,
        uint256 stratId,
        uint256 quantity
    ) external virtual {
        _beforeTokenTransfers(msg.sender, from, stratId, quantity);
    }

    function AfterTokenTransfers(
        address from,
        uint256 stratId,
        uint256 quantity
    ) external virtual {
        _afterTokenTransfers(msg.sender, from, stratId, quantity);
    }

    /**
    * @dev
    * - ユーザーの所持トークンIDを取得
    */
    function MyTokenId() private returns(uint256[] memory) {
        uint256 index = 1;
        uint256 dindex = 0;
        address user;
        uint leng = 0;
        totalMint = totalSupply();
        leng = MyNftTokenId.length;
        while (dindex < leng){
            MyNftTokenId.pop();
            dindex = dindex + 1;
        }
        while (index <= totalMint){
            user = ownerOf(index);
            if (user == msg.sender){
                MyNftTokenId.push(index);
            }
            index = index + 1;
        }
        return MyNftTokenId;
    }
}
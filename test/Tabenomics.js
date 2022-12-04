const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("memberNFTコントラクト", function(){
    let MemberNFT;
    let memberNFT;
    const name = "MemberNFT"
    const symbol = "MEM";
    const tokenURI1 = "hoge1";
    const tokenURI2 = "hoge2";
    let owner;
    let addr1;

    beforeEach(async function(){
        [ owner, addr1 ] = await ethers.getSigners();
        MemberNFT = await ethers.getContractFactory("MemberNFT");
        memberNFT = await MemberNFT.deploy();
        await memberNFT.deployed();
    });

    it("トークンの名前とシンボルのセット", async function(){

        expect(await memberNFT.name()).to.equal(name);
        expect(await memberNFT.symbol()).to.equal(symbol);

    });
});
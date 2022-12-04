const main = async() => {
    Tabennomics = await ethers.getContractFactory("TabennomicsNFT");
    tabennomics = await Tabennomics.deploy();
    await tabennomics.deployed();

    console.log(`Contract deployd to: ${tabennomics.address}`);
}

const deploy = async () =>{
    try{
        await main();
        process.exit(0);
    } catch(err){
        console.log(err);
        process.exit(1);
    }
};

deploy();
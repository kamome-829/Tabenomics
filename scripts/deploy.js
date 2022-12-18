const fs = require("fs");

const main = async() => {
    Tabenomics = await ethers.getContractFactory("Tabenomics");
    tabenomics = await Tabenomics.deploy();
    await tabenomics.deployed();
    console.log(`Contract deployd to: ${tabenomics.address}`);


    //コントラクトアドレスの書き出し
    fs.writeFileSync("./TabenomicsContract.js",
    `
    module.exports = "${tabenomics.address}"
    `
    );
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

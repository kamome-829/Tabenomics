import { ethers } from 'ethers';
import { createContext, useState, useEffect } from 'react'
import { contractABI, contractAddress } from '../contracts/connect'
import  TabenomicsABI  from '../contracts/Tabenomics.json'

export const TransactionContext = createContext();

let PublicSale = 500000000000000;
let pureSale = 30000000000000000;
let accounts;
let mintcount;
const { ethereum } = window;
const ADDRESS = '0x82ABD900Bc7A882f965bc61aC3e3502502e9E9E6';

var Price = PublicSale;

//スマートコントラクトの取得
const getSmartContract = () =>{
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    const transactonContract = new ethers.Contract(
        contractAddress,
        TabenomicsABI.abi,
        signer
    );

    console.log(provider, signer, transactonContract);

    return transactonContract;
};

export const TransactionProvider = ({children}) =>{

    const [account, setAccount] = useState('')
    const [chainId, setChainId] = useState(false)
    const [Quantity, setQuantity] = useState(0);
    const ChainId = '0x5';

    const checkMetaMaskInstalled = async () => {
        if (!ethereum) {
          alert('MetaMaskをインストールしてください！');
        }
    }
    
    const checkChainId = async () => {
        if (ethereum) {
          const chain = await ethereum.request({
            method: 'eth_chainId'
          });
          console.log(`chain: ${chain}`);
          if (chain !== ChainId) {
            try {
              await ethereum.request({
                  method: 'wallet_switchEthereumChain',
                  params: [{
                      chainId: '0x5'
                  }],
              });
          } catch (err) {
              // This error code indicates that the chain has not been added to MetaMask.
              console.log(err)
          }
            setChainId(false)
            return
          } else {
            console.log("Already connected to ethereum mainnet...");
            setChainId(true)
          }
        }
    }
    
    const connectWallet = async () => {
        try {
          accounts = await ethereum.request({
            method: 'eth_requestAccounts'
        });
        checkMetaMaskInstalled();
        console.log(`account: ${accounts[0]}`);
        setAccount(accounts[0]);
        getSmartContract();
        checkChainId();
        } catch (err) {
          console.log(err)
        }
    };

    const DecisionValue = async (getquantity) =>{
      let value = "0"
      if (getquantity == 1){
        value = "0.05"
      }else if(getquantity == 2){
        value = "0.1"
      }else if(getquantity == 3){
        value = "0.15"
      }
      return value;
    }

    const Usermint = async(getquantity) => {
      const transactonContract =  getSmartContract();
      const saleprice = await transactonContract.viewsale();
      let ethvalue
      if (getquantity == 1){
        ethvalue = "0.05"
        if(saleprice == true){
          ethvalue = "0.03"
        }
      }else if(getquantity == 2){
        ethvalue = "0.1"
        if(saleprice == true){
          ethvalue = "0.06"
        }
      }else if(getquantity == 3){
        ethvalue = "0.15"
        if(saleprice == true){
          ethvalue = "0.09"
        }
      }

      try {
        const transactionHash = await transactonContract.mintUser(getquantity, {value: ethers.utils.parseUnits(ethvalue)});
        console.log(`ロード中・・・${transactionHash.hash}`);
        await transactionHash.wait ();
        console.log(`トランザクションに成功${transactionHash.hash}`);
      } catch( e ) {
        alert(e.reason);
      }
      /*const txHash = await ethereum.request({
        method: 'eth_sendTransaction',
        params: [{
            gas: '0x6208',
            from: accounts[0],
            to: ADDRESS,
            value: priceToWei.toString(16)
        }, ],
      })*/
    }

    const getamount =  (getquantity) =>{
      setQuantity(getquantity);
      console.log(Quantity);
    }

    useEffect(() => {
      connectWallet();
    }, []);

    return(
        <TransactionContext.Provider value={{connectWallet, getamount, Quantity, Usermint}}>{children}</TransactionContext.Provider>
    )
};
import Web3 from "web3";
import VoteJSON from '../contract/Vote.json';
const useWeb3 = () =>{
    //进入区块链
    const web3 = new Web3(
        Web3.givenProvider || 
        "wss://goerli.infura.io/ws/v3/0ee78a193e3b4ca1b73f618da27b3cc0"
    );
    //应用自己的solidity文件，前提是这个已经被部署过。
    const contractAddress = "0x5D59B0e82fee199d3a7985EC3ce3ce898F6B9aAE"
    const voteContract = new web3.eth.Contract(VoteJSON.abi,contractAddress);

    const getAccount =async() =>{
        //获取格尔利区块链下，所有的账号返回，这里我们拿第一个
        const accounts = await web3.eth.requestAccounts();
        return accounts[0];

    }

    return {
        web3,
        voteContract,
        contractAddress,
        getAccount,
    };

};
export default useWeb3;
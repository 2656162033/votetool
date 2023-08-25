<script setup>
import {ref,onMounted} from 'vue';
//创建hooks文件夹，就是为了初始化统一
import useWeb3 from "../hooks/useWeb3";

const { web3,voteContract,getAccount} = useWeb3();
//主持人地址
const host = ref("");
const getHost = async () => {
    // voteContract是useweb3里面的设置的，然后通过方法methods去调用host的值，call就是调用
    //其中我们没有在sol文件里面设置host函数，因为智能合约里面public的话，就自动生成构造函数了
    host.value = await voteContract.methods.host().call();
}

//投票人地址
const voterAddress = ref("");
//分发票权功能展示
const mandate = async() =>{
  //这个函数是为了给voterAddress赋值，其中eval是为了把字符串变成数组
  const arr = eval(voterAddress.value);
  const account = await getAccount();
  //调用后端函数分发票
  //这里加send是为了让这个请求方法进入区块链网络，与以太坊进行交互
  voteContract.methods.mandate(arr).send({from:account}).on('receipt',()=>{
    console.log('选票分发成功');
  });
}
onMounted(async() =>{
    await getHost();
});
/*
主持人： 0x12713Cf1e9BE3b9454134190F9611bE5Fc56EF32
投票人1：0x8b980F1B87502f4eE58bBfC5AB80094934527A6C
投票人2：0x5aDBb2Ec26DAB1F67A25dE99Ea761b87752868FB
投票人3：0x6bD4574aE326c773db119048caDd64cc71e0892D
集合：["0x8b980F1B87502f4eE58bBfC5AB80094934527A6C","0x5aDBb2Ec26DAB1F67A25dE99Ea761b87752868FB","0x6bD4574aE326c773db119048caDd64cc71e0892D"]
*/
</script>


<template>
   <div class="box1">
    <van-divider>分发票权</van-divider>
    <div class="host">
      <van-space>
        <p class="label"><van-icon name="manager" />主持人地址</p>
        <p class="address">{{ host }}</p>
      </van-space>
    </div>
    <div>
      <van-space>
        <p class="label"><van-icon name="friends-o" />投票人地址</p>
        <textarea class="votors" v-model="voterAddress"></textarea>
      </van-space>
    </div>
    <div class="btn">
      <van-button block @click="mandate">开始分发选票</van-button>
    </div>
  </div>
  
</template>


<style lang="scss">

</style>
<script setup>
import { ref } from 'vue'
const active = ref(0);
</script>

<template>
  <div>
    <nav class="header">去中心化投票系统</nav>
    <main>
      <router-view></router-view>
    </main>
    <van-tabbar route v-model="active" active-color="rgb(237, 62, 237)">
    <van-tabbar-item to="/" icon="fire-o">分发票权</van-tabbar-item>
    <van-tabbar-item to="/account" icon="contact">账户信息</van-tabbar-item>
    <van-tabbar-item to="/board" icon="comment-o">投票看板</van-tabbar-item>
  </van-tabbar>


  </div>
  
</template>

<style lang="less">
.header{
  height: 44px;
  background-color: rgb(237, 62, 237);
  color: white;
  text-align: center;
  line-height: 44px;
  font-size: large;
}
</style>
//为了样式靠边，填充整个页面不留白边
<style lang="less">
html,
body {
  margin: 0;
  padding: 0;
  //让其不会乱滚动页面
  overflow: hidden;
}
</style>
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Vote {
    //构建投票人的结构体
    struct Voter {
        uint256 amount;//票数
        bool isVoted;//是否投过票了
        address delegator;// 代理人地址（其实就是自己不投了，把投票权给了别人）
        uint256 targetId;//目标的ID（投票给了谁）
    }


    //投票看板结构体
    struct Board {
        string name;//目标名字
        uint256 totalAmount;//票数    
    }
    
    //主持人信息
    address public host;

    //创建投票人映射
    mapping(address => Voter) public voters;
    /*
        {
            投票人地址：{
                投的票数
                是否投了
                如果不投的话把权力给了谁
                投给了谁
            }
        }
    */

    //构造主题的数组
    Board[] public board;
    /*
        {
            名字
            票数
        }
        {
            名字
            票数
        }
    */
    //数据初始化
    constructor(string [] memory nameList){
        host = msg.sender;

        //给主持人初始化一票
        voters[host].amount=1;

        //初始化board
        //如下为namelistdeploy格式
        //["熊王"，"熊大"，"熊二"]
        //["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"，"0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"，"0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
        for (uint256 i =0; i < nameList.length; i++){
            //从第一个开始，把一个Board结构体命名为boarditem赋值
            Board memory boardItem = Board(nameList[i],0);
            // 在把他放进board数组，以此类推
            board.push(boardItem);
        }

    }
    //返回看板集合
    function getBoardInfo() public view returns(Board[] memory){
        return board;
    }
    
    //给某些地址赋予选票
    function mandate(address[] calldata addressList) public {
        // 只有主持人可以调用该方法
        require(msg.sender == host,unicode"只有主持人才有这个权力");
        for(uint256 i=0; i<addressList.length; i++) {
            //如果该地址已经投过票了，就不做处理了
            if (!voters[addressList[i]].isVoted){
                voters[addressList[i]].amount =1;
            }

        }
 
    }
    //委托投票逻辑
    function delegate(address to) public  {
        //获取委托人的地址(谁调用这个函数，谁就是委托人）
        Voter storage sender = voters[msg.sender];
        //如果委托人已经投过票了，就没有资格委托了
        require(!sender.isVoted,unicode"你已经投过票了，没有资格给你委托了");
        //试图委托给自己就是犯大罪！！！
        //A-->A
        require(msg.sender != to,unicode"不能委托给自己");
        //避免循环授权
        //原理是如果被转的人结构体代理人那一栏里面代理人地址是空，就代表还没有代理，就可以进入循环继续检查
        //A-->B-->C-->A这就是循环了
        while (voters[to].delegator != address(0)){
           //这里是判断是不是通过一个链式又循环到自己，这也算是投票给自己
            to = voters[to].delegator;
            //如果代理人地址等于最强前面的发送地址也就是A的地址，那么就报错
            require(to == msg.sender,unicode"不能授权，因为委托一圈后票会回到自己手中");
        }

        //都没问题的情况下就开始授权
        sender.isVoted = true;
        sender.delegator = to;

        //代理人数据的修改
        Voter storage delegator_ = voters[to];
        if (delegator_.isVoted) {
            //追票
            //之前自己的票投了谁，那么就让别人让给我的票也投谁
            board[delegator_.targetId].totalAmount += sender.amount;

        }else{
            delegator_.amount += sender.amount;
        }


    }


    //投票
    function vote(uint256 targetId) public {
        //投票肯定要有投票者和被投票者
        //这里我犯了一个错误！！！！！习惯性用了memory，导致修改只能存在于这个函数里面，其他地方的函数没收到影响所以导致的错误如下
        //一个票一直投，永无休止。
        Voter storage sender = voters[msg.sender];
        //如果没票了，就不给你投票了
        require(sender.amount !=0,unicode"兄弟你都没有票，你投个锤子！！！");
        require(!sender.isVoted,unicode"兄弟你已经投过了啊！！");
        //改为已经投票
        sender.isVoted = true;
        //上面传入了谁我就投票给谁
        sender.targetId = targetId;
        //看板上把这个被投的人的票数加上
        board[targetId].totalAmount += sender.amount;
        emit voteSuccess(unicode"投票成功！！");


    }
    //投票成功事件（用事件是为了暴露告诉外界信息，前端接收）
    event voteSuccess(string);


}
//要先部署到线上

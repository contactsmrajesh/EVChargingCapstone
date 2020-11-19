// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;
contract EVWallet{
    
    struct payment{
        uint amt;
        uint timestamp;
    }
    
    struct balance{
        string customerName;
        address custAccount;
        uint totalBalance;
        uint noOfPay;
        mapping(uint => payment) payments;
    }
    
    mapping(address => balance) balance_record;
    
    function createWallet(string memory _custName,uint _walletAmt) payable public{
        balance_record[msg.sender].totalBalance +=  _walletAmt;
        balance_record[msg.sender].customerName = _custName;
        balance_record[msg.sender].custAccount = msg.sender;
        balance_record[msg.sender].noOfPay += 1;
        payment memory pay = payment(msg.value,now);
        balance_record[msg.sender].payments[balance_record[msg.sender].noOfPay] = pay;
    }
    
     function topUpWallet(uint _walletAmount) payable public{
        balance_record[msg.sender].totalBalance +=  _walletAmount;
        balance_record[msg.sender].noOfPay += 1;
        payment memory pay = payment(msg.value,now);
        balance_record[msg.sender].payments[balance_record[msg.sender].noOfPay] = pay;
    }
    
    function queryWallet() view public returns(uint) {
        return balance_record[msg.sender].totalBalance;
    }
    
    
    function getCustomer() view public returns(string memory) {
        //name1 = balance_record[msg.sender].customerName;
        return balance_record[msg.sender].customerName;
    }
    
    function getCustomerAccount() view public returns(address) {
        //name1 = balance_record[msg.sender].customerName;
        return balance_record[msg.sender].custAccount;
    }

    function logTransaction(address to_a,uint _value) public returns(bool){
        balance_record[msg.sender].totalBalance = balance_record[msg.sender].totalBalance - _value;
        balance_record[to_a].totalBalance = balance_record[to_a].totalBalance + _value;
        return true;
    }
        
}
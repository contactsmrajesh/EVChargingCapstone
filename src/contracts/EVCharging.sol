pragma solidity ^0.5.0;

contract EVCharging{
	string public name;
	uint public evCustCount = 0;
	mapping(uint => EVCustomer) public evCustomers;

	struct EVCustomer {
		uint custID;
		uint walletAmount;
		string custName;	
		address owner;
	}

	event WalletCreated(
		uint custID,
		uint walletAmount,
		string custName,	
		address owner	
	);

	event WalletUpdated(
		uint custID,
		uint walletAmount,
		string custName,	
		address owner	
	);

	constructor() public {
		name = "EVCharging Application";
	}

	function createWallet(string memory _custName, uint _walletAmount) public {
		//Validate parameters start
		require (bytes(_custName).length > 0 );
		require(_walletAmount > 0);
		//Validate parameters ends		
		evCustCount ++;
		evCustomers[evCustCount] = EVCustomer(evCustCount, _walletAmount, _custName, msg.sender);
		//Events are used for logging data
		emit WalletCreated(evCustCount, _walletAmount, _custName, msg.sender);
	}

	function topUpWallet(uint _custID) public payable{
		//Validate the amount and custID
		require(_custID > 0);
		//Fetch the customer details. Instantiating new EVCustomer and creating a copy in memory for the ID.
		EVCustomer memory _evCustomer = evCustomers[_custID];
		//Update the wallet amount to the new amount
		//_evCustomer.walletAmount = _evCustomer.walletAmount + _newAmount;
		//Update the blockchain value with the new amount
		_evCustomer.walletAmount += msg.value;
		evCustomers[_custID] = _evCustomer;
		emit WalletUpdated(evCustCount, _evCustomer.walletAmount, _evCustomer.custName, msg.sender);
	} 

	function queryWallet(uint _custID) public view returns(uint) {
    	EVCustomer memory _evCustomer = evCustomers[_custID];		
    	return _evCustomer.walletAmount;
	}

}

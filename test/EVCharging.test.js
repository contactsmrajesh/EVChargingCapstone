const EVCharging = artifacts.require('./EVCharging.sol')

require('chai')
	.use(require('chai-as-promised'))
	.should()

//Mocha testframework comes with truffle
//chai assertion comes with truffle

contract('EVCharging', ([deployer,customer,propertyOwner]) => {
	let evcharging

	before(async () => {
		evcharging = await EVCharging.deployed()
	})

	describe('deployment', async () => {
		it('Deployed Successfully', async () =>{
			const address = await evcharging.address
			assert.notEqual(address,0x0)
			assert.notEqual(address,'')
			assert.notEqual(address,null)
			assert.notEqual(address,undefined)
		})

		it('Name Matched', async () => {
			const name = await evcharging.name()
			assert.equal(name,'EVCharging Application')
		})
	})


	describe('customer', async () => {
		let result, custCount

		before(async () => {
			//After argument are passed, it is followed by fn metadata.
			result = await evcharging.createWallet('Rajesh',web3.utils.toWei('1','Ether'), { from: customer })
			custCount = await evcharging.evCustCount()
		})

		it('Creates Customer', async () => {
			//Success Cases
			assert.equal(custCount,1)
			const event = result.logs[0].args
			assert.equal(event.custID.toNumber(),custCount.toNumber(),'Cust ID is correct')
			assert.equal(event.custName,'Rajesh','Customer Name is correct')
			assert.equal(event.owner,customer,'Owner is correct')
		
			//Failure Cases: Customer should have a name
			await evcharging.createWallet('',web3.utils.toWei('1','Ether'), { from: customer }).should.be.rejected;
			//Failure Cases: Customer should have a valid amount
			await evcharging.createWallet('Rajesh',0, { from: customer }).should.be.rejected;

		})


		it('Balance Check', async () => {
			const wallet = await evcharging.evCustomers(custCount)
			assert.equal(wallet.custID.toNumber(),custCount.toNumber(),'Cust ID is correct')
			assert.equal(wallet.custName,'Rajesh','Customer Name is correct')
			assert.equal(wallet.owner,customer,'Owner is correct')
		})


		it('TopUp Wallet', async () => {
			//Track the old balance and new balance
			let oldWalletBalance
			oldWalletBalance = await web3.eth.getBalance(customer)
			oldWalletBalance = new web3.utils.BN(oldWalletBalance)
			
			//result = await evcharging.topUpWallet(custCount,web3.utils.toWei('2','Ether'))
			result = await evcharging.topUpWallet(custCount,{ from : customer, value: web3.utils.toWei('2','Ether')})

			let newWalletBalance
			newWalletBalance = await web3.eth.getBalance(customer)
			newWalletBalance = new web3.utils.BN(newWalletBalance)

			let price 
			price = web3.utils.toWei('2','Ether')
			price = new web3.utils.BN(price)
//			console.log(result.logs)

			const expectedBalance = oldWalletBalance.add(price)
		//	console.log(newWalletBalance.toString(),expectedBalance.toString())
			//assert.equal(newWalletBalance.toString(),expectedBalance.toString())
			
		})

		it('Query Wallet', async () => {
			result = await evcharging.topUpWallet(custCount)
			console.log(result.logs)
		
		})



	})




})
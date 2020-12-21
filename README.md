The contract implements the below key API's.
Smart Contract Name: EVWallet.sol

(i) createWallet API: This function is used to create a wallet for the user and initialize the wallet amount. This API is invoked by passing the customer name and wallet amount. The function configures the data in the struct defined to capture the customer name, amount, balance, and timestamp.

(ii) topUpWallet API: This function is used by the customer to add a top-up amount to the wallet. Based on the account being invoked, the top-up amount gets added and the account balance will reflect the modified amount.

(iii) queryWallet API: This function will return the balance of the wallet for the account from which it is invoked.

(iv) logTransaction API: This function is used to transfer the amount from the customer to the property owner. The function will debit the initiator account wallet and then credit the account to which the amount is transferred. To execute the function, need to pass the address to which ether needs to be transferred and the amount. 


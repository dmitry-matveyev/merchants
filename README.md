<h1>Task description:</h1>

Merchants have many payment transactions of different types.

Transaction Types
* Authorize transaction - has amount and used to hold customer's amount
* Charge transaction - has amount and used to confirm the amount is taken from the customer's account and transferred to the merchant
** The merchant's total transactions amount has to be the sum of the approved Charge transactions
* Refund transaction - has amount and used to reverse a specific amount (whole amount) of the Charge Transaction and return it to the customer
** Transitions the Charge transaction to status refunded
** The approved Refund transactions will decrease the merchant's total transaction amount
* Reversal transaction - has no amount, used to invalidate the Authorize Transaction
** Transitions the Authorize transaction to status reversed

Goal is to propose an API to create transactions.

<h1>Solution</h1>

API:

`api/v1/transactions` => `transations#create`

PARAMS:

* :amount
* :type # one of (authorized charged refunded)
* :transaction_id # for charged and refunded transaction types 

<h1>How to run:</h1>

* run app: `docker-compose up app`
* run tests: `docker-compose run test rspec`
* run rails console: `docker-compose run app rails c`


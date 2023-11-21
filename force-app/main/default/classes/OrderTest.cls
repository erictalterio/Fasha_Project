@isTest
// Verifies the creation of Order. Ensures data integrity and correct
// functioning of data creation methods in TestDataFactory. 
private class OrderTest {
    @isTest static void testOrderCreation() {
        // Creating accounts and associated orders
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Query to verify the orders are created and associated correctly
        List<Order> orders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];

        // Assertions to verify the correct number of orders are created and associated
        System.assertEquals(201, orders.size(), 'There should be 201 orders created.');

        // Create a set of Account IDs for easier comparison
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        // Check each Order's AccountId is in the set of test Account IDs
        for (Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'Order Id should not be null after insertion.');
            System.assert(accountIds.contains(ord.AccountId), 'Order should be associated with one of the test accounts.');
        }
    }
}

@isTest
// This test class is designed to verify the creation and correct association of Order records
// with Account records in Salesforce. It ensures that the data creation methods in the
// TestDataFactory are functioning as expected, maintaining data integrity.
private class OrderTest {
    @isTest static void testOrderCreation() {
        // Arrange: Create a significant number of Accounts and their associated Orders.
        // This step uses TestDataFactory to generate realistic test data. Creating 201 accounts
        // tests the data creation methods in bulk scenarios, ensuring they work correctly
        // under load and can handle realistic volumes of data.
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Act: Query to verify that the Orders are created and correctly associated with Accounts.
        // This query retrieves Orders linked to the test Accounts, checking both the creation
        // of Orders and their correct association with Account records.
        List<Order> orders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];

        // Assert: Verify the correct number and association of Orders.
        // The assertion checks the number of Orders created against the expected count,
        // confirming the correct operation of the data creation methods.
        System.assertEquals(201, orders.size(), 'There should be 201 orders created.');

        // Create a Set of Account IDs for efficient comparison.
        // This Set facilitates checking that each Order is associated with one of the test Accounts,
        // providing a quick and efficient way to verify correct associations.
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        // Check each Order's AccountId against the Set of test Account IDs.
        // These assertions ensure that every Order is linked to a valid Account and that
        // the Orders are correctly associated with the Accounts created in the test setup.
        for (Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'Order Id should not be null after insertion.');
            System.assert(accountIds.contains(ord.AccountId), 'Order should be associated with one of the test accounts.');
        }
    }
}

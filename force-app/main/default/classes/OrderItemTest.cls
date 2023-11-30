@isTest
private class OrderItemTest {
    /**
     * This test class is focused on validating the correct creation of OrderItem records 
     * associated with Orders in Salesforce. The test ensures that for each Order, an OrderItem 
     * record is appropriately created and linked, an essential aspect of order management systems.
     */

    @isTest static void testOrderItemCreation() {
        // Arrange: Create a number of Accounts and associated Orders with OrderItems.
        // The use of TestDataFactory facilitates the generation of consistent and isolated test data,
        // ensuring the test environment accurately represents real-world usage scenarios.
        // Creating 201 accounts with associated Orders tests the functionality with a significant data volume.
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Retrieve the Orders created for these Accounts.
        // This query fetches Orders related to the test Accounts, preparing them for subsequent validation.
        List<Order> orders = [SELECT Id FROM Order WHERE AccountId IN :accounts];

        // Query for OrderItems associated with the retrieved Orders.
        // This step is crucial to verify that OrderItems are correctly linked to their respective Orders.
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId IN :orders];

        // Assertions to verify the correct number of OrderItems are created and associated with Orders.
        // The expectation is that there should be one OrderItem per Order, validating both creation and association.
        System.assertEquals(orders.size(), orderItems.size(), 'There should be one OrderItem per Order.');

        // Additional assertion to ensure every OrderItem has a valid Id.
        // This check confirms that each OrderItem has been successfully inserted into the database.
        for (OrderItem oi : orderItems) {
            System.assertNotEquals(null, oi.Id, 'OrderItem Id should not be null after insertion.');
        }
    }
}

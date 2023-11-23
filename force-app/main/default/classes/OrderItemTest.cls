@isTest
private class OrderItemTest {
    @isTest static void testOrderItemCreation() {
        // Creating accounts and associated orders with 1 OrderItem each
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Retrieve the created orders for these accounts
        List<Order> orders = [SELECT Id FROM Order WHERE AccountId IN :accounts];

        // Query for OrderItems associated with the orders
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId IN :orders];

        // Assertions to verify the correct number of order items are created and inserted
        // Expecting one OrderItem per Order
        System.assertEquals(orders.size(), orderItems.size(), 'There should be one OrderItem per Order.');

        for (OrderItem oi : orderItems) {
            System.assertNotEquals(null, oi.Id, 'OrderItem Id should not be null after insertion.');
        }
    }
}

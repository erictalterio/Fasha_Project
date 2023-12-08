@isTest
private class DataFactoryTest {
    /**
     * Test for validating the correct creation of OrderItem records associated with Orders.
     */
    @isTest static void testOrderItemCreation() {
        // Arrange
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);
        List<Order> orders = [SELECT Id FROM Order WHERE AccountId IN :accounts];
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId IN :orders];

        // Assert
        System.assertEquals(orders.size(), orderItems.size(), 'There should be one OrderItem per Order.');
        for (OrderItem oi : orderItems) {
            System.assertNotEquals(null, oi.Id, 'OrderItem Id should not be null after insertion.');
        }
    }

    /**
     * Test for verifying the creation and correct association of Order records with Account records.
     */
    @isTest static void testOrderCreation() {
        // Arrange
        List<Account> accounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);
        List<Order> orders = [SELECT Id, AccountId FROM Order WHERE AccountId IN :accounts];

        // Assert
        System.assertEquals(201, orders.size(), 'There should be 201 orders created.');
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        for (Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'Order Id should not be null after insertion.');
            System.assert(accountIds.contains(ord.AccountId), 'Order should be associated with one of the test accounts.');
        }
    }

    /**
     * Test for verifying the correct creation of PricebookEntry records.
     */
    @isTest static void testPricebookEntryCreation() {
        // Arrange
        List<Product2> products = TestDataFactory.createProducts(201, true);
        List<PricebookEntry> pbEntries = TestDataFactory.createPricebookEntries(products, true);

        // Assert
        System.assertEquals(201, pbEntries.size(), 'There should be 201 pricebook entries created.');
        for (PricebookEntry pbe : pbEntries) {
            System.assertNotEquals(null, pbe.Id, 'PricebookEntry Id should not be null after insertion.');
        }
    }

    /**
     * Test for verifying the correct creation of Product records.
     */
    @isTest static void testProductCreation() {
        // Arrange
        List<Product2> products = TestDataFactory.createProducts(201, true);

        // Assert
        System.assertEquals(201, products.size(), 'There should be 201 products created.');
        for (Product2 prod : products) {
            System.assertNotEquals(null, prod.Id, 'Product Id should not be null after insertion.');
        }
    }
}

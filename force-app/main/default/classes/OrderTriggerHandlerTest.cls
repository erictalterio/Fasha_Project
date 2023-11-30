@isTest
private class OrderTriggerHandlerTest {

    /**
     * Retrieves the ID of the standard Pricebook from Salesforce.
     * This utility method is essential for tests that require operations on Pricebooks,
     * as the standard Pricebook ID is often needed to create related records like Orders and PricebookEntries.
     */
    private static Id getStandardPricebookId() {
        return Test.getStandardPricebookId();
    }

    /**
     * Creates a standard PricebookEntry or retrieves an existing one.
     * This method facilitates creating PricebookEntries for test products, which are necessary
     * for creating OrderItems. It ensures that each test has the necessary setup for Order processing.
     */
    private static Id getStandardPricebookEntryId() {
        Id standardPbId = getStandardPricebookId();

        // Create a test Product to be used in the PricebookEntry.
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Associate the test Product with the standard Pricebook.
        PricebookEntry standardPBE = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPBE;

        return standardPBE.Id;
    }

    /**
     * Tests the functionality of calculating the net amount on Orders.
     * This test simulates the scenario where an Order's net amount is calculated
     * and verified after updating the Order's status and associated costs.
     */
    @isTest static void testCalculateNetAmount() {
        // Setup test data: Create an Account and an associated Order with an OrderItem.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = getStandardPricebookId()
        );
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = getStandardPricebookEntryId(),
            Quantity = 1,
            UnitPrice = 1000
        );
        insert testOrderItem;

        // Update the Order to trigger the net amount calculation logic in the trigger.
        testOrder.Status = 'Ordered';
        testOrder.ShipmentCost__c = 100; // Assuming ShipmentCost__c is a custom field.
        update testOrder;

        // Verify that the net amount is correctly calculated by the trigger logic.
        testOrder = [SELECT NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(900, testOrder.NetAmount__c, 'Net amount should be correctly calculated.');
    }

    /**
     * Tests the functionality of updating the Chiffre_d_affaire__c field on Accounts.
     * This test checks if the trigger correctly updates the Chiffre_d_affaire__c field on Accounts
     * based on the related Orders after an Order is updated.
     */
    @isTest static void testUpdateAccountChiffreDAffaire() {
        // Setup test data: Create an Account and an associated Order with an OrderItem.
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = getStandardPricebookId()
        );
        insert testOrder;

        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = getStandardPricebookEntryId(),
            Quantity = 1,
            UnitPrice = 1000
        );
        insert testOrderItem;

        // Update the Order to trigger the Chiffre_d_affaire__c update logic in the trigger.
        testOrder.Status = 'Ordered';
        update testOrder;

        // Invoke the trigger handler with a custom TriggerContext to simulate the trigger execution.
        List<Order> orders = new List<Order>{ testOrder };
        TriggerContext context = new TriggerContext(orders, false, true, true);
        OrderTriggerHandler.handleTrigger(context);

        // Verify that the Chiffre_d_affaire__c field on the Account is correctly updated by the trigger logic.
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(1000, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be correctly updated.');
    }
}

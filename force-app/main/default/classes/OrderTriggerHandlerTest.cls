@isTest
private class OrderTriggerHandlerTest {

    /**
     * Retrieves the ID of the standard Pricebook from Salesforce.
     */
    private static Id getStandardPricebookId() {
        return Test.getStandardPricebookId();
    }

    /**
     * Creates a standard PricebookEntry or retrieves an existing one.
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
     */
    @isTest static void testCalculateNetAmount() {
        // Setup test data
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

        // Start test execution context
        Test.startTest();

        // Update the Order to trigger the net amount calculation logic in the trigger.
        testOrder.Status = 'Ordered';
        testOrder.ShipmentCost__c = 100;
        update testOrder;

        // Stop test execution context
        Test.stopTest();

        // Verify the net amount calculation
        testOrder = [SELECT NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(900, testOrder.NetAmount__c, 'Net amount should be correctly calculated.');
    }

    /**
     * Tests the functionality of updating the Chiffre_d_affaire__c field on Accounts.
     */
    @isTest static void testUpdateAccountChiffreDAffaire() {
        // Setup test data
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

        // Start test execution context
        Test.startTest();

        // Update the Order to trigger the Chiffre_d_affaire__c update logic in the trigger.
        testOrder.Status = 'Ordered';
        update testOrder;

        // Stop test execution context
        Test.stopTest();

        // Verify the Chiffre_d_affaire__c field update
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(1000, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be correctly updated.');
    }
}

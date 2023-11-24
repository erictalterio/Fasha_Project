@isTest(SeeAllData=true)
private class OrderTriggerHandlerTest {

    // Ensure the standard Pricebook is active and return its ID
    private static Id ensureStandardPricebookIsActive() {
        // Query for the standard Pricebook
        Pricebook2 standardPb = [SELECT Id, IsActive FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        if (!standardPb.IsActive) {
            // Activate the standard Pricebook if it's not active
            standardPb.IsActive = true;
            update standardPb;
        }

        return standardPb.Id;
    }

    // Retrieve a standard PricebookEntry ID
    private static Id getStandardPricebookEntryId() {
        Id standardPbId = ensureStandardPricebookIsActive();

        // Query for an active standard PricebookEntry
        List<PricebookEntry> standardPBEs = [
            SELECT Id FROM PricebookEntry
            WHERE Pricebook2Id = :standardPbId
            AND IsActive = true
            LIMIT 1
        ];
        
        if (!standardPBEs.isEmpty()) {
            return standardPBEs[0].Id;
        }
        
        // No active standard PricebookEntry found, create one
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;
        
        PricebookEntry standardPBE = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPBE;

        return standardPBE.Id;
    }

    // Test method for calculating net amount on orders
    @isTest static void testCalculateNetAmount() {
        // Setup test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testOrder;

        // Create OrderItem for the Order
        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = TestDataFactory.getStandardPricebookEntryId(),
            Quantity = 1,
            UnitPrice = 1000
        );
        insert testOrderItem;

        // Update Order to trigger the calculation
        testOrder.Status = 'Ordered';
        testOrder.ShipmentCost__c = 100; // Assuming ShipmentCost__c is a custom field on Order
        update testOrder;

        // Verify the NetAmount__c calculation
        testOrder = [SELECT NetAmount__c FROM Order WHERE Id = :testOrder.Id];
        System.assertEquals(900, testOrder.NetAmount__c, 'Net amount should be correctly calculated.');
    }

    // Test method for updating Account's Chiffre_d_affaire__c
    @isTest static void testUpdateAccountChiffreDAffaire() {
        Id standardPbId = ensureStandardPricebookIsActive();
        Id standardPbeId = getStandardPricebookEntryId();

        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = standardPbId
        );
        insert testOrder;
        OrderItem testOrderItem = new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = standardPbeId,
            Quantity = 1,
            UnitPrice = 1000
        );
        insert testOrderItem;

        // Update order to Ordered status
        testOrder.Status = 'Ordered';
        update testOrder;

        // Create TriggerContext and invoke handler
        List<Order> orders = new List<Order>{ testOrder };
        TriggerContext context = new TriggerContext(orders, false, true, true);
        OrderTriggerHandler.handleTrigger(context);

        // Assertions
        Account updatedAccount = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(1000, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be correctly updated.');
    }
}

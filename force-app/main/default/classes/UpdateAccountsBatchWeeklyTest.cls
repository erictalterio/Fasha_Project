@isTest
private class UpdateAccountsBatchWeeklyTest {

    // Mock implementation of SchedulableContext
    private class MockSchedulableContext implements SchedulableContext {
        public Id getTriggerId() {
            // Return a dummy Id or null as needed for your test
            return null;
        }
    }

    @isTest static void testBatchProcessingAndScheduling() {
        // Ensure standard Pricebook is available
        Id standardPbId = Test.getStandardPricebookId();

        // Create a test product
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Create a PricebookEntry for the test product in the standard Pricebook
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPbe;

        // Create test Accounts and associated Orders using TestDataFactory
        // Reduced number of records to 10 to match batch size
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(10, 1000.0);

        Test.startTest();

        // Test the execute method
        UpdateAccountsBatchWeekly batchWeekly = new UpdateAccountsBatchWeekly();
        MockSchedulableContext mockContext = new MockSchedulableContext();
        batchWeekly.execute(mockContext); // Directly calling the execute method

        // Test the scheduleWeekly method
        UpdateAccountsBatchWeekly.scheduleWeekly(); // Even though actual scheduling won't occur, this ensures the method is covered

        Test.stopTest();

        // Query the updated Accounts to verify the changes
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(10, updatedAccounts.size());
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should not be null.');
            System.assertEquals(1000.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be correctly calculated.');
        }
    }
}

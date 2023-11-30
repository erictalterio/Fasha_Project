@isTest
private class UpdateAccountsBatchWeeklyTest {

    // Mock implementation of SchedulableContext for testing purposes.
    // This mock class provides a substitute for the SchedulableContext, which is used in the execute method of the batch class.
    private class MockSchedulableContext implements SchedulableContext {
        public Id getTriggerId() {
            // Return a dummy Id or null. In real scenarios, this would be the ID of the Trigger that initiated the scheduled job.
            return null;
        }
    }

    @isTest static void testBatchProcessingAndScheduling() {
        // Arrange: Set up test data and prerequisites.
        // This setup involves creating a test product, a PricebookEntry, and a set of Accounts with Orders.
        // The Orders will be used to test the revenue calculation functionality of the batch class.

        // Ensure the standard Pricebook is available as it's required for creating Orders.
        Id standardPbId = Test.getStandardPricebookId();

        // Create a test Product.
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Create a PricebookEntry for the test Product in the standard Pricebook.
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPbe;

        // Create test Accounts and associated Orders.
        // The number of records is reduced to 10 to better align with the typical batch size.
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(10, 1000.0);

        Test.startTest();

        // Act: Test the execution of the batch job.
        // This involves directly invoking the execute method of the UpdateAccountsBatchWeekly class.
        UpdateAccountsBatchWeekly batchWeekly = new UpdateAccountsBatchWeekly();
        MockSchedulableContext mockContext = new MockSchedulableContext();
        batchWeekly.execute(mockContext);

        // Test the scheduleWeekly static method.
        // This step verifies that the method for scheduling the batch job is functional.
        // Actual scheduling won't occur in the test context, but this ensures the method is tested.
        UpdateAccountsBatchWeekly.scheduleWeekly();

        Test.stopTest();

        // Assert: Verify the results of the batch execution.
        // This includes querying the updated Accounts to ensure that their Chiffre_d_affaire__c fields
        // have been correctly calculated and updated by the batch job.
        List<Account> updatedAccounts = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];
        System.assertEquals(10, updatedAccounts.size());
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should not be null.');
            System.assertEquals(1000.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be correctly calculated.');
        }
    }
}

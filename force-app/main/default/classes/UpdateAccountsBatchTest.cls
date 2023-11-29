@isTest
private class UpdateAccountsBatchTest {
    @isTest static void testBatchUpdate() {
        // Create test Accounts and Orders using TestDataFactory
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 1000.00);

        // Ensure Orders are set to 'Ordered' status
        List<Order> ordersToUpdate = [SELECT Id FROM Order WHERE AccountId IN :testAccounts];
        for (Order ord : ordersToUpdate) {
            ord.Status = 'Ordered';
        }
        update ordersToUpdate;

        // Run the batch job
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Add assertions as necessary to verify the logic
    }
}

@isTest
private class UpdateAccountsBatchTest {
    /**
     * Test method to verify the functionality of the UpdateAccountsBatch class.
     */
    @isTest static void testBatchUpdate() {
        // Arrange
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 1000.00);

        // Include AccountId in the SOQL query
        List<Order> ordersToUpdate = [SELECT Id, AccountId, TotalAmount FROM Order WHERE AccountId IN :testAccounts];
        for (Order ord : ordersToUpdate) {
            ord.Status = 'Ordered';
        }
        update ordersToUpdate;

        // Act
        Test.startTest();
        UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Assert
        // Re-query the test accounts to get the updated revenue values
        testAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];

        // Calculate the expected revenue for each account based on the orders
        Map<Id, Decimal> expectedRevenue = new Map<Id, Decimal>();
        for (Order ord : ordersToUpdate) {
            if (!expectedRevenue.containsKey(ord.AccountId)) {
                expectedRevenue.put(ord.AccountId, 0);
            }
            expectedRevenue.put(ord.AccountId, expectedRevenue.get(ord.AccountId) + ord.TotalAmount);
        }

        // Verify the revenue for each account
        for (Account acc : testAccounts) {
            System.assertEquals(expectedRevenue.get(acc.Id), acc.Chiffre_d_affaire__c, 'Revenue should be correctly updated for Account Id ' + acc.Id);
        }
    }
}

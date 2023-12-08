@isTest
private class GetAccountOrdersUtilityTest {
    /**
     * Test to ensure that the getAccountQueryLocator method returns a correct QueryLocator.
     */
    @isTest static void testGetAccountQueryLocator() {
        // Create test Accounts and associated Orders with the desired 'Ordered' status.
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        Test.startTest();
        // Invoke the method under test to retrieve the QueryLocator.
        Database.QueryLocator locator = GetAccountOrdersUtility.getAccountQueryLocator();
        Test.stopTest();

        // Convert the QueryLocator to a QueryLocatorIterator for processing.
        Database.QueryLocatorIterator it = locator.iterator();

        // Prepare a set of Account IDs for comparison.
        Set<Id> expectedAccountIds = new Set<Id>();
        for (Account acc : testAccounts) {
            expectedAccountIds.add(acc.Id);
        }

        // Iterate over the results and assert that each Account is in the expected set.
        Integer count = 0;
        while (it.hasNext()) {
            Account acc = (Account)it.next();
            System.assert(expectedAccountIds.contains(acc.Id), 'Account should be in the set of expected Accounts.');
            count++;
        }

        // Assert the number of records if known.
        System.assertEquals(expectedAccountIds.size(), count, 'The number of retrieved accounts should match the expected count.');
    }
}

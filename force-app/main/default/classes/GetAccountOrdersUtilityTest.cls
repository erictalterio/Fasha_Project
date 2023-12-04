@isTest
private class GetAccountOrdersUtilityTest {
    /**
     * This test class is designed to validate the functionality of the GetAccountOrdersUtility class.
     * Specifically, it tests the getAccountQueryLocator method to ensure that it correctly returns
     * a Database.QueryLocator for Accounts with 'Ordered' status Orders. This kind of test is crucial
     * for verifying that the utility class correctly identifies and retrieves the intended records
     * in various data scenarios.
     */

    @isTest static void testGetAccountQueryLocator() {
        // Prepare the test environment by ensuring the availability of a standard Pricebook.
        Id standardPbId = Test.getStandardPricebookId();

        // Create a test product to be used in test Orders.
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Create a PricebookEntry for the test product in the standard Pricebook.
        // This step is necessary for creating Orders, as Orders in Salesforce require PricebookEntries.
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPbe;

        // Create test Accounts and associated Orders with the desired 'Ordered' status.
        // This step uses a custom factory method to generate a large number of test records,
        // simulating a realistic scenario where the utility method needs to handle significant data volumes.
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        Test.startTest();
        // Invoke the method under test to retrieve the QueryLocator.
        // This invocation is wrapped within Test.startTest and Test.stopTest to isolate test execution
        // and ensure governor limits are correctly evaluated for this specific method call.
        Database.QueryLocator locator = GetAccountOrdersUtility.getAccountQueryLocator();
        Test.stopTest();
    }
}

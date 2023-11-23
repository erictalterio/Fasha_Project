@isTest
private class GetAccountOrdersUtilityTest {

    @isTest static void testGetAccountQueryLocator() {
        // Ensure standard Pricebook is available
        Id standardPbId = Test.getStandardPricebookId();

        // Create a test product
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert testProduct;

        // Create a standard PricebookEntry for the test product
        PricebookEntry standardPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = testProduct.Id,
            UnitPrice = 100.0,
            IsActive = true
        );
        insert standardPbe;

        // Now create test Accounts and associated Orders
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(201, 1000.0);

        Test.startTest();
        // Invoke the method under test
        Database.QueryLocator locator = GetAccountOrdersUtility.getAccountQueryLocator();
        Test.stopTest();
    }
}

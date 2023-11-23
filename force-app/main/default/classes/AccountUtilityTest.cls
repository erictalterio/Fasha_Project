@isTest
private class AccountUtilityTest {

    @isTest static void testUpdateChiffreDAffaire() {
        // Create test Accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(2, true);

        // List to store new OrderItems to be inserted
        List<OrderItem> allTestOrderItems = new List<OrderItem>();

        // Create Orders and OrderItems for the test Accounts
        for (Account acc : testAccounts) {
            // Create a draft Order for each Account
            Order testOrder = new Order(
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = Test.getStandardPricebookId() // Assuming this is available in test context
            );
            insert testOrder;

            // Create new OrderItems for the testOrder
            List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(
                new List<Order>{testOrder},
                1000.0 // Unit Price
            );
            allTestOrderItems.addAll(testOrderItems);
        }

        // Insert all new OrderItems at once
        insert allTestOrderItems;

        // Prepare Set of Account IDs for updating Chiffre_d'affaire__c
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }

        Test.startTest();
        // Call method under test
        AccountUtility.updateChiffreDAffaire(accountIds);
        Test.stopTest();

        // Assert that Chiffre_d'affaire__c field is updated correctly
        for (Account acc : [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds]) {
            System.assertEquals(1000.0, acc.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be updated correctly.');
        }
    }
}

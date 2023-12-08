@isTest
private class AccountUtilityTest {
    @isTest static void testUpdateChiffreDAffaireWithOrders() {
        // Arrange: Create test accounts with orders.
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 1000.0);

        // Act: Call the updateChiffreDAffaire method.
        Test.startTest();
        AccountUtility.updateChiffreDAffaire(extractAccountIds(testAccounts));
        Test.stopTest();

        // Assert: Verify that Chiffre_d_affaire__c is correctly updated for each account.
        verifyChiffreDAffaireCalculation(testAccounts, 1000.0);
    }

    @isTest static void testUpdateChiffreDAffaireWithoutOrders() {
        // Arrange: Create test accounts without orders.
        List<Account> testAccounts = TestDataFactory.createAccounts(2, true);

        // Act: Call the updateChiffreDAffaire method.
        Test.startTest();
        AccountUtility.updateChiffreDAffaire(extractAccountIds(testAccounts));
        Test.stopTest();

        // Assert: Verify that Chiffre_d_affaire__c is correctly set to zero for each account.
        verifyChiffreDAffaireCalculation(testAccounts, 0.0);
    }

    private static Set<Id> extractAccountIds(List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        return accountIds;
    }

    private static void verifyChiffreDAffaireCalculation(List<Account> accounts, Decimal expectedChiffreDAffaire) {
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for (Account acc : updatedAccounts) {
            Decimal actualChiffreDAffaire = acc.Chiffre_d_affaire__c != null ? acc.Chiffre_d_affaire__c : 0.0;
            System.assertEquals(expectedChiffreDAffaire, actualChiffreDAffaire, 
                                'Chiffre d\'Affaire should be correctly calculated for Account Id: ' + acc.Id);
        }
    }
}

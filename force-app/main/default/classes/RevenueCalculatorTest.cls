@isTest
public class RevenueCalculatorTest {

    @isTest static void testCalculateRevenue() {
        // Arrange: Create test accounts and associated orders
        // Assume TestDataFactory.createAccountsAndOrders creates Accounts and their corresponding Orders
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 500.0); // Each order has a total amount of 500.0

        // Act: Call the calculateRevenue method
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Refresh the accounts from the database to get updated revenue values
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :testAccounts];

        // Assert: Verify that the revenue is correctly calculated and updated for each account
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Revenue should not be null.');
            System.assertEquals(500.0, acc.Chiffre_d_affaire__c, 'Revenue should be correctly calculated based on associated orders.');
        }
    }
}

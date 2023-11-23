@isTest
public class RevenueCalculatorTest {

    @isTest static void testCalculateRevenueWithSingleOrder() {
        // Arrange: Create test accounts with a single order each
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 500.0);

        // Act: Call the calculateRevenue method
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify revenue calculation for each account
        verifyRevenueCalculation(testAccounts, 500.0);
    }

    @isTest static void testCalculateRevenueWithMultipleOrders() {
        // Arrange: Create test accounts with multiple orders
        List<Account> testAccounts = TestDataFactory.createAccounts(1, true);
        TestDataFactory.createOrders(testAccounts, 2, true, 250.0); // Two orders each of 250.0

        // Act: Call the calculateRevenue method
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify revenue calculation for each account
        verifyRevenueCalculation(testAccounts, 500.0);
    }

    @isTest static void testCalculateRevenueWithNoOrders() {
        // Arrange: Create test accounts with no orders
        List<Account> testAccounts = TestDataFactory.createAccounts(1, true);

        // Act: Call the calculateRevenue method
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify revenue calculation for each account
        verifyRevenueCalculation(testAccounts, 0.0);
    }

    private static void verifyRevenueCalculation(List<Account> accounts, Decimal expectedRevenue) {
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Revenue should not be null.');
            System.assertEquals(expectedRevenue, acc.Chiffre_d_affaire__c, 'Revenue should be correctly calculated.');
        }
    }
}

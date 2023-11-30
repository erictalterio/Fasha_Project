@isTest
public class RevenueCalculatorTest {

    /**
     * Test to verify revenue calculation for accounts with a single order.
     * This test ensures that the RevenueCalculator accurately calculates revenue for accounts
     * when they have exactly one associated order.
     */
    @isTest static void testCalculateRevenueWithSingleOrder() {
        // Arrange: Create test accounts with a single order each.
        // This setup uses TestDataFactory to create a controlled testing environment where
        // each test account has one order with a known total amount, facilitating precise verification.
        List<Account> testAccounts = TestDataFactory.createAccountsAndOrders(2, 500.0);

        // Act: Call the calculateRevenue method.
        // This step invokes the method under test within a test context to measure performance and limits.
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify that the revenue calculation is correct for each account.
        // The verification checks that the revenue for each account is as expected, confirming
        // accurate calculation in scenarios with a single order per account.
        verifyRevenueCalculation(testAccounts, 500.0);
    }

    /**
     * Test to verify revenue calculation for accounts with multiple orders.
     * This test checks that the RevenueCalculator correctly aggregates revenue from multiple orders
     * for a single account.
     */
    @isTest static void testCalculateRevenueWithMultipleOrders() {
        // Arrange: Create test accounts with multiple orders.
        // In this scenario, each test account has multiple orders, testing the method's ability
        // to aggregate order totals correctly.
        List<Account> testAccounts = TestDataFactory.createAccounts(1, true);
        TestDataFactory.createOrders(testAccounts, 2, true, 250.0); // Two orders each of 250.0

        // Act: Call the calculateRevenue method.
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify the aggregated revenue calculation for each account.
        // The assertion confirms that the revenue calculation correctly sums multiple orders per account.
        verifyRevenueCalculation(testAccounts, 500.0);
    }

    /**
     * Test to verify revenue calculation for accounts with no orders.
     * This test validates that the RevenueCalculator correctly handles accounts that have no orders,
     * ensuring that revenue is appropriately set to zero in such cases.
     */
    @isTest static void testCalculateRevenueWithNoOrders() {
        // Arrange: Create test accounts with no orders.
        // This setup tests the RevenueCalculator's handling of accounts without any associated orders.
        List<Account> testAccounts = TestDataFactory.createAccounts(1, true);

        // Act: Call the calculateRevenue method.
        Test.startTest();
        RevenueCalculator.calculateRevenue(testAccounts);
        Test.stopTest();

        // Assert: Verify that the revenue is correctly set to zero for each account.
        // This check is crucial for ensuring that revenue calculations are accurate even in the absence of orders.
        verifyRevenueCalculation(testAccounts, 0.0);
    }

    /**
     * Utility method to verify the revenue calculation for a list of accounts.
     * This method abstracts the verification logic, reducing redundancy across multiple test methods.
     *
     * @param accounts The list of accounts to verify the revenue calculation for.
     * @param expectedRevenue The expected revenue value for validation.
     */
    private static void verifyRevenueCalculation(List<Account> accounts, Decimal expectedRevenue) {
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts];
        for (Account acc : updatedAccounts) {
            System.assertNotEquals(null, acc.Chiffre_d_affaire__c, 'Revenue should not be null.');
            System.assertEquals(expectedRevenue, acc.Chiffre_d_affaire__c, 'Revenue should be correctly calculated.');
        }
    }
}

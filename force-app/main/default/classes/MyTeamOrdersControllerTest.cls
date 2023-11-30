@isTest
private class MyTeamOrdersControllerTest {
    /**
     * This test class is designed to validate the functionality of the MyTeamOrdersController class.
     * It focuses particularly on testing the accurate calculation of aggregate order sums,
     * especially when dealing with bulk data, which is a common real-world scenario in Salesforce applications.
     */

    @isTest static void testSumOrdersWithBulkData() {
        // Arrange: Create a large number of Accounts and associated Orders to test bulk data handling.
        // This setup uses a custom TestDataFactory to simulate a realistic and complex data scenario,
        // ensuring that the controller can accurately process and calculate sums in bulk data contexts.
        // The number 201 is chosen to surpass the typical batch size limit of 200 in Salesforce,
        // thus testing the controller's ability to handle and process data that spans multiple batches.
        TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Act: Instantiate the controller and retrieve the calculated sum of orders.
        // This step tests the controller's constructor and the calculateSumOrders method,
        // ensuring they work as expected right upon object instantiation.
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Decimal sumOfOrders = controller.sumOrders;

        // Assert: Verify that the sum of orders is correctly calculated for a large number of Accounts.
        // The expected sum is based on the known values used in the test data setup, allowing for
        // a straightforward and precise verification of the calculation's accuracy.
        Decimal expectedSum = 201000.0; // 201 Accounts each with an Order of 1000.0
        System.assertEquals(expectedSum, sumOfOrders, 'The sum of orders for 201 accounts should be correctly calculated.');
    }
}

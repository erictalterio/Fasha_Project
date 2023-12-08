@isTest
private class MyTeamOrdersControllerTest {
    /**
     * Test to validate the functionality of MyTeamOrdersController, focusing on aggregate order sums.
     */
    @isTest static void testSumOrdersWithBulkData() {
        // Arrange: Create test data
        TestDataFactory.createAccountsAndOrders(201, 1000.0);

        // Start the test execution context
        Test.startTest();

        // Act: Instantiate the controller and retrieve the sum of orders.
        MyTeamOrdersController controller = new MyTeamOrdersController();
        Decimal sumOfOrders = controller.sumOrders;

        // Stop the test execution context
        Test.stopTest();

        // Assert: Verify the sum of orders is as expected.
        Decimal expectedSum = 201000.0; // Based on test data setup
        System.assertEquals(expectedSum, sumOfOrders, 'The sum of orders for 201 accounts should be correctly calculated.');
    }
}

@isTest
private class TriggerContextTest {

    @isTest static void testTriggerContextInitialization() {
        // Create test Order records (not inserted into the database)
        List<Order> testOrders = new List<Order>();
        testOrders.add(new Order(Name = 'Test Order 1'));
        testOrders.add(new Order(Name = 'Test Order 2'));

        // Set trigger context flags
        Boolean isBefore = true;
        Boolean isAfter = false;
        Boolean isUpdate = true;

        // Instantiate TriggerContext with the test data
        TriggerContext context = new TriggerContext(testOrders, isBefore, isAfter, isUpdate);

        // Assert that the context is initialized correctly
        System.assertEquals(testOrders, context.orders, 'Orders should match the test data.');
        System.assertEquals(isBefore, context.isBefore, 'isBefore should be set to true.');
        System.assertEquals(isAfter, context.isAfter, 'isAfter should be set to false.');
        System.assertEquals(isUpdate, context.isUpdate, 'isUpdate should be set to true.');
    }
}

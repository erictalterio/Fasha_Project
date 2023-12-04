@isTest
private class AccountUtilityTest {
    /**
     * This test class is designed to validate the functionality of the AccountUtility class,
     * specifically the updateChiffreDAffaire method. The test aims to ensure that the
     * Chiffre_d_affaire__c field on Account records is correctly updated based on the aggregated
     * TotalAmount of related Orders.
     */

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Create test Accounts.
        // Using a factory pattern for test data creation provides a reusable, consistent approach
        // for generating test records, ensuring test isolation and scalability.
        List<Account> testAccounts = TestDataFactory.createAccounts(2, true);
    
        // Initialize a Map to associate each Account ID with its corresponding OrderItems.
        // This structure is helpful for organizing and associating test data in a clear and 
        // manageable way, aligning with the data structure used in the method being tested.
        Map<Id, List<OrderItem>> accountOrderItemsMap = new Map<Id, List<OrderItem>>();
    
        // Create Orders for the test Accounts and store associated OrderItems in the map.
        // This setup mimics the real-world scenario where Accounts have related Orders, 
        // ensuring the test covers realistic data conditions.
        for (Account acc : testAccounts) {
            Order testOrder = new Order(
                AccountId     = acc.Id,
                Status        = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id  = Test.getStandardPricebookId()
            );
            insert testOrder;
    
            List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(
                new List<Order> {testOrder},
                1000.0 // Set a fixed Unit Price to simplify verification in test assertions
            );
    
            // Clear the Ids from OrderItems before storing them in the map.
            // This is done to simulate the state of these records before they are inserted
            // into the database, ensuring the test environment accurately reflects real-world usage.
            for(OrderItem item : testOrderItems) {
                item.Id = null;
            }
    
            accountOrderItemsMap.put(acc.Id, testOrderItems);
        }
    
        // Consolidate all OrderItems into a single list for bulk insertion.
        // This approach minimizes the number of operations
        List<OrderItem> allTestOrderItems = new List<OrderItem>();
        for (List<OrderItem> orderItems : accountOrderItemsMap.values()) {
            allTestOrderItems.addAll(orderItems);
        }
    
        // Insert all OrderItems with a single operation.
        // This is an efficient way to handle data setup in tests, reducing resource usage
        // and execution time, which is crucial for maintaining optimal performance of test suites.
        insert allTestOrderItems;
    }
}

@isTest
private class AccountUtilityTest {

    @isTest
    static void testUpdateChiffreDAffaire() {
        // Create test Accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(2, true);
    
        // Map to store OrderItems grouped by Account Id
        Map<Id, List<OrderItem>> accountOrderItemsMap = new Map<Id, List<OrderItem>>();
    
        // Create Orders for the test Accounts and store OrderItems in the map
        for (Account acc : testAccounts) {
            Order testOrder = new Order(
                AccountId     = acc.Id,
                Status        = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id  = Test.getStandardPricebookId() // Assuming this is available in test context
            );
            insert testOrder;
    
            List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(
                new List<Order> {testOrder},
                1000.0 // Unit Price
            );
    
            // Remove Ids from OrderItems before storing in the map
            for(OrderItem item : testOrderItems) {
                item.Id = null;
            }
    
            accountOrderItemsMap.put(acc.Id, testOrderItems);
        }
    
        // List to store all OrderItems for bulk insertion
        List<OrderItem> allTestOrderItems = new List<OrderItem>();
        for (List<OrderItem> orderItems : accountOrderItemsMap.values()) {
            allTestOrderItems.addAll(orderItems);
        }
    
        // Insert all OrderItems outside the loop
        insert allTestOrderItems;
    }
}

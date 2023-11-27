    // Test class for UpdateAccountsBatch.
    // Verifies the batch processing logic, ensuring it functions correctly in a bulk data context.
    @isTest
    private class UpdateAccountsBatchTest {
        @isTest static void testBatchUpdate() {
            // Create test Accounts using TestDataFactory
            List<Account> testAccounts = TestDataFactory.createAccounts(2, true);
    
            // Fetch the standard Pricebook ID
            Id standardPbId = TestDataFactory.getStandardPricebookId();
    
            // Create Orders for the test Accounts
            List<Order> testOrders = new List<Order>();
            for (Account acc : testAccounts) {
                testOrders.add(new Order(
                    AccountId     = acc.Id,
                    Status        = 'Draft', // or any valid status
                    EffectiveDate = Date.today(),
                    Pricebook2Id  = standardPbId // Set the standard Pricebook ID here
                ));
            }
            insert testOrders;
    
            // Run your batch job here
            Test.startTest();
            UpdateAccountsBatch batchJob = new UpdateAccountsBatch();
            Database.executeBatch(batchJob);
            Test.stopTest();
    
            // Add assertions or queries to verify the changes made by the batch job
        }
    }
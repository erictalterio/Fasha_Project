@isTest
// This test class is designed to verify the correct creation of PricebookEntry records in Salesforce.
// It ensures that the data creation methods in the TestDataFactory function as expected
private class PriceBookEntryTest {
    @isTest static void testPricebookEntryCreation() {
        // Arrange: Create a set of Products needed for PricebookEntries.
        // This step uses TestDataFactory to generate a consistent set of Product2 records.
        // Creating a large number of products (201 in this case) tests the factory's ability
        // to handle bulk record creation, which is crucial for scalable and robust application testing.
        List<Product2> products = TestDataFactory.createProducts(201, true);
        
        // Act: Create PricebookEntries for the generated products.
        // This step tests the functionality of creating PricebookEntries in bulk,
        // ensuring that the factory method can reliably generate PricebookEntries for multiple products.
        List<PricebookEntry> pbEntries = TestDataFactory.createPricebookEntries(products, true);

        // Assert: Verify the correct number of PricebookEntries are created and inserted.
        // This assertion checks that for every product, a corresponding PricebookEntry is created,
        // ensuring that the data creation process is complete and accurate.
        System.assertEquals(201, pbEntries.size(), 'There should be 201 pricebook entries created.');

        // Additional assertion to ensure each PricebookEntry has a valid Id.
        // This check confirms that each PricebookEntry has been successfully inserted into the database.
        for (PricebookEntry pbe : pbEntries) {
            System.assertNotEquals(null, pbe.Id, 'PricebookEntry Id should not be null after insertion.');
        }
    }
}

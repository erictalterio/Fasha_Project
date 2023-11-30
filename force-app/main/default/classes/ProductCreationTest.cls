@isTest
// This test class is focused on verifying the correct creation of Product records in Salesforce.
// It ensures that the data creation methods in the TestDataFactory are functioning as expected,
// maintaining data integrity and consistency in the context of product creation.
private class ProductCreationTest {
    @isTest static void testProductCreation() {
        // Arrange: Create a significant number of Product2 records.
        // This step uses TestDataFactory to generate a consistent set of Product2 records.
        // Creating 201 products tests the factory's ability to handle bulk record creation,
        // which is crucial for scalable and robust application testing.
        // The 'true' flag indicates that the products should be active upon creation.
        List<Product2> products = TestDataFactory.createProducts(201, true);

        // Assert: Verify the correct number of Product records are created and inserted.
        // This assertion checks that the expected number of products is created,
        // confirming the effectiveness and accuracy of the data creation process.
        System.assertEquals(201, products.size(), 'There should be 201 products created.');

        // Additional assertion to ensure each Product has a valid Id.
        // This check confirms that each Product has been successfully inserted into the database,
        // validating the proper functioning of the insertion operation in the TestDataFactory.
        for (Product2 prod : products) {
            System.assertNotEquals(null, prod.Id, 'Product Id should not be null after insertion.');
        }
    }
}

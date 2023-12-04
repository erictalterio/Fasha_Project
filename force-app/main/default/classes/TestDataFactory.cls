// Utility class for creating test data like Accounts, Orders, Products, etc.
@isTest
public class TestDataFactory

{
    /**
     * Creates a list of Account records.
     *
     * @param numRecords The number of Account records to create.
     * @param doInsert   If true, inserts the records into the database.
     * @return           A list of Account records.
     */
    public static List<Account> createAccounts(Integer numRecords, Boolean doInsert)
    {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numRecords; i++) {
            // Creating new Account with a unique name
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        // Insert accounts into the database if doInsert is true
        if (doInsert)
        {
            insert accounts;
        }
        return(accounts);
    }

    /**
     * Creates a list of Accounts and associated Orders in bulk.
     * TotalAmount for each Order is calculated based on associated OrderItems.
     *
     * @param numAccounts The number of Account and Order pairs to create.
     * @param orderAmount The total amount for each Order (simulated by creating OrderItems).
     * @return            A list of created Account records.
     */
    public static List<Account> createAccountsAndOrders(Integer numAccounts, Decimal orderAmount)
    {
        Id standardPbId = Test.getStandardPriceBookId();

        List<Account> accounts = new List<Account>();
        List<Order>   orders   = new List<Order>();

        for (Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account(Name = 'Bulk Test Account ' + i);
            accounts.add(acc);
        }
        insert accounts;

        for (Account acc : accounts) {
            Order ord = new Order(
                AccountId     = acc.Id,
                Status        = 'Ordered',
                EffectiveDate = Date.today(),
                Pricebook2Id  = standardPbId // Set the standard Pricebook ID here
                );
            orders.add(ord);
        }
        insert orders;

        createAndInsertOrderItems(orders, orderAmount);

        return(accounts);
    }


    /**
     * Creates and inserts OrderItems for given orders.
     * This is used to simulate the TotalAmount on Orders.
     *
     * @param orders      The list of Order records to associate with OrderItems.
     * @param orderAmount The simulated total amount for each Order.
     */
    public static void createAndInsertOrderItems(List<Order> orders, Decimal orderAmount)
    {
        List<OrderItem> orderItems = new List<OrderItem>();

        // Assuming there's a standard PricebookEntry available in the org
        Id standardPricebookEntryId = getStandardPricebookEntryId();

        for (Order ord : orders) {
            OrderItem oi = new OrderItem(
                OrderId          = ord.Id,
                PricebookEntryId = standardPricebookEntryId,
                Quantity         = 1,
                UnitPrice        = orderAmount
                );
            orderItems.add(oi);
        }

        if (!orderItems.isEmpty())
        {
            insert orderItems;
        }
    }

    /**
     * Retrieves the ID of a standard PricebookEntry for use in OrderItem creation.
     * Assumes there is at least one active PricebookEntry available in the org.
     *
     * @return The ID of a standard PricebookEntry.
     */
    public static Id getStandardPricebookEntryId()
    {
        // Query for an active standard PricebookEntry
        List<PricebookEntry> standardPBEs = [
            SELECT Id FROM PricebookEntry
            WHERE Pricebook2.IsStandard = true
                                          AND IsActive = true
                                                         LIMIT 1
        ];

        if (!standardPBEs.isEmpty())
        {
            return(standardPBEs[0].Id);
        }

        // No active standard PricebookEntry found, create one
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
        insert   testProduct;

        PricebookEntry standardPBE = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id   = testProduct.Id,
            UnitPrice    = 100.0,
            IsActive     = true
            );
        insert standardPBE;

        return(standardPBE.Id);
    }

    /**
     * Creates a list of Product records.
     *
     * @param numRecords The number of Product records to create.
     * @param doInsert   If true, inserts the records into the database.
     * @return           A list of Product records.
     */
    // Method to create Products
    // This method follows the same pattern as createAccounts, creating a specified
    // number of Product records and optionally inserting them into the database.
    // It returns a list of created Product records.
    public static List<Product2> createProducts(Integer numRecords, Boolean doInsert)
    {
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < numRecords; i++) {
            // Creating new Product with a unique name and family
            products.add(new Product2(Name = 'Product ' + i, Family = 'Family ' + i));
        }
        // Insert products into the database if doInsert is true
        if (doInsert)
        {
            insert products;
        }
        return(products);
    }

    /**
     * Creates a list of PricebookEntry records associated with given products.
     *
     * @param products The list of Product records to associate with PricebookEntries.
     * @param doInsert If true, inserts the records into the database.
     * @return         A list of PricebookEntry records.
     */
    // Method to create PricebookEntries
    // This method generates PricebookEntry records linked to a list of provided
    // Product records. It also follows the pattern of conditional insertion.
    public static List<PricebookEntry> createPricebookEntries(List<Product2> products, Boolean doInsert)
    {
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        for (Product2 product : products) {
            // Creating a new PricebookEntry for each product
            pbEntries.add(new PricebookEntry(
                              Pricebook2Id = Test.getStandardPricebookId(),
                              Product2Id   = product.Id,
                              UnitPrice    = 1000,
                              IsActive     = true
                              ));
        }
        // Insert PricebookEntries into the database if doInsert is true
        if (doInsert)
        {
            insert pbEntries;
        }
        return(pbEntries);
    }

    /**
     * Creates a list of Order records associated with given accounts.
     *
     * @param accounts   The list of Account records to associate with Orders.
     * @param numRecords The number of Order records to create.
     * @param doInsert   If true, inserts the records into the database.
     * @return           A list of Order records.
     */
    // Method to create Orders
    // This method creates Order records associated with a list of Account records.
    // The conditional insertion pattern is used here as well.
    public static List<Order> createOrders(List<Account> accounts, Integer numRecords, Boolean doInsert)
    {
        List<Order> orders      = new List<Order>();
        Integer     numAccounts = accounts.size(); // Get the total number of accounts

        if (numAccounts > 0)   // Check if there are any accounts
        {
            Integer accountIndex = 0; // Initialize the index to track the current account

            for (Integer i = 0; i < numRecords; i++) { // Loop to create orders
                Order newOrder = new Order();
                newOrder.AccountId = accounts[accountIndex].Id; // Assign the AccountId to the order
                orders.add(newOrder);                           // Add the order to the list

                accountIndex++; // Move to the next account
                if (accountIndex == numAccounts)
                {
                    accountIndex = 0; // Reset index to 0 when it reaches the end to cycle through accounts
                }
            }
        }

        if (doInsert && !orders.isEmpty())
        {
            insert orders; // Insert orders into the database if doInsert is true and orders exist
        }

        return(orders); // Return the list of orders created
    }

    /**
     * Creates a list of OrderItem records associated with given orders and pricebook entries.
     *
     * @param orders    The list of Order records to associate with OrderItems.
     * @param pbEntries The list of PricebookEntry records to associate with OrderItems.
     * @param doInsert  If true, inserts the records into the database.
     * @return          A list of OrderItem records.
     */
    // Method to create OrderItems
    // This method creates OrderItem records linked to Orders and PricebookEntries.
    // The records can be inserted into the database based on the doInsert flag.
    public static List<OrderItem> createOrderItems(List<Order> orders, Decimal orderAmount)
    {
        List<OrderItem> orderItems = new List<OrderItem>();

        // Assuming there's a standard PricebookEntry available in the org
        Id standardPricebookEntryId = getStandardPricebookEntryId();

        for (Order ord : orders) {
            OrderItem oi = new OrderItem(
                OrderId          = ord.Id,
                PricebookEntryId = standardPricebookEntryId,
                Quantity         = 1,
                UnitPrice        = orderAmount
                );
            orderItems.add(oi);
        }

        if (!orderItems.isEmpty())
        {
            insert orderItems;
        }

        return(orderItems);
    }

/**
 * Creates a specified number of Order records for each provided Account.
 * Each Order will have associated OrderItems to simulate a TotalAmount.
 *
 * @param accounts    The list of Account records to associate with Orders.
 * @param numOrders   The number of Order records to create for each Account.
 * @param doInsert    If true, inserts the records into the database.
 * @param orderAmount The simulated total amount for each Order.
 */
    public static void createOrders(List<Account> accounts, Integer numOrders, Boolean doInsert, Decimal orderAmount)
    {
        List<Order> orders = new List<Order>();

        // Ensure we are using the correct standard Pricebook ID
        Id standardPricebookId = Test.getStandardPricebookId(); // This method should return the correct standard Pricebook ID

        for (Account acc : accounts) {
            for (Integer i = 0; i < numOrders; i++) {
                Order ord = new Order(
                    AccountId     = acc.Id,
                    Status        = 'Draft',
                    EffectiveDate = Date.today(),
                    Pricebook2Id  = standardPricebookId // Set the standard Pricebook ID here
                    );
                orders.add(ord);
            }
        }

        if (doInsert && !orders.isEmpty())
        {
            insert orders;
            createAndInsertOrderItems(orders, orderAmount); // Create OrderItems to simulate TotalAmount
        }
    }
}
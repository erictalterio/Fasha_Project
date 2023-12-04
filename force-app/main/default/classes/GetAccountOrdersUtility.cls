public with sharing class GetAccountOrdersUtility {
    /**
     * This class provides utility methods to retrieve Account records that are associated with Orders 
     * having a specific status ('Ordered'). The class uses a with sharing keyword to respect the 
     * Salesforce record sharing rules, ensuring that data access complies with the organization's 
     * security model.
     *
     * The class is designed to be used in scenarios where there's a need to process or report on
     * Accounts based on their related Order data, such as in batch processing or reporting tools.
     */

    // A constant String that holds the SOQL query. This query retrieves Accounts that have
    // related Orders with the status 'Ordered'. It ensures that only Accounts with relevant
    // Orders are considered, optimizing the data retrieval process by filtering out irrelevant records.
    // The use of a subquery in the WHERE clause efficiently filters Accounts based on
    // related Order data, reducing the need for additional filtering or processing in Apex.
    // 'WITH SECURITY_ENFORCED' clause is included to enforce field- and object-level security,
    // ensuring that the query respects the user’s permissions and visibility.
    private static final String ACCOUNT_QUERY =
        'SELECT Id, Chiffre_d_affaire__c ' +
        'FROM Account ' +
        'WHERE Id IN (SELECT AccountId ' +
        'FROM Order ' +
        'WHERE Status = \'Ordered\' ' +
        'AND AccountId != null) ' +
        'WITH SECURITY_ENFORCED';

    /**
     * This method provides a QueryLocator for the ACCOUNT_QUERY.
     * A QueryLocator is used in scenarios like batch Apex, where it allows efficient
     * processing of large data sets. By returning a QueryLocator, this method enables the calling
     * process to handle large volumes of data that might otherwise exceed governor limits if
     * processed in a single transaction.
     *
     * @return Database.QueryLocator object initialized with the ACCOUNT_QUERY. This object can be
     *         used to retrieve query results in a way that's optimized for performance in batch
     *         processes or when dealing with large data sets.
     */
    public static Database.QueryLocator getAccountQueryLocator() {
        return Database.getQueryLocator(ACCOUNT_QUERY);
    }
}

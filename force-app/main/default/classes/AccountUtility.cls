public class AccountUtility {
    /**
     * This method is designed to update the 'Chiffre_d_affaire__c' field on Account records in Salesforce.
     * This field represents the total sales volume (revenue) for an Account, which is calculated by aggregating
     * the 'TotalAmount' from all related Orders. This is a common requirement in CRM systems to keep track of 
     * sales performance on a per-account basis.
     * 
     * @param accountIds A Set of Account IDs for which the Chiffre_d_affaire__c needs to be updated. Using a Set
     *                   ensures uniqueness and efficient lookup, which is important for processing potentially 
     *                   large numbers of accounts without duplication.
     */
    public static void updateChiffreDAffaire(Set<Id> accountIds) {
        // Initialize a Map to associate each Account ID with its aggregated TotalAmount from Orders.
        // A Map is used here for efficient retrieval and storage of accountId-TotalAmount pairs.
        Map<Id, Decimal> accountIdToTotalMap = new Map<Id, Decimal>();

        // Query and aggregate the TotalAmount for each Account from related Orders.
        // The use of AggregateResult allows for efficient processing of large datasets by pushing
        // calculations to the database level rather than processing in Apex, thus reducing
        // memory usage and improving performance.
        for (AggregateResult aggResult : [
            SELECT AccountId, SUM(TotalAmount) total
            FROM Order 
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            // Store the aggregated results in the Map
            accountIdToTotalMap.put((Id)aggResult.get('AccountId'), (Decimal)aggResult.get('total'));
        }

        // Prepare a list of Account records to be updated.
        // This list will be populated with Account instances having new Chiffre_d_affaire__c values.
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            // Create an Account instance with the updated Chiffre_d_affaire__c value.
            // This pattern avoids querying the Account records again, reducing SOQL queries,
            // and instead uses the Account IDs to update the specific field directly.
            Account acc = new Account(Id = accId, Chiffre_d_affaire__c = accountIdToTotalMap.get(accId));
            accountsToUpdate.add(acc);
        }

        // Perform a bulk update on the Accounts.
        // Bulk DML operation is used to efficiently update multiple records in one go, reducing the
        // number of DML statements and thus adhering to Salesforce governor limits.
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}

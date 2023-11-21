public class AccountUtility {
    /**
     * Updates the Chiffre_d_affaire__c field on Account records based on the aggregated TotalAmount of related Orders.
     * @param accountIds The set of Account IDs to process.
     */
    public static void updateChiffreDAffaire(Set<Id> accountIds) {
        // Map to store the aggregated TotalAmount for each Account
        Map<Id, Decimal> accountIdToTotalMap = new Map<Id, Decimal>();

        // Aggregate the TotalAmount for each Account from related Orders
        for (AggregateResult aggResult : [
            SELECT AccountId, SUM(TotalAmount) total
            FROM Order 
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            accountIdToTotalMap.put((Id)aggResult.get('AccountId'), (Decimal)aggResult.get('total'));
        }

        // Prepare a list of Accounts to update with the new aggregated TotalAmount
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            // Create Account instances with updated Chiffre_d_affaire__c values
            Account acc = new Account(Id = accId, Chiffre_d_affaire__c = accountIdToTotalMap.get(accId));
            accountsToUpdate.add(acc);
        }

        // Perform a bulk update on the Accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}

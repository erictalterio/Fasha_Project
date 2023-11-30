/**
 * The RevenueCalculator class is responsible for calculating the total revenue
 * for a list of Accounts. It updates each Account's revenue based on the total
 * amount of their associated Orders. This class is essential for maintaining up-to-date
 * revenue information on Account records, a key metric in many business processes.
 */
public class RevenueCalculator {

    /**
     * Calculates and updates the revenue for a list of accounts.
     * This method aggregates the total amount of Orders associated with each Account
     * and updates the Account's revenue field accordingly.
     * 
     * @param accounts The list of Account records to be processed for revenue calculation.
     *                 This list is typically provided by a batch process or a trigger
     *                 handling multiple Account records.
     */
    public static void calculateRevenue(List<Account> accounts) {
        // Map to hold the total amount of Orders per Account.
        // This Map is used for efficient accumulation and retrieval of total amounts by Account ID,
        // allowing for quick updates to each Account record.
        Map<Id, Decimal> accountIdToTotalAmountMap = new Map<Id, Decimal>();

        // Retrieve and aggregate the total amount of Orders for each Account.
        // This query is optimized for performance by directly aggregating the amounts in the database,
        // reducing the amount of data processed and memory used in the Apex code.
        for (Order orderRecord : [SELECT AccountId, TotalAmount FROM Order WHERE AccountId IN :accounts WITH SECURITY_ENFORCED]) {
            if (accountIdToTotalAmountMap.containsKey(orderRecord.AccountId)) {
                // If the Account is already in the map, add to its total amount.
                // This step is important for accounts with multiple orders, ensuring all order amounts are summed.
                accountIdToTotalAmountMap.put(orderRecord.AccountId, accountIdToTotalAmountMap.get(orderRecord.AccountId) + orderRecord.TotalAmount);
            } else {
                // Otherwise, add the Account with its total amount to the map.
                // This step initializes the total amount for Accounts with their first order.
                accountIdToTotalAmountMap.put(orderRecord.AccountId, orderRecord.TotalAmount);
            }
        }

        // List to hold Accounts that need to be updated.
        // This list is populated with Accounts whose revenue needs to be updated in the database.
        List<Account> accountsToUpdate = new List<Account>();

        // Update each Account's revenue field.
        for (Account myAccount : accounts) {
            if (accountIdToTotalAmountMap.containsKey(myAccount.Id)) {
                // Set the Account's revenue to the aggregated total amount from the map.
                // This updates the Account's revenue with the sum of its associated Orders.
                myAccount.Chiffre_d_affaire__c = accountIdToTotalAmountMap.get(myAccount.Id);
            } else {
                // If no Orders are associated with the Account, set revenue to 0.
                // This ensures that Accounts without Orders have their revenue accurately reflected.
                myAccount.Chiffre_d_affaire__c = 0;
            }
            accountsToUpdate.add(myAccount);
        }

        // Perform a bulk update of the Accounts if there are any to update.
        // This bulk operation ensures efficient database usage and adherence to Salesforce governor limits.
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}

public class OrderTriggerHandler {
    /**
     * This class acts as a trigger handler for Order objects in Salesforce. It encapsulates
     * the logic to be executed during various trigger events (before and after update) on Order records.
     * By separating this logic into a handler class, the code is kept organized, modular, and more maintainable.
     */

    public static void handleTrigger(TriggerContext context) {
        // Process before-update trigger events.
        // This block is executed before an Order record is updated in the database.
        // The purpose here is to pre-process or validate Order data before it's committed.
        if (context.isBefore && context.isUpdate) {
            calculateNetAmount(context.orders);
        }

        // Process after-update trigger events.
        // This block is executed after an Order record has been updated.
        // It's used in situations such as updating related records based on the updated Order.
        if (context.isAfter && context.isUpdate) {
            updateAccountChiffreDAffaire(context.orders);
        }
    }

    // Calculates the Net Amount for each Order.
    // This method subtracts the ShipmentCost__c from TotalAmount to derive the NetAmount__c for an Order.
    // It's executed in the 'before update' context to ensure the NetAmount__c is calculated and set
    // before the Order is saved to the database, maintaining data integrity and consistency.
    private static void calculateNetAmount(List<Order> orders) {
        for (Order ord : orders) {
            if (ord.TotalAmount != null && ord.ShipmentCost__c != null && ord.Status == 'Ordered') {
                ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
            }
        }
    }

    // Updates the Chiffre_d_affaire__c field for Accounts associated with the updated Orders.
    // This method gathers the AccountIds from the updated Orders and triggers an update on the Account's
    // Chiffre_d_affaire__c field. This action is performed in the 'after update' context because
    // it relies on the updated Order data being already committed to the database.
    private static void updateAccountChiffreDAffaire(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : orders) {
            if (ord.AccountId != null && ord.Status == 'Ordered') {
                accountIds.add(ord.AccountId);
            }
        }

        // Execute the Account update only if there are AccountIds to process.
        // This condition prevents unnecessary processing and updates when no relevant AccountIds are present.
        // The actual update logic is encapsulated within the AccountUtility class to maintain
        // separation of concerns and reusability of the update logic.
        if (!accountIds.isEmpty()) {
            AccountUtility.updateChiffreDAffaire(accountIds);
        }
    }
}

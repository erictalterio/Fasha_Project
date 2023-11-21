public class OrderTriggerHandler {
    public static void handleTrigger(TriggerContext context) {
        if (context.isBefore && context.isUpdate) {
            calculateNetAmount(context.orders);
        }
        if (context.isAfter && context.isUpdate) {
            updateAccountChiffreDAffaire(context.orders);
        }
    }

    private static void calculateNetAmount(List<Order> orders) {
        for (Order ord : orders) {
            if (ord.TotalAmount != null && ord.ShipmentCost__c != null) {
                ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;
            }
        }
    }

    private static void updateAccountChiffreDAffaire(List<Order> orders) {
        Set<Id> accountIds = new Set<Id>();
        for (Order ord : orders) {
            if (ord.AccountId != null) {
                accountIds.add(ord.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            // This method can be in a utility class if it becomes too complex
            AccountUtility.updateChiffreDAffaire(accountIds);
        }
    }
}

public class MyTeamOrdersController {
    // Holds the aggregate sum of all orders' total amounts.
    public Decimal sumOrders { get; private set; }

    // A list to hold aggregated data by owner.
    public List<OwnerTotal> ownerTotals { get; private set; }

    // Constructor: Initializes the controller.
    public MyTeamOrdersController() {
        sumOrders = calculateSumOrders(); // Calculate the sum of orders upon instantiation.
        aggregateOrdersByOwner(); // Aggregate orders by owner upon instantiation.
    }

    // Calculates the total sum of the 'TotalAmount' field from all Order records.
    private Decimal calculateSumOrders() {
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
        return (Decimal)groupedResults.get('total'); // Convert and return the aggregate sum.
    }

    // Inner class to hold owner total data.
    public class OwnerTotal {
        public Id ownerId { get; set; }
        public String ownerName { get; set; }
        public Decimal totalAmount { get; set; }
    }

    // Method to aggregate orders by owner.
    private void aggregateOrdersByOwner() {
        ownerTotals = new List<OwnerTotal>();

        for (AggregateResult ar : [
            SELECT OwnerId, SUM(TotalAmount) sumAmount
            FROM Order
            GROUP BY OwnerId
        ]) {
            OwnerTotal ot = new OwnerTotal();
            ot.ownerId = (Id)ar.get('OwnerId');
            ot.totalAmount = (Decimal)ar.get('sumAmount');
            User ownerUser = [SELECT FirstName, LastName FROM User WHERE Id = :ot.ownerId];
            ot.ownerName = ownerUser.FirstName + ' ' + ownerUser.LastName;
            ownerTotals.add(ot);
        }
    }
}

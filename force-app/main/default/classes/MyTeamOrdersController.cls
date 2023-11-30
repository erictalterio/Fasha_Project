public class MyTeamOrdersController {
    /**
     * This controller class is designed for aggregating and displaying order data in a Salesforce application.
     * It focuses on providing aggregated order information, both as a total sum and segmented by order owner.
     */

    // Holds the aggregate sum of all orders' total amounts.
    // This public property allows external access to the total sum of orders, 
    // which is a common requirement for reporting and data display purposes in UI components.
    public Decimal sumOrders { get; private set; }

    // A list to hold aggregated data by owner.
    // This public list is used to store and expose the order totals segmented by owner,
    // facilitating detailed reporting and analysis at the individual owner level.
    public List<OwnerTotal> ownerTotals { get; private set; }

    // Constructor: Initializes the controller.
    // The constructor is responsible for initializing the state of the controller
    // by performing initial data aggregation tasks upon instantiation.
    public MyTeamOrdersController() {
        sumOrders = calculateSumOrders(); // Calculate the sum of orders upon instantiation.
        aggregateOrdersByOwner(); // Aggregate orders by owner upon instantiation.
    }

    // Calculates the total sum of the 'TotalAmount' field from all Order records.
    // This method uses an aggregate SOQL query to efficiently calculate the total sum,
    // reducing the need for manual summation and iteration over potentially large datasets.
    private Decimal calculateSumOrders() {
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order];
        return (Decimal)groupedResults.get('total'); // Convert and return the aggregate sum.
    }

    // Inner class to hold owner total data.
    // This class serves as a structured model for holding and transferring data related to
    // the total amount of orders per owner, making data handling more manageable and organized.
    public class OwnerTotal {
        public Id ownerId { get; set; }
        public String ownerName { get; set; }
        public Decimal totalAmount { get; set; }
    }

    // Method to aggregate orders by owner.
    // This method performs an aggregate query grouped by OwnerId to calculate order totals per owner.
    // It also retrieves the name of each owner for display purposes, combining data from different objects
    // (Order and User) to provide comprehensive and ready-to-use information.
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

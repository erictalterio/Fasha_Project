public class TriggerContext {
    // Encapsulates the context of a trigger invocation, including the list of affected records
    // and the trigger's execution context (before/after, update, etc.).
    // This class simplifies passing trigger context information to handler classes.
    public List<Order> orders; // The list of Order records in the trigger context.
    public Boolean isBefore; // Flag indicating if the trigger is in the 'before' context.
    public Boolean isAfter; // Flag indicating if the trigger is in the 'after' context.
    public Boolean isUpdate; // Flag indicating if the trigger is an 'update' operation.

     // Constructor to initialize the context with specific trigger parameters.
    public TriggerContext(List<Order> orders, Boolean isBefore, Boolean isAfter, Boolean isUpdate) {
        this.orders = orders;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.isUpdate = isUpdate;
    }
}
public class TriggerContext {
    // This class encapsulates the context of a Salesforce trigger invocation.
    // It's designed to simplify the process of passing information about the trigger's execution context 
    // (such as whether it's before or after the operation, and the type of operation) to handler classes.
    // This aids in making trigger handlers more modular and easier to test.

    // List of Order records that are being processed in the trigger.
    // This allows the handler to know which records are affected by the trigger.
    public List<Order> orders;

    // Flag indicating if the trigger is executing in the 'before' context.
    // 'Before' triggers are used for validations and field updates that need to be done before the records are saved.
    public Boolean isBefore;

    // Flag indicating if the trigger is executing in the 'after' context.
    // 'After' triggers are used for operations that require record IDs or need to occur after the records have been saved.
    public Boolean isAfter;

    // Flag indicating if the operation of the trigger is an 'update'.
    // This helps in distinguishing the type of DML operation (like insert, update, delete) that invoked the trigger.
    public Boolean isUpdate;

    /**
     * Constructor to initialize the TriggerContext with specific parameters.
     * This constructor allows for creating a TriggerContext object with a clear definition of the trigger state and affected records.
     *
     * @param orders   The list of Order records being processed by the trigger.
     * @param isBefore Boolean flag to indicate if the trigger is in the 'before' context.
     * @param isAfter  Boolean flag to indicate if the trigger is in the 'after' context.
     * @param isUpdate Boolean flag to indicate if the trigger is an 'update' operation.
     */
    public TriggerContext(List<Order> orders, Boolean isBefore, Boolean isAfter, Boolean isUpdate) {
        this.orders = orders;
        this.isBefore = isBefore;
        this.isAfter = isAfter;
        this.isUpdate = isUpdate;
    }
}

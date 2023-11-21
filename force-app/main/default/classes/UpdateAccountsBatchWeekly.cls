    // A combination of batch and schedulable class.
    // Automates weekly updates of Account revenue, improving operational efficiency.
public class UpdateAccountsBatchWeekly implements Database.Batchable<sObject>, Schedulable {

    /**
     * Implements the Schedulable interface's execute method.
     * Schedules the batch job to run on a defined schedule.
     * @param sc The context of the scheduled job.
     */
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }

    /**
     * The start method prepares the batch process.
     * Retrieves the query locator for accounts to process, based on specific criteria.
     * @param bc The context of the batch job.
     * @return A QueryLocator defining the scope of Account records to be processed.
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Assuming GetAccountOrdersUtility class provides the correct query locator
        return GetAccountOrdersUtility.getAccountQueryLocator();
    }

    /**
     * The execute method processes each batch of records.
     * @param bc The context of the batch job.
     * @param scope The list of Account records in the current batch to be processed.
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Account> accounts = new List<Account>();
        for (sObject record : scope) {
            accounts.add((Account)record);
        }
        RevenueCalculator.calculateRevenue(accounts);
    }

    /**
     * The finish method is called after all batches are processed.
     * Used for post-processing steps and cleanup.
     * @param bc The context of the batch job.
     */
    public void finish(Database.BatchableContext bc) {
        // Optional: Implement any post-processing logic after batch completion
        System.debug('UpdateAccountsBatchWeekly: Batch job has finished.');
    }

    /**
     * Schedule the batch job to run weekly.
     * Can be initiated from an anonymous Apex script.
     */
    public static void scheduleWeekly() {
        String cronExp = '0 0 2 ? * SUN'; // Example: Every Sunday at 2 AM
        System.schedule('Weekly UpdateAccountsBatch', cronExp, new UpdateAccountsBatchWeekly());
    }
}

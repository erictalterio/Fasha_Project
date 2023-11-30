// A combination of batch and schedulable class.
// Automates weekly updates of Account revenue, improving operational efficiency.
public class UpdateAccountsBatchWeekly implements Database.Batchable<sObject>, Schedulable {

    /**
     * Implements the Schedulable interface's execute method.
     * This method is invoked when the scheduled job runs. It triggers the batch job to start,
     * allowing for regular, automated updates of Account revenue.
     *
     * @param sc The context of the scheduled job.
     */
    public void execute(SchedulableContext sc) {
        // Initiate the batch process when the scheduled job executes.
        Database.executeBatch(this);
    }

    /**
     * The start method prepares the batch process.
     * Retrieves the query locator for Accounts to process, based on specific criteria.
     * This method defines which Accounts will be processed by the batch job.
     *
     * @param bc The context of the batch job.
     * @return Database.QueryLocator defining the scope of Account records to be processed.
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Use GetAccountOrdersUtility to retrieve a QueryLocator.
        // This QueryLocator targets Accounts that meet certain criteria, ensuring the batch job processes relevant records.
        return GetAccountOrdersUtility.getAccountQueryLocator();
    }

    /**
     * The execute method processes each batch of records.
     * This method is called for each batch of records processed by the batch job.
     * It calculates and updates the revenue for each Account in the batch.
     *
     * @param bc The context of the batch job.
     * @param scope The list of sObject records (Accounts) in the current batch to be processed.
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Account> accounts = new List<Account>();
        // Convert each sObject in the scope to an Account object.
        for (sObject record : scope) {
            accounts.add((Account)record);
        }
        // Calculate and update the revenue for each Account.
        RevenueCalculator.calculateRevenue(accounts);
    }

    /**
     * The finish method is called after all batches are processed.
     * It's used for any post-processing steps or cleanup after the batch job is complete.
     * This could include logging, notifications, or other finalization steps.
     *
     * @param bc The context of the batch job.
     */
    public void finish(Database.BatchableContext bc) {
        // Log completion of the batch process for monitoring or auditing purposes.
        System.debug('UpdateAccountsBatchWeekly: Batch job has finished.');
    }

    /**
     * Schedule the batch job to run weekly.
     * This static method allows for easy scheduling of the batch job using an Apex script.
     * It defines the frequency of the batch job using a CRON expression.
     */
    public static void scheduleWeekly() {
        // CRON expression for scheduling: Every Sunday at 2 AM, as an example.
        String cronExp = '0 0 2 ? * SUN';
        // Schedule the batch job with the specified CRON expression.
        System.schedule('Weekly UpdateAccountsBatch', cronExp, new UpdateAccountsBatchWeekly());
    }
}

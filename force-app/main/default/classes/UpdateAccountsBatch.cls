/**
 * This batch class updates the Revenue for Accounts
 * based on their associated orders. It utilizes utility classes for querying and calculations.
 * This batch process is designed to handle large data volumes efficiently by processing accounts in batches.
 */
global class UpdateAccountsBatch implements Database.Batchable<sObject> {

    /**
     * The start method prepares the batch process.
     * It retrieves a query locator for accounts to process, based on specific criteria defined
     * in the GetAccountOrdersUtility class. This method sets the scope of the batch job.
     *
     * @param bc The context of the batch job.
     * @return Database.QueryLocator defining the scope of Account records to be processed.
     *         The query locator selects accounts that are relevant for the revenue update process.
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Retrieve the query locator from GetAccountOrdersUtility, defining which accounts to process.
        return GetAccountOrdersUtility.getAccountQueryLocator();
    }

    /**
     * The execute method processes each batch of records.
     * In this method, the actual revenue calculation and update for each Account in the batch is performed.
     * This is where the bulk of the processing work is done.
     *
     * @param bc The context of the batch job.
     * @param scope The list of Account records in the current batch to be processed.
     *              Each batch of accounts is processed independently.
     */
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        // Calculate and update the revenue for each Account in the batch.
        // The RevenueCalculator is used to perform the necessary calculations and updates.
        // This modular approach separates the logic of revenue calculation from the batch processing.
        RevenueCalculator.calculateRevenue(scope);
    }

    /**
     * The finish method is called after all batches are processed.
     * This method is used for any post-processing steps or cleanup after the batch processing is complete.
     * Typically used for logging, notifications, or any other final steps required after the batch completion.
     *
     * @param bc The context of the batch job.
     */
    global void finish(Database.BatchableContext bc) {
        // Log a message indicating the completion of the batch process.
        System.debug('UpdateAccountsBatch: Batch job has finished.');
    }
}

    // Central handler for Order triggers, managing both 'before' and 'after' update events.
    // Enhances maintainability and reduces complexity in trigger logic.
trigger OrderTrigger on Order (before update, after update) {
    OrderTriggerHandler.handleTrigger(new TriggerContext(Trigger.new, Trigger.isBefore, Trigger.isAfter, Trigger.isUpdate));
}
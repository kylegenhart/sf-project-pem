public class UpdateEventBatch implements  Database.Batchable<sObject> {
	
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        String Query = 'Select Id, Name From Event__c Where Live__c = false AND Status__c != \'Complete\' AND End_Date_Time__c < LAST_N_MONTHS:4';
        return Database.getQueryLocator(Query);
    }

    public void execute(Database.BatchableContext batchContext, List<Event__c> eventList ){
        List<Event__c> updatedEvtRecsList = new List<Event__c>();
        for(Event__c evt: eventList){
            evt.Status__c = 'Deleted';
            updatedEvtRecsList.add(evt);
            }
        update updatedEvtRecsList;
    }
    public void finish(Database.BatchableContext batchContext){
        String userName = UserInfo.getUserName();
        User activeUser = [Select Name, Email From User where Username = : userName limit 1];
        String userEmail = activeUser.Email;
        String uName = activeUser.Name;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Batch Processing Completed');
        List<String> toAddress = new List<String>();
        toAddress.add(userEmail);
        mail.setToAddresses( toAddress );
        mail.setSenderDisplayName(uName);
        mail.setHtmlBody('the execution of the batch has been processed.');
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        email.add(mail);
        Messaging.sendEmail(email);
    }
}
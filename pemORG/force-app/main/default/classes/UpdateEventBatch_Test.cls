@isTest
private class UpdateEventBatch_Test {
@isTest
    public static void testUpdateEvent(){
        Test.startTest();
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Status__c = 'Created';
        evt.Live__c = false;
        evt.Start_Date_Time__c = datetime.newInstance(2020, 6, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2020, 6, 22, 20, 30, 0);
        insert evt;
        Database.executeBatch(new UpdateEventBatch(), 200);
        Test.stopTest();

        
        Event__c retrievedEvt = [Select Id, Name,Status__c  From Event__c];
        System.assertEquals ('Deleted',retrievedEvt.Status__c);
    }
}
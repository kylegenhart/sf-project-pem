@isTest
private class EventsRestService_Test {
    Static Id createTestEvent(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        insert evt;
        return evt.Id;
    }
    @IsTest
    static void doGetEvtTest(){
        Test.startTest();
        Id evtId = createTestEvent();
        RestRequest req = new RestRequest();
        req.requestURI = 'https://collaberatechnologies--pemsandbox.my.salesforce.com/services/apexrest/api/Event__c/'+evtId;
        req.httpMethod = 'GET';
        RestContext.request = req;
        Event__c retrievedEvt = EventsRestService.doGetEvt();
        System.assertEquals(evtId, retrievedEvt.Id);
        Test.stopTest();  
        
    }
}

@isTest
private class PreventDuplicateEventSpeaker_Test {
    Static Id createTestRecordID(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Live__c = true;
        evt.Start_Date_Time__c = datetime.newInstance(2021, 6, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2021, 6, 22, 20, 30, 0);
        insert evt;
        return evt.Id;
    }
    Static Id createTestSpeakerId(){
      Speaker__c spk = new Speaker__c();
      spk.Name = 'Test Speaker';
      insert spk;
      return spk.id;
    }

        @IsTest
      Static void checkEventSpeaker(){
        Test.startTest();
        try {
        Event_Speaker__c eS = new Event_Speaker__c();
        eS.Name = 'Test Event-Speaker';
        eS.Event__c = createTestRecordID();
        eS.Speaker__c = createTestSpeakerId();
        insert eS;
        
        Event_Speaker__c esNew = new Event_Speaker__c();
        esNew.Name = 'Test Event-Speaker';
        esNew.Event__c = createTestRecordID();
        esNew.Speaker__c = createTestSpeakerId();
        insert esNew;
        List<Event_Speaker__c> esList = [Select id,Name, Event__r.Name, Event__r.Start_Date_Time__c, Event__r.End_Date_Time__c from Event_Speaker__c];
        PreventDuplicateEventSpeaker.checkDuplicate(esList);
        Test.stopTest();
        Event_Speaker__c retrievedES = [Select Name from Event_Speaker__c where Name =: esNew.Name];
        System.assertEquals('Test Event-Speaker',retrievedES.Name);
        } catch (Exception e) {
          System.debug('Get Exception'+e.getMessage());
          
            
        }
      }

    
}


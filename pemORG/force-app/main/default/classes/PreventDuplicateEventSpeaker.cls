public class PreventDuplicateEventSpeaker {
    public static void checkDuplicate(List<Event_Speaker__c> newES){
        try {
            Set<Id> eventId = new Set<Id>();
            Set<Id> eventSpeakerId = new Set<Id>();

            for(Event_Speaker__c evntSpkr : newES){
                eventId.add(evntSpkr.Event__c);
                eventSpeakerId.add(evntSpkr.Speaker__c);
            }
            Map<Id, DateTime> startEvent = new Map<Id, DateTime>();
            Map<Id, DateTime> endEvent = new Map<Id, DateTime>();
            Map<Id, Event_Speaker__c> eventSpeakerMap = new Map<Id, Event_Speaker__c>();
            
            List<Event__c> getEventList = [SELECT Id, Name,Start_Date_Time__c,End_Date_Time__c FROM Event__c 
            WHERE Id IN : eventId];

            List<Event_Speaker__c> getEventSpeakerList = [SELECT Id, Event__c.Start_Date_Time__c, Event__c.End_Date_Time__c FROM Event_Speaker__c WHERE Id IN :eventSpeakerId];

            for(Event__c evt : getEventList ){
                startEvent.put(evt.Id, evt.Start_Date_Time__c);
                endEvent.put(evt.Id, evt.End_Date_Time__c);
            }
            for(Event_Speaker__c evtspk : getEventSpeakerList){
                eventSpeakerMap.put(evtspk.Id, Event_Speaker__c);
            }
            
            List<Event_Speaker__c> esList = [SELECT Id, Event__c, Speaker__c,Event__r.Start_Date_Time__c,Event__r.End_Date_Time__c FROM Event_Speaker__c
            WHERE Speaker__c IN : eventSpeakerId];

            for(Event_Speaker__c evntSpkr : newES){

                DateTime startTime = startEvent.get(evntSpkr.Event__c);
                DateTime endTime = endEvent.get(evntSpkr.Event__c);
    
                    for(Event_Speaker__c rS: esList)
                    {
                        if((rS.Event__r.Start_Date_Time__c < endTime && rS.Event__r.End_Date_Time__c > endTime)
                        ||(rS.Event__r.Start_Date_Time__c < startTime && rS.Event__r.End_Date_Time__c > startTime)
                        ||(rS.Event__r.Start_Date_Time__c >= startTime && rS.Event__r.End_Date_Time__c <= endTime))
                        {
                            evntSpkr.Speaker__c.addError('This speaker already has an Event.');
                        }
                    }
                }
        } catch (Exception e) {
            System.debug('Get Exception'+e.getMessage());
        }
    }
    
}
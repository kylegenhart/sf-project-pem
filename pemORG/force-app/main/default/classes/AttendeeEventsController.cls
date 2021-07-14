public with sharing class AttendeeEventsController {
    @AuraEnabled(cacheable = true)
    public static List<Event_Attendee__c> upcomingEvents(String attendeeId){
            List<Event_Attendee__c> eventList = [
            SELECT
                Id,
                Name,
                Event__c,
                Event__r.Location_Address_Book__c,
                Event__r.Location_Address_Book__r.Name,
                Event__r.Event_Organizer__c,
                Event__r.Event_Organizer__r.Name,
                Event__r.Name__c,
                Event__r.Start_Date_Time__c,
                Event__r.End_Date_Time__c
            FROM Event_Attendee__c
            WHERE
                Attendee__c = :attendeeId
                AND Event__r.Start_Date_Time__c >= today
                AND Event__r.Live__c = true
            ];
            return eventList;
    }

    @AuraEnabled(cacheable = true)
    public static List<Event_Attendee__c> pastEvents(String attendeeId){
        
            List<Event_Attendee__c> eventList = [
            SELECT
                Id,
                Name,
                Event__c,
                Event__r.Location_Address_Book__c,
                Event__r.Location_Address_Book__r.Name,
                Event__r.Event_Organizer__c,
                Event__r.Event_Organizer__r.Name,
                Event__r.Name__c,
                Event__r.Start_Date_Time__c,
                Event__r.End_Date_Time__c
            FROM Event_Attendee__c
            WHERE Attendee__c = :attendeeId AND Event__r.Start_Date_Time__c < today
        ];
            return eventList;
        
    }
}
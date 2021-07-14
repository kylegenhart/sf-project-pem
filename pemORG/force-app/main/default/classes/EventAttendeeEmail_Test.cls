@isTest
public class EventAttendeeEmail_Test {
	
    
    public static void setupData(){
        
        Event_Organizer__c  org = new Event_Organizer__c (
            Name = 'Kyle Bawagan',
            Phone__c = '177013',
            Email__c = 'kyle.bawagan@gmail.com'
        );
        insert org;
        
        Event__c event = new Event__c(
            Name__c = 'Event 4 fun',
            Event_Organizer__c  = org.Id,
            Event_Type__c = 'Virtual',
            Frequency__c  = 'Weekly',
            Max_Seats__c  = 199,
            Recurring__c = true,
            Live__c = true,
            Start_Date_Time__c = System.now(),
            End_Date_Time__c  = System.now().addDays(3)
        );
        insert event;
        Attendee__c att = new Attendee__c(
            Name = 'KGB F',
            Email__c = 'kyle.bawagan@gmail.com',
            Phone__c = '12121934'
        );
        insert att;
        
        Event_Attendee__c evtAtt = new Event_Attendee__c(Event__c = event.Id, Attendee__c = att.Id);
        insert evtAtt;
    }

    @IsTest
    static void testEmail(){
        
        Test.startTest();
        setupData();
        List <Event_Attendee__c> evtAtt = [Select Id, Name, Attendee__c, Event__c from Event_Attendee__c];
        EventAttendeeEmail.sendConfirmationEmail(evtAtt);
        Test.stopTest();
        
    }
}
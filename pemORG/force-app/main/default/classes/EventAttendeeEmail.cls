public with sharing class EventAttendeeEmail {
    public static void sendConfirmationEmail(List<Event_Attendee__c> newES ) {// when an attendee is assigned to an event
        
        Set<Id> attendeesIdsSet = new Set<Id>();
        Set<Id> eventIdsSet = new Set<Id>();
        
        for(Event_Attendee__c ea : newES){
            attendeesIdsSet.add(ea.Attendee__c);
            eventIdsSet.add(ea.Event__c);
        }
        
        Map<Id,Attendee__c> attendeeMap = new Map<Id,Attendee__c>( 
            [SELECT Id, Name, Email__c From Attendee__c WHERE  Id IN : attendeesIdsSet]
        );
        
        Map<Id, Event__c > eventMap = new Map<Id, Event__c > ( [SELECT Id, Name__c, Start_Date_Time__c, Event_Organizer__c , Event_Organizer__r.Name,
        Location_Address_Book__c , Location_Address_Book__r.Name, Location_Address_Book__r.City__c,
        Location_Address_Book__r.State__c, Location_Address_Book__r.Country__c,
        Location_Address_Book__r.Postal_Code__c, Location_Address_Book__r.Street__c
        FROM Event__c  WHERE ID IN: eventIdsSet]
        );
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for(Event_Attendee__c ea : newES){
            
            Attendee__c att = attendeeMap.get(ea.Attendee__c);
            Event__c evt = eventMap.get(ea.Event__c);
              
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Pass for the '+evt.Name__c);
            List<String> toAddress = new List<String>();
            toAddress.add(att.Email__c);
            mail.setToAddresses( toAddress );
            mail.setSenderDisplayName(evt.Event_Organizer__r.Name);
            
            String location = 'https://www.google.com/maps/place/'+evt.Location_Address_Book__r.Street__c+' '+evt.Location_Address_Book__r.City__c+' '
                +evt.Location_Address_Book__r.State__c+' '+
                evt.Location_Address_Book__r.Country__c+' '+evt.Location_Address_Book__r.Postal_Code__c;
            String hrefForLocation = '<a href="'+location+'"'+'target="_blank">Here</a>';
            String emailBody = 'Dear '+ att.Name + ',<br/><br/>'+
                'Thank you for registering for '+evt.Name__c+' which will be organized on '+
                evt.Start_Date_Time__c+' & will be held in '+evt.Location_Address_Book__r.Name
                +'.<br/>We are excited to have you,'+ 
                'see you in the event. <br/>'+
                'Find the Google Map Location for the Event '+hrefForLocation+'.<br/><br/><br/>'+
                'Thanks,<br/>'+evt.Event_Organizer__r.Name;
            
            mail.setHtmlBody(emailBody);
            emailList.add(mail);
            
        }
        
        try{
            
            List<Messaging.SendEmailResult> results =  Messaging.sendEmail(emailList, false); 
            for(Messaging.SendEmailResult email : results){
                System.debug(email.isSuccess());
                if(!email.isSuccess()){
                    List<Messaging.SendEmailError> errors = email.getErrors();
                }
            }  
        }catch(System.Exception e){
            System.debug('error'+e);
        }
    }
}
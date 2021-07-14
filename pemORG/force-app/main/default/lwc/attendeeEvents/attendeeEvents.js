import { LightningElement,api,track,wire } from 'lwc';
import upcomingEvents from '@salesforce/apex/AttendeeEventsController.upcomingEvents';
import pastEvents from '@salesforce/apex/AttendeeEventsController.pastEvents';

export default class AttendeeEvents extends LightningElement {
    @api recordId;
    @track newEvent;
    @track oldEvent;
    @track columns = [
      {
        label: 'Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
      },
      {
        label: 'Location',
        fieldName: 'Location',
        type: 'text',
        sortable: true
      },
      {
        label: 'Start Date',
        fieldName: 'Start_Date_Time__c',
        type: 'date',
            typeAttributes: {
                weekday: 'long',
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
              }
      },
      {
        label: 'End Date',
        fieldName: 'End_Date_Time__c',
        type: 'date',
            typeAttributes: {
                weekday: 'long',
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
              }
      }
      ];
    
    @track error;
    @wire(upcomingEvents, {attendeeId : '$recordId'}) wiredUpcomingEvents({error,data}){
      
      var returnOptions = [];
      if(data){
        data.forEach(ele => {
          var loc;
                if(ele.Event__r.Location_Address_Book__c){
                    loc = ele.Event__r.Location_Address_Book__r.Name;
                }else{
                    loc = 'This is Virtual';
                }
          returnOptions.push({Name : ele.Event__r.Name__c,
                              Start_Date_Time__c : ele.Event__r.Start_Date_Time__c,
                              Location : loc,
                              End_Date_Time__c : ele.Event__r.End_Date_Time__c
        });  
      });
      this.newEvent = returnOptions;
      }else if(error){
        this.error=error;
      }
    }
  
    @wire(pastEvents, {attendeeId : '$recordId'}) wiredPastEvents({error,data}){
      
      var returnOptions2 =[];
      if(data){
        data.forEach(ele => {
          var loc;
                if(ele.Event__r.Location_Address_Book__c){
                    loc = ele.Event__r.Location_Address_Book__r.Name;
                }else{
                    loc = 'This is event has ended';
                }
          returnOptions2.push({Name : ele.Event__r.Name__c,
                              Location : loc,
                              Start_Date_Time__c : ele.Event__r.Start_Date_Time__c,
                              End_Date_Time__c : ele.Event__r.Start_Date_Time__c
          });  
         });
      this.oldEvent = returnOptions2;
      }else if(error){
        this.error=error;
      }
    }
}
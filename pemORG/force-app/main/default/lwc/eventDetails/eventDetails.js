import { LightningElement, api, track, wire} from "lwc";
import getSpeakers from "@salesforce/apex/EventDetailsController.getSpeakers";
import getLocationDetails from "@salesforce/apex/EventDetailsController.getLocationDetails";
import getAttendees from "@salesforce/apex/EventDetailsController.getAttendees";


const columns = [
  {
    label: "Name",
    fieldName: "Name",
    cellAttributes: {
      iconName: "standard:user",
      iconPosition: "left"
    }
  },
  { label: "Email", fieldName: "Email", type: "email" },
  { label: "Phone", fieldName: "Phone", type: "phone" },
  { label: "Company Name", fieldName: "CompanyName" }
];

const columnsAtt = [
  {
    label: "Name",
    fieldName: "Name",
    cellAttributes: {
      iconName: "standard:user",
      iconPosition: "left"
    }
  },
  { label: "Email", fieldName: "Email", type: "email" },
  { label: "Company Name", fieldName: "CompanyName" },
  {
    label: "Location",
    fieldName: "Location",
    cellAttributes: {
      iconName: "utility:location",
      iconPosition: "left"
    }
  }
];

export default class EventDetails extends LightningElement {
  @api recordId;
  @track speakerList;
  @track eventRec;
  @track attendeesList;
  @track error;
  @track columnsList = columns;
  @track columnAtt = columnsAtt;
  

  @wire(getSpeakers, {eventId : '$recordId'}) wiredGetSpeakers({error,data}){
  
    var returnOptions = [];
    if(data){
      data.forEach((speaker) => {
        returnOptions.push({
          Name : speaker.Speaker__r.Name,
          Email : speaker.Speaker__r.Email__c,
          Phone : speaker.Speaker__r.Phone__c,
          CompanyName : speaker.Speaker__r.Company__c
        });

      });

      this.speakerList = returnOptions;

    }else if(error){
      this.error=error;
    }
  }
  @wire(getLocationDetails,{eventId : '$recordId'}) wiredGetLocationDetails({error,data}){
    console.log(this.recordId);
    console.log(data);
    if(data){
      this.eventRec = data;
    }else if(error){
      this.error=error;
    }
}
  @wire(getAttendees, {eventId : '$recordId'}) wiredGetAttendees({error,data}){

    var returnOptions = [];
    if(data){
      data.forEach((att) => {
        var loc;
        if (att.Attendee__r.Location_Address_Book__c) {
          loc = att.Attendee__r.Location_Address_Book__r.Name;
        } else {
          loc = "Preferred Not to Say";
        }
        returnOptions.push({
          Name : att.Attendee__r.Name,
          Email : att.Attendee__r.Email__c,
          CompanyName : att.Attendee__r.Company_Name__c,
          Location : loc
        });

      });
      
      this.attendeesList = returnOptions;
      
  }else if(error){
    this.error=error;
  }
}

}
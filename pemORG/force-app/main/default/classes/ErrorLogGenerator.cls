public with sharing class ErrorLogGenerator {
    public static void createErrorLog(DateTime logDate, String logDetails, String name){
        Error_Log__c log = new Error_Log__c();
        log.Error_Date_Time__c = logDate;
        log.Log_Details__c = logDetails;
        log.Process_Name__c = name;
        insert log;
    }
}
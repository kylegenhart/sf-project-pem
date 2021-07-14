@isTest
public with sharing class LocationVerifierClass_Test {
    public static testMethod void testZip(){

        Location__c loc = new Location__c(
            Name = '3301 South Greenfield Rd',
            Street__c = '3301 South Greenfield Rd',
            City__c = 'Gilbert',
            State__c = 'AZ',
            Postal_Code__c = '85297',
            Country__c = 'United States'
        );
        insert loc;



        try{
            Test.setMock(HttpCalloutMock.class, new ZipCalloutMock());
            Test.startTest();

            LocationVerifierClass.checkZipCode(''+loc.Id+'');
            
            Test.stopTest();
        }catch(Exception ex){

        }
        Location__c retrievedZipVerified = [Select Is_Zip_correct__c from Location__c where Id =: loc.Id];
        System.assertEquals(true,retrievedZipVerified.Is_Zip_correct__c);

    }
    public static testMethod void testStreet(){
        Location__c loc = new Location__c(
            Name = '3301 South Greenfield Rd',
            Street__c = '3301 South Greenfield Rd',
            City__c = 'Gilbert',
            State__c = 'AZ',
            Postal_Code__c = '85297',
            Country__c = 'United States'
        );
        insert loc;

        try{
            Test.setMock(HttpCalloutMock.class, new LocationCalloutMock());
            Test.startTest();

            LocationVerifierClass.checkStreet(''+loc.Id+'');
            
            Test.stopTest();
        }catch(Exception ex){
            System.debug('Get Exception'+ex.getMessage());
        }
        Location__c retrievedLocVerified = [Select Verified__c from Location__c where Id =: loc.Id];
        System.assertEquals(true,retrievedLocVerified.Verified__c);
    }

}
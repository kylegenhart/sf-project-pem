public with sharing class LocationVerifierClass {
    @future (callout=true)
    public static void checkZipCode(String locId) {
        Location__c loc = [Select Id,Is_Zip_correct__c,State__c,Street__c,Postal_Code__c,City__c from Location__c where Id = :locId];

        Http httpzip = new Http();
        HttpRequest reqzip = new HttpRequest();
        String addzip = 'https://us-zipcode.api.smartystreets.com/lookup?auth-id=0f0fd4b8-40c2-f690-8b0b-ed0b2a71dbac&auth-token=70M6Bai1spjs143VH8E1&city=&state=&zipcode='+loc.Postal_Code__c;
        reqzip.setEndPoint(addzip);
        reqzip.setMethod('GET');
        HttpResponse respzip= new HttpResponse();
        respzip = httpzip.send(reqzip);


        try {
            if(respzip.getStatusCode() == 200){
                List<Object> resultsZipList = (List<Object>)JSON.deserializeUntyped(respzip.getBody());
                    for(Object obj : resultsZipList){
                        Map<String, Object> results = (Map<String, Object>) obj;
                        List<Object> zipObject = (List<Object>) results.get('zipcodes');
                        if(zipObject!=null){
                            loc.Is_Zip_correct__c = true;
                            checkStreet(locId);
 
                        }else{
                            loc.Is_Zip_correct__c = false;
                            update loc;
                        }
                    }
            }
        } 
        catch (Exception ex) {
            System.debug('Exception -- ' + ex.getMessage());
        }
    }  
    
    public static void checkStreet(String locId){
        Location__c loc = [Select Id,Is_Zip_correct__c,State__c,Street__c,Postal_Code__c,City__c from Location__c where Id = :locId];
        Http httpst = new Http();
        HttpRequest reqst = new HttpRequest();
        String addst = 'https://us-street.api.smartystreets.com/street-address?auth-id=0f0fd4b8-40c2-f690-8b0b-ed0b2a71dbac&auth-token=70M6Bai1spjs143VH8E1&'
        +'street=' + EncodingUtil.urlEncode(loc.Street__c, 'UTF-8') 
        +'&city='+ EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
        +'&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8');
        reqst.setEndPoint(addst);
        reqst.setMethod('GET');
        HttpResponse respst= new HttpResponse();
        respst = httpst.send(reqst); 
        try {
            if(respst.getStatusCode() == 200){
                String respstBody = respst.getBody();
                Integer zc;
                List<Object> resultsList = (List<Object>)JSON.deserializeUntyped(respst.getBody());
                for(Object obj : resultsList){
                    Map<String, Object> results = (Map<String, Object>) obj;
                    Map<String, Object> result = (Map<String, Object>)results.get('components');
                    zc = (Integer)integer.valueof(result.get('zipcode'));
                }
                    if(respstBody.length()>2 && zc==integer.valueof(loc.Postal_Code__c)){
                        
                        loc.Verified__c = true;
                    }else{
                        
                        loc.Verified__c = false;
                    }
                    update loc;
            }
        } 
        catch (Exception ex) {
            System.debug('Exception -- ' + ex.getMessage());
        }
    }

}
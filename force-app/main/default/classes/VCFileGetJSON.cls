public class VCFileGetJSON {
    @RemoteAction
    public static String getBrandsData() {
        String response;
        User currentUser = getCurrentUser();
        
        system.debug(currentUser.RetailerAccess__c );
        document docAccess = getDoc('GROUP', currentUser,'', '');
        
        response = docAccess.Body.toString();
        system.debug(response);
        return response;
    }
        
    @RemoteAction
    public static String getSalesDataByParameter ( String BrandID ) {
        
        String response;
        User currentUser = getCurrentUser();
        document docAccess = getDoc('BRAND', currentUser,'', '');
        
        response = docAccess.Body.toString();
        system.debug(response);
        return response;
        
    }
    
    /*@RemoteAction
    public static String getSalesDataByParameter ( String BrandID ) {
        
        String response;
        
        User currentUser = getCurrentUser();
        LIST<String> userBrandAccess = currentUser.RetailerAccess__c.split(';');

        SET<STRING> userBrandAccessSet = new Set<String> (userBrandAccess);
        system.debug(userBrandAccessSet.contains(BrandID));
        
        if(userBrandAccessSet.contains(BrandID)) { //If user has access on the brandId based on the User's multiple picklist values
            document docAccess = getDoc('BRAND', currentUser, BrandID, '');
            
            if (docAccess != null){
                response = docAccess.Body.toString();
                system.debug(response);
            }else{
                //Error handling if no retailer document found in the file drive
                //            
                V3ErrorJsonMsg errorMsg = new V3ErrorJsonMsg('BrandIdError', 'Missing brandID datafile in the server: ' + BrandId, 981);
                response = JSON.serialize(errorMsg);
            }
        }else{
            
            V3ErrorJsonMsg errorMsg = new V3ErrorJsonMsg('BrandIdError', 'You are not authorized to access this BrandId ' + BrandId, 980);
            response = JSON.serialize(errorMsg);
            //Error handling if user do not have access to the brandId.
        }
        system.debug(response);
        return response;
        
    }*/
    
    @RemoteAction
    public static String getCategories() {
        String fileName = '/shared/category_data/index.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getCategory(String categoryName) {
        String fileName = '/shared/category_data/' + categoryName + '.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getCategoryStores(String categoryName) {
        String fileName = '/shared/categories/' + categoryName.replace(' ', '_') + '.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getCentres() {
        String fileName = '/shared/centres/index.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getCentre(String centreId) {
        String fileName = '/shared/centres/' + centreId + '/index.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getCentreDemographics(String centreId) {
        String fileName = '/shared/centres/' + centreId + '/demographics.json';
        return getJsonData(fileName);
    }
    
    @RemoteAction
    public static String getContacts( ) {
        String fileName = '/shared/contacts.json';
        return getJsonData(fileName);
    }
    
    public static String getJsonData(String fileName) {
        // Current folderId is hard-coded. Ideally it should retrieve the folderId based customSetting.
        String dataFolderId = '00l7F000000K356QAC';
        Document doc = [
            SELECT body
            FROM document
            WHERE
            folderID = :dataFolderId
            AND type = 'json'
            AND name = :fileName
        ];
        return doc.body.toString();
    }
    
    public static Document getDoc(String typeOFRequest, User currentUser, String brandId, String centreId){
        Document doc;
        String fileName = '';
        String groupFileName = '/index';
        String brandFileName = '/sales';
        
        if(typeOFRequest == 'GROUP'){
            fileName = currentUser.GroupId__c + groupFileName;
        }else if(typeOFRequest == 'BRAND'){
            
            if (brandID == ''){
                fileName = currentUser.RetailerId__c + brandFileName;
                
            }else{
                fileName = brandId + brandFileName;    
            }
        }
        
        System.debug('FileName: '+fileName);
        try{
            doc = [SELECT id, name, url, type, FolderId, body from document where folderID = '00l7F000000K356QAC' and type ='json' and name =: fileName]; //Current folderId is hard-coded. Ideally it should retrieve the folderId based customSetting.
        }catch(QueryException e ) {

            System.debug( e.getMessage() );
            
        }
        return doc;
    }

    
    
    @RemoteAction
    public static User getCurrentUser() {
        User currentUser = [Select Id, Name, GroupId__c, Level__c, RetailerId__c, RetailerAccess__c   From User Where Id = :UserInfo.getUserId()];
        return currentUser;
    }
}
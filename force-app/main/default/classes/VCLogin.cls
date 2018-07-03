public with sharing class VCLogin {
    
    @RemoteAction 
    public static PageReference login(String username, String password) {
        return Site.login(username, password, null);
    }

}
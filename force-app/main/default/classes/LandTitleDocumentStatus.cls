@RestResource(urlMapping='/DocumentStatus')
global class LandTitleDocumentStatus{
    public String Response {get; set;}
    public void redirectToRelevent(){
        GenericUtility.insertLog('CHECK', new CustomException('CHECK'));
    }
    @HttpPost
    global static void createHistory(String Name) {
        GenericUtility.insertLog('CHECK', new CustomException('CHECK'));
    }
}
/***************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class is used to convert response from clone Object 
                 json format 
Development Date : 1/02/2022
Last Modified Date : 10/02/2022
****************************************************************************************************/
public class CloneApplicationRelatedListParser {
    public String objName;  //genesis__Applications__c
    public String Lookup;
    public cls_relatedObj[] relatedObj;
    class cls_relatedObj {
        public String objName;
        public String Lookup;
        public cls_relatedObj[] relatedObj;
    }
    public static CloneApplicationRelatedListParser parse(String json){
        return (CloneApplicationRelatedListParser) System.JSON.deserialize(json, CloneApplicationRelatedListParser.class);
    }
}
/********************************************************************************************/
/* Description : This class parses the response for Equifax Org Id Search and converts JSON 
                 response into Apex POJO Object.
/********************************************************************************************/
public class EquifaxOrgIdSearchParser {
    public String errMessage;
    public Cls_BCAmessage bcamessage;
    public class Cls_Nodevalue{
        public String nodeValue;
    }
	public class Cls_BCAmessage {
		public String serviceRequestId;	
		public Cls_BCAservices bcaservices;
	}
	public class Cls_BCAservices {
		public Cls_BCAservice bcaservice;
	}
	public class Cls_BCAservice {
		public Cls_BCAserviceData bcaserviceData;
	}
	public class Cls_BCAserviceData {
		public Cls_response response;
	}
	public class Cls_response {
		public Cls_orgIdResult[] orgIdResult;
	}
	public class Cls_orgIdResult {
		public Cls_Nodevalue australianBusinessNumber;
		public Cls_asicReport asicReport;
	}
	public class Cls_asicReport {
		public Cls_Nodevalue asicName;
		public Cls_Nodevalue asicStatus;
	}
	public static EquifaxOrgIdSearchParser parse(String json){
        try{
            //Replacing unwanted characters from variable names
            json = json.replaceAll('_service','service');
            json = json.replaceAll('-request','Request');
            json = json.replaceAll('-id','Id');
            json = json.replaceAll('BCA','bca');
            json = json.replaceAll('-data','Data');
            json = json.replaceAll('-result','Result');
            json = json.replaceAll('-business','Business');
            json = json.replaceAll('-number','Number');
            json = json.replaceAll('-report','Report');
            json = json.replaceAll('-name','Name');
            json = json.replaceAll('-status','Status');
            //Deserializing to convert JSON to Apex POJO Object
            return (EquifaxOrgIdSearchParser) System.JSON.deserialize(json, EquifaxOrgIdSearchParser.class);
        }
		catch(Exception ex){
            GenericUtility.insertLog('EquifaxOrgIdSearchParser', ex);
            return null;
        }
	}
}
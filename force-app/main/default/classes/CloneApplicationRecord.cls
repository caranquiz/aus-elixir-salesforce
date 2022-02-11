/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class clone the Application and it's child object.
Development Date : 11/01/2022
Last Modified Date : 10/02/2022
****************************************************************************************************/

global with sharing class CloneApplicationRecord {
    Webservice static String cloneApplication(Id appId,Id cloneAppId){
        try{
            Map<String,Object> parserObjectMap=new Map<String,Object>();
            List<String> childAPIObjectList=new List<String>();
            Map<String,String> childAPIObjectMap=new Map<String,String>();
            Map<String,String> applicationLevelMap=new Map<String,String>();
            List<Sobject> levelThreeCloneObject=new List<Sobject>();
            List<Sobject> levelFourObject=new List<Sobject>();
            List<Sobject> levelFiveObject=new List<Sobject>();
            List<Id> objCollId=new List<Id>();
            List<String> queryList =new List<String>();
            List<Id> objPartyAccountId=new List<Id>();
            Map<Id,String> attchmentPartyMap=new Map<Id,String>();
            CloneApplicationRelatedListParser parserObject=new CloneApplicationRelatedListParser();
            List<Clone_Record_Configuration__c> cloneApplicationRecordList=[SELECT id,
                                                                                Related_Object_List__c,
                                                                                Active__c,
                                                                                Object_Name__c
                                                                            FROM Clone_Record_Configuration__c 
                                                                            WHERE Active__c=True 
                                                                            AND Name=:ConstantValues.APPLICATION_RECORD];
            if(cloneApplicationRecordList.size()>0){
                String jsonInput=cloneApplicationRecordList[0].Related_Object_List__c;
                parserObject=CloneApplicationRelatedListParser.parse(jsonInput);
                applicationLevelMap.put(parserObject.objName,parserObject.objName);
                parserObjectMap.put(parserObject.objName,parserObject.relatedObj);
            }
            while(!applicationLevelMap.isEmpty()){
                for(String applicationLevel :applicationLevelMap.keySet()){
                    if(parserObjectMap.containsKey(applicationLevel) && parserObjectMap.get(applicationLevel)!=Null){
                        List<Object> objList = (List<Object>)(parserObjectMap.get(applicationLevel));
                        for (Object dt : objList) {
                            String str = JSON.serialize(dt);
                            CloneApplicationRelatedListParser obj1=CloneApplicationRelatedListParser.parse(str);
                            if(obj1.relatedObj!=null){
                                parserObjectMap.put(obj1.objName,obj1.relatedObj);
                            }
                            childAPIObjectList.add(obj1.objName);
                            childAPIObjectMap.put(obj1.objName,obj1.Lookup);
                            applicationLevelMap.put(obj1.objName, applicationLevel);
                        }
                    }
                    applicationLevelMap.remove(applicationLevel);
                }
            }
            String queryString='SELECT ';
            for(Schema.FieldSetMember fieldMember : SObjectType.genesis__Applications__c.FieldSets.ApplicationFieldSet.getFields()){
                queryString+=fieldMember.getFieldPath()+',';
            }
            queryString=queryString.removeEnd(',');
            queryString+=' FROM '+parserObject.objName+ ' WHERE id = \''+appId+'\'' ;
            Sobject appt=Database.query(queryString);
            //Cloning the above Application Record acc
            Sobject accCloneCopy  = appt.clone(false, false, false, false);
            accCloneCopy.id=cloneAppId;
            update accCloneCopy;
            List<clcommon__Party__c> objOriginalPartyList=[SELECT id,
                                                                Name,
                                                                clcommon__Account__r.Name 
                                                            FROM clcommon__Party__c 
                                                            WHERE genesis__Application__c=:appId];
            for(clcommon__Party__c objParty : objOriginalPartyList){
                objPartyAccountId.add(objParty.clcommon__Account__c);
            }
            List<clcommon__Party__c> objPartyDeleteList=[SELECT id,
                                                                Name,
                                                                clcommon__Account__r.Name 
                                                            FROM clcommon__Party__c 
                                                            WHERE genesis__Application__c=:cloneAppId
                                                            AND clcommon__Account__c IN: objPartyAccountId];
            if(objPartyDeleteList.size()>0){
                Delete objPartyDeleteList;
            }
            List<clcommon__Collateral__c> objOriginalCollateralList=[SELECT id,
                                                                            name,
                                                                            clcommon__Collateral_Name__c 
                                                                        FROM clcommon__Collateral__c 
                                                                        WHERE id IN (
                                                                                    SELECT genesis__Collateral__c 
                                                                                        FROM genesis__Application_Collateral__c 
                                                                                        WHERE genesis__Application__c=:appId)];
            for(clcommon__Collateral__c objCollateral : objOriginalCollateralList){
                attchmentPartyMap.put(objCollateral.id,objCollateral.clcommon__Collateral_Name__c);
                objCollId.add(objCollateral.id);
            }
            //Clone Level 2 Record
            for(String relatedObject:childAPIObjectList){
                if(childAPIObjectMap.containsKey(relatedObject) && childAPIObjectMap.get(relatedObject)!=NULL){
                    String myString = relatedObject;
                    String whereString=childAPIObjectMap.get(relatedObject);
                    String query = 'SELECT ';
                    Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(myString).getDescribe().fields.getMap();
                    if(myString=='clcommon__Party__c'){
                        for(Schema.FieldSetMember fieldMember : SObjectType.clcommon__Party__c.FieldSets.clonePartyFieldSet.getFields()){
                            query += fieldMember.getFieldPath() + ',';
                        }
                    }else{
                        for(String s : objectFields.keySet()) {
                            query +=  s + ',';
                        }
                    }
                    query=query.removeEnd(',');
                    if(objectFields.containskey(ConstantValues.PARTY_C)){
                        query+=',Party__r.clcommon__Account__c,Party__r.clcommon__Account__r.Name';
                    }
                    if(objectFields.containskey(ConstantValues.Employment_Information_c)){
                        query+=',Employment_Information__r.Name';
                    }
                    if(objectFields.containskey(ConstantValues.ABN_Company_Information_c)){
                        query+=',ABN_Company_Information__r.Employment_Information__r.Name';
                    }
                    if(objectFields.containskey(ConstantValues.ABN_Information_c)){
                        query+=',ABN_Information__r.Employment_Information__r.Name';
                    }
                    if(objectFields.containskey(ConstantValues.genesis_Collateral_c)){
                        query+=',genesis__Collateral__r.clcommon__Collateral_Name__c';
                    }
                    if(objectFields.containskey(ConstantValues.clcommon_Collateral_c)){
                        query+=',clcommon__Collateral__r.clcommon__Collateral_Name__c';
                    }
                    if(myString==ConstantValues.clcommon_Collateral_c || myString==ConstantValues.clcommon_Collateral_Owner_c){
                        String idsString = String.join(new List<Id>(objCollId), '\',\'');
                        query+=' FROM '+myString+' WHERE '+whereString+' IN (\'' + idsString + '\')';
                    }
                    else{
                        query+=' FROM '+myString+' WHERE '+whereString+' = \''+appt.id+'\'';
                    }
                    queryList.add(query);
                }
            }
            recursion(queryList,levelThreeCloneObject,levelFourObject,levelFiveObject);
            cloneChildApplication(levelThreeCloneObject, attchmentPartyMap, accCloneCopy.id);
            childRecordAppClone(levelFourObject,levelFiveObject,appId,accCloneCopy.id);
            
            return ConstantValues.Success;
        }catch(Exception exe){
            GenericUtility.insertLog('CloneApplicationController.doClone', exe);
            return null;
        }
        
    }
    public static void recursion(List<String> queryList,List<Sobject> levelThreeCloneObject,List<Sobject> levelFourObject,List<Sobject> levelFiveObject) {
        if(queryList.size()>0) {  
            List<Sobject> objectList = Database.query(queryList[(queryList.size()-1)]);
            if(objectList.size()>0){
                List<Sobject> cloneObjectList=objectList.deepClone();
                for(Sobject clonedRecord:cloneObjectList){
                    if(!clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.Employment_Information_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Company_Information_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Information_c.toLowerCase())){
                        levelThreeCloneObject.add(clonedRecord);
                    }else if(!clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Company_Information_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Information_c.toLowerCase())){
                        levelFourObject.add(clonedRecord);
                    }else{
                        levelFiveObject.add(clonedRecord);
                    }
                }
            }
            queryList.remove((queryList.size()-1));
            recursion(queryList,levelThreeCloneObject,levelFourObject,levelFiveObject);
        }        
    }
    public static void cloneChildApplication(List<Sobject> childAppRecordList,Map<Id,String> attchmentPartyMap,Id cloneAppId){
        List<Sobject> childApplicationList=new List<Sobject>();
        List<Sobject> childApplicationList2=new List<Sobject>();
        Map<String,Id> objCollateralMap=new Map<String,Id>();
        Map<String,Id> objPartyMap=new Map<String,Id>();

        for(Sobject clonedRecord:childAppRecordList){
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.genesis_Application_c).toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.PARTY_C.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.genesis_Collateral_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.clcommon_Collateral_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.Employment_Information_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Company_Information_c.toLowerCase())
                    && !clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Information_c.toLowerCase())){
                if(clonedRecord.get(ConstantValues.genesis_Application_c) !=null){                                       
                    clonedRecord.put(ConstantValues.genesis_Application_c,cloneAppId);
                }
                childApplicationList.add(clonedRecord);
            }else{
                childApplicationList2.add(clonedRecord);
            }
            
        }
        if(childApplicationList.size()>0){
            Database.insert(childApplicationList,false);
        }
        childApplicationList.clear();
        List<clcommon__Collateral__c> objcloneCollateralList=[SELECT id,
                                                                            name,
                                                                            clcommon__Collateral_Name__c 
                                                                        FROM clcommon__Collateral__c WHERE clcommon__Collateral_Name__c IN: attchmentPartyMap.values()
                                                                        Order by Name ASC];
        for(clcommon__Collateral__c objCollateral : objcloneCollateralList){
            objCollateralMap.put(objCollateral.clcommon__Collateral_Name__c,objCollateral.id);
        }
        List<clcommon__Party__c> objPartyList=[SELECT id,
                                                    Name,
                                                    clcommon__Account__r.Name 
                                                FROM clcommon__Party__c 
                                                WHERE genesis__Application__c=:cloneAppId];
        
        for(clcommon__Party__c objParty : objPartyList){
            objPartyMap.put(objParty.clcommon__Account__r.Name,objParty.id);
        }
        for(Sobject clonedRecord:childApplicationList2){
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.genesis_Application_c).toLowerCase())){
                if(clonedRecord.get(ConstantValues.genesis_Application_c) !=null){                                       
                    clonedRecord.put(ConstantValues.genesis_Application_c,cloneAppId);
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.PARTY_C).toLowerCase())){
                if(clonedRecord.get(ConstantValues.PARTY_C) !=null){                                       
                    String str=String.valueOf(((clonedRecord.getSObject(ConstantValues.PARTY_R)).getSObject(ConstantValues.clcommon_Account_r)).get(ConstantValues.NAME));
                    if(objPartyMap.containskey(str)){
                        clonedRecord.put(ConstantValues.PARTY_C,objPartyMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.genesis_Collateral_c).toLowerCase())){
                if(clonedRecord.get(ConstantValues.genesis_Collateral_c) !=null){                                       
                    String str=String.valueOf((clonedRecord.getSObject(ConstantValues.genesis_Collateral_r)).get(ConstantValues.clcommon_Collateral_Name_c));
                    if(objCollateralMap.containskey(str)){
                        clonedRecord.put(ConstantValues.genesis_Collateral_c,objCollateralMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.clcommon_Collateral_c).toLowerCase())){
                if(clonedRecord.get(ConstantValues.clcommon_Collateral_c) !=null){                                       
                    String str=String.valueOf((clonedRecord.getSObject(ConstantValues.clcommon_Collateral_r)).get(ConstantValues.clcommon_Collateral_Name_c));
                    if(objCollateralMap.containskey(str)){
                        clonedRecord.put(ConstantValues.clcommon_Collateral_c,objCollateralMap.get(str));
                    }
                }
            }
        }
        if(childApplicationList2.size()>0){
            Database.insert(childApplicationList2,false);
        }
        List<genesis__Applications__c> scope=[SELECT Id
                                                    FROM genesis__Applications__c
                                                    WHERE id =: cloneAppId];
        if (scope != null && !scope.isEmpty()) {
            CreateDocumentCategories.createLoanLevelDocFolders(scope);
            CreateDocumentCategories.createReviewDocFolders(scope);
            CreateDocumentCategories.createSecurityDocFolders(scope);
            CreateDocumentCategories.createpartyDocFolders(scope);
            CreateDocumentCategories.createIndividualEmpPartyDocFolders(scope);
            CreateDocumentCategories.createIndentityDocFolders(scope);
            CreateDocumentCategories.createIndividualEmploymentSubFolders(scope);
            CreateDocumentCategories.createNonIndividualEmpIncomeDocFolders(scope);
            CreateDocumentCategories.createHouseholdPartyDocFolders(scope);
        }

    }
    public static void childRecordAppClone(List<Sobject> levelFourObjectList,List<Sobject> levelFiveObjectList,Id appId,Id cloneId){
        List<Id> employmentIdList=new List<Id>();
        Map<String,Id> objEmploymentMap=new Map<String,Id>();
        Map<String,Id> abnCompanyInformationMap=new Map<String,Id>();
        Map<String,Id> abnInformationMap=new Map<String,Id>();
        Map<String,Id> objPartyMap=new Map<String,Id>();

        List<clcommon__Party__c> objPartyList=[SELECT id,
                                                    Name,
                                                    clcommon__Account__r.Name 
                                                FROM clcommon__Party__c 
                                                WHERE genesis__Application__c=:cloneId];
        
        for(clcommon__Party__c objParty : objPartyList){
            objPartyMap.put(objParty.clcommon__Account__r.Name,objParty.id);
        }
        List<genesis__Employment_Information__c> employmentInfList=[SELECT id,
                                                                            Name 
                                                                        FROM genesis__Employment_Information__c 
                                                                        WHERE genesis__Application__c=:cloneId ];
        List<genesis__Employment_Information__c> employmentOriginalList=[SELECT id,
                                                                                Name 
                                                                            FROM genesis__Employment_Information__c
                                                                            WHERE genesis__Application__c=:appId ];
        
        for(genesis__Employment_Information__c objEmployment : employmentOriginalList){
            employmentIdList.add(objEmployment.id);
        }
        for(genesis__Employment_Information__c objEmployment : employmentInfList){
            objEmploymentMap.put(objEmployment.Name,objEmployment.id);
        }
        for(Sobject clonedRecord:levelFourObjectList){
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.genesis_Application_c.toLowerCase())){
                clonedRecord.put(ConstantValues.genesis_Application_c,cloneId);
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.PARTY_C.toLowerCase())){
                if(clonedRecord.get(ConstantValues.PARTY_C) !=null){                                       
                    String str=String.valueOf(((clonedRecord.getSObject(ConstantValues.PARTY_R)).getSObject(ConstantValues.clcommon_Account_r)).get(ConstantValues.NAME));
                    if(objPartyMap.containskey(str)){
                        clonedRecord.put(ConstantValues.PARTY_C,objPartyMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.Employment_Information_c.toLowerCase())){
                if(clonedRecord.get(ConstantValues.Employment_Information_c) !=null){
                    String str=String.valueOf(clonedRecord.getSObject(ConstantValues.Employment_Information_r).get(ConstantValues.NAME));
                    if(objEmploymentMap.containskey(str)){
                        clonedRecord.put(ConstantValues.Employment_Information_c,objEmploymentMap.get(str));
                    }
                }
            }
        }
        if(levelFourObjectList.size()>0){
            Database.insert(levelFourObjectList,false);
        }
        List<ABN_Company_Information__c> abnCompanyInformation=[SELECT id,
                                                                    Employment_Information__r.Name,
                                                                    Name 
                                                                FROM ABN_Company_Information__c 
                                                                WHERE Employment_Information__r.genesis__Application__c =: cloneId ];
        List<ABN_Information__c> abnInformation=[SELECT id,
                                                    Name,
                                                    Employment_Information__r.Name 
                                                FROM ABN_Information__c 
                                                WHERE Employment_Information__r.genesis__Application__c =: cloneId];
        
        for(ABN_Company_Information__c objabnCompany : abnCompanyInformation){
            abnCompanyInformationMap.put(objabnCompany.Employment_Information__r.Name,objabnCompany.id);
        }
        for(ABN_Information__c objabn : abnInformation){
            abnInformationMap.put(objabn.Employment_Information__r.Name,objabn.id);
        }
        for(Sobject clonedRecord:levelFiveObjectList){
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.genesis_Application_c.toLowerCase())){
                clonedRecord.put(ConstantValues.genesis_Application_c,cloneId);
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.PARTY_C.toLowerCase())){
                if(clonedRecord.get(ConstantValues.PARTY_C) !=null){                                       
                    String str=String.valueOf(((clonedRecord.getSObject(ConstantValues.PARTY_R)).getSObject(ConstantValues.clcommon_Account_r)).get(ConstantValues.NAME));
                    if(objPartyMap.containskey(str)){
                        clonedRecord.put(ConstantValues.PARTY_C,objPartyMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.Employment_Information_c.toLowerCase())){
                if(clonedRecord.get(ConstantValues.Employment_Information_c) !=null){
                    String str=String.valueOf(clonedRecord.getSObject(ConstantValues.Employment_Information_r).get(ConstantValues.NAME));
                    if(objEmploymentMap.containskey(str)){
                        clonedRecord.put(ConstantValues.Employment_Information_c,objEmploymentMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains(ConstantValues.ABN_Information_c.toLowerCase())){
                if(clonedRecord.get(ConstantValues.ABN_Information_c) !=null){
                    String str=String.valueOf(((clonedRecord.getSObject(ConstantValues.ABN_Information_r)).getSObject(ConstantValues.Employment_Information_r)).get(ConstantValues.NAME));
                    if(abnInformationMap.containskey(str)){
                        clonedRecord.put(ConstantValues.ABN_Information_c,abnInformationMap.get(str));
                    }
                }
            }
            if(clonedRecord.getSobjectType().getDescribe().fields.getMap().keySet().contains((ConstantValues.ABN_Company_Information_c).toLowerCase())){
                if(clonedRecord.get(ConstantValues.ABN_Company_Information_c) !=null){
                    String str=String.valueOf(((clonedRecord.getSObject(ConstantValues.ABN_Company_Information_r)).getSObject(ConstantValues.Employment_Information_r)).get(ConstantValues.NAME));
                    if(abnCompanyInformationMap.containskey(str)){
                        clonedRecord.put(ConstantValues.ABN_Company_Information_c,abnCompanyInformationMap.get(str));
                    }
                }
            }
            
        }
        if(levelFiveObjectList.size()>0){
            Database.insert(levelFiveObjectList,false);
        }
    }
}
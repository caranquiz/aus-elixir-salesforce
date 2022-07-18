/*********************************************************************************************************
Class Name     : ConvertToContract
Description    : Apex class for converting application to contract throgh conversion mappping
Developer      : Rameswari Barman
Implementation code : genesis__applications__c app = [select id from genesis__applications__c where id = 'XXX'];
                      ConvertToContract.executeFun(app.Id)
**********************************************************************************************************/

global with sharing class ConvertToContract{
    Webservice static String executeFun(Id appId){
        String ret = '';
        //Savepoint is setup over here
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__applications__c app = new genesis__applications__c(id=appId);
            String status = genesis.ConvertApplicationCtrl.convertApplicationToContract(appId);//storing the returned message from product class call
            if(status == System.label.Application_converted_to_Contract_message && Schema.sObjectType.genesis__applications__c.fields.genesis__Status__c.isUpdateable()){
                app.genesis__Status__c = System.label.ApplicationStatusAfterConvertedToContract;
                //updating the status of application
                update app;
                attachValues(appId);
            }
            else{
                Database.rollback(sp);
                if(test.isRunningTest()){
                    Integer a = 4/0;
                }
            }
            ret = status;
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();  
        }
        return ret;
    }
    //This function copies values from application to Contract during conversion
    Webservice static String attachValues(Id appId){
        String ret;
        loan__Bank_Account__c banAcc;
        List<loan__Loan_Account__c> loanAccountList=new List<loan__Loan_Account__c>();
        Savepoint sp=Database.setSavepoint();
        try{
            genesis__Applications__c app = [select id,
                                                Primary_loan_purpose_list__c,
                                                Proposed_repayment_method_list__c,
                                                CL_Contract__c,genesis__Account__c,
                                                genesis__Account__r.Bank_Account_Name__c,
                                                genesis__Account__r.BSB__c,
                                                genesis__Account__r.Bank_Account_Number__c,
                                                CreatedDate
                                            from genesis__Applications__c where Id =: appId];
            if(app.CL_Contract__c != null){
                loan__Loan_Account__c contr = [SELECT id,
                                                    Current_Loan_Balance_Excluding_Deposit__c,
                                                    loan__Payment_Mode__c,
                                                    loan__Loan_Purpose__c,
                                                    loan__Approval_Date__c,
                                                    Original_Total_of_Securities__c,
                                                    Actual_Security_Value__c,
                                                    Current_Total_of_Securities__c,
                                                    Current_Total_of_Discharged_Securities__c,
                                                    Risk_LVR__c,
                                                    MIP_LVR__c
                                                FROM loan__Loan_Account__c 
                                                WHERE id =: app.CL_Contract__c];
                loanAccountList.add(contr);
                collateralValues(appId,contr.id);
                updateClContract(loanAccountList);
                if(app.Proposed_repayment_method_list__c != null){
                    loan__Payment_Mode__c paymentModeId = [select id from loan__Payment_Mode__c where name =: app.Proposed_repayment_method_list__c];
                    contr.loan__Payment_Mode__c = paymentModeId.Id;
                }
                //Checking if loan purpose list is provided in application or not
                if(app.Primary_loan_purpose_list__c != null){
                    loan__Loan_Purpose__c purposeId = [select id from loan__Loan_Purpose__c where name =: app.Primary_loan_purpose_list__c];
                    contr.loan__Loan_Purpose__c = purposeId.Id;
                }
                //Attaching Bank Account
                if(app.genesis__Account__r.Bank_Account_Name__c != null && app.genesis__Account__r.BSB__c != null && app.genesis__Account__r.Bank_Account_Number__c != null){
                    banAcc = new loan__Bank_Account__c();
                    banAcc.loan__Bank_Account_Number__c = app.genesis__Account__r.Bank_Account_Number__c;
                    banAcc.BSB_Number__c = app.genesis__Account__r.BSB__c;
                    banAcc.Bank_Account_Name__c = app.genesis__Account__r.Bank_Account_Name__c;
                    banAcc.loan__Active__c = true;
                    banAcc.loan__Account_Usage__c = System.label.Borrower_Bank_Account_Type;
                    banAcc.loan__Bank_Name__c = app.genesis__Account__r.BSB__c;
                    banAcc.loan__Account__c = app.genesis__Account__c;
                    banAcc.Created_After_Conversion__c = true;
                    if(banAcc != null){
                        insert banAcc;
                        //contr.loan__Borrower_ACH__c = banAcc.Id;
                        contr.Borrower_ACH_Change__c = banAcc.Id;
                    }
                }
                //Change made by Rameswari on 24/12/2020
                //Attaching Application Date
                DateTime appCreationDate = app.CreatedDate;
                contr.loan__Application_Date__c = date.newInstance(appCreationDate.year() ,appCreationDate.month(), appCreationDate.day());
                
                if(contr != null 
                    && (app.Proposed_repayment_method_list__c != null
                    || app.Primary_loan_purpose_list__c != null 
                    || banAcc!=null 
                    || appCreationDate != null)){
                    update contr;
                }
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'ConvertToContract :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            ret = e.getMessage();  
        }
        return ret;
    }
    //This function copies Collateral values from application collaral to Loan Contract during conversion
    Webservice static void collateralValues(Id appId,Id loanId){
        try{
            List<loan__Loan_Collateral__c> loanCollateralList=new List<loan__Loan_Collateral__c>();
            String queryString = 'SELECT ';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('clcommon__Collateral__c').getDescribe().fields.getMap();
            for(String s : objectFields.keySet()) {
                queryString +=  s + ',';
            }
            queryString=queryString.removeEnd(',');
            queryString +=' FROM clcommon__Collateral__c WHERE id IN (SELECT genesis__Collateral__c FROM genesis__Application_Collateral__c WHERE genesis__Application__c=\''+ appId+'\')';
            List<clcommon__Collateral__c> collateralList=Database.query(queryString);
            List<clcommon__Collateral_Owner__c> collateralOwnerList=[SELECT id,
                                                                        clcommon__Collateral__c,
                                                                        clcommon__Collateral__r.Full_Address__c,
                                                                        Loan_Collateral__c 
                                                                    FROM clcommon__Collateral_Owner__c 
                                                                    WHERE clcommon__Collateral__c IN (SELECT genesis__Collateral__c 
                                                                    FROM genesis__Application_Collateral__c 
                                                                    WHERE genesis__Application__c=: appId)];
            for(clcommon__Collateral__c collateral:collateralList){
                loan__Loan_Collateral__c loanCollateral=new loan__Loan_Collateral__c();
                loanCollateral.loan__Loan__c=loanId;
                loanCollateral.Unit_No__c=collateral.Unit_No__c;
                loanCollateral.Suburb__c=collateral.clcommon__City__c;
                loanCollateral.Street_Type__c=collateral.Street_Type__c;
                loanCollateral.Street_No__c=collateral.Street_No__c;
                loanCollateral.Street_Name__c=collateral.Street_Name__c;
                loanCollateral.State__c=collateral.clcommon__State__c;
                loanCollateral.Postal_Code__c=collateral.clcommon__Postal_Code__c;
                loanCollateral.Country__c=collateral.Country__c;
                loanCollateral.Rural_Usage_List__c=collateral.Rural_Usage_List__c;

                loanCollateral.Security_Address__c=collateral.Full_Address__c;
                loanCollateral.Primary_Usage__c=collateral.Primary_Usage__c;
                loanCollateral.Property_Insurance_Cover_Type__c=collateral.Cover_Type__c;
                loanCollateral.Status__c=collateral.clcommon__Status__c;
                loanCollateral.Primary_Security__c=collateral.Primary_Security__c;
                loanCollateral.S_P_Location__c=collateral.S_P_Location__c;
                loanCollateral.QBE_Location__c=collateral.QBE_Location__c;
                loanCollateral.Property_Type__c=collateral.Type__c;
                loanCollateral.Primary_Purpose__c=collateral.Primary_Purpose__c;
                loanCollateral.Energy_Rating__c=collateral.Energy_Rating__c;
                loanCollateral.Floor_Area__c=collateral.Floor_Area__c;
                loanCollateral.Folio__c=collateral.Title_Folio__c;
                loanCollateral.Land_Area__c=collateral.Land_Area__c;
                loanCollateral.Land_Area_Units__c=collateral.Land_Area_Units__c;
                loanCollateral.Original_Valuation_Date__c=collateral.clcommon__Value_Date__c;
                loanCollateral.Original_Value__c=collateral.clcommon__Value__c;
                loanCollateral.Original_Valuer__c=collateral.Valuer__c;
                loanCollateral.Current_Valuation_Date__c=collateral.clcommon__Value_Date__c;
                loanCollateral.Current_Value__c=collateral.clcommon__Value__c;
                loanCollateral.Current_Valuer__c=collateral.Valuer__c;
                loanCollateral.Plan__c=collateral.Title_Plan__c;
                loanCollateral.Property_Insurance_Expiry_Date__c=collateral.Home_Insurance_Certificate_Expiry_Date__c;
                loanCollateral.Property_Insurance_Interested_Party__c=collateral.Interested_Party__c;
                loanCollateral.Property_Insurance_Policy_Number__c=collateral.clcommon__Policy_Number__c;
                loanCollateral.Property_Insurer_Name__c=collateral.Insurer_Name__c;
                loanCollateral.Tenure_Type__c=collateral.Title_Tenure_Type__c;
                loanCollateral.Title_Reference__c=collateral.Title_Reference__c;
                loanCollateral.Title_System__c=collateral.Title_System__c;
                loanCollateral.Volume__c=collateral.Title_Volume__c;
                loanCollateral.Lot__c=collateral.Title_Lot__c;
                loanCollateral.Created_after_conversion__c=true;
                loanCollateralList.add(loanCollateral);
            }
            if(loanCollateralList.size()>0){
                Database.insert(loanCollateralList,false);
            }
            List<loan__Loan_Collateral__c> objloanCollateralList=[SELECT id,
                                                                        loan__Loan__c,
                                                                        loan__Loan__r.id,
                                                                        Security_Address__c
                                                                    FROM loan__Loan_Collateral__c 
                                                                    WHERE loan__Loan__c =: loanId];
            for(loan__Loan_Collateral__c objloanCollateral:objloanCollateralList){
                for(clcommon__Collateral_Owner__c collateralOwner:collateralOwnerList){
                    if(objloanCollateral.Security_Address__c!=NULL && collateralOwner.clcommon__Collateral__c!=NULL
                            && collateralOwner.clcommon__Collateral__r.Full_Address__c!=NULL
                            && objloanCollateral.Security_Address__c==collateralOwner.clcommon__Collateral__r.Full_Address__c){
                        collateralOwner.Loan_Collateral__c=objloanCollateral.id;
                    }
                }
            }
            if(collateralOwnerList.size()>0){
                Database.update(collateralOwnerList,false);
            }
        }catch(Exception exe){
            GenericUtility.insertBatchProcessLog('ConvertToContract',exe);
        }
    }
    global static void updateClContract(List <loan__Loan_Account__c> loanAccountList){
        try{
            Map<Id,Integer> countMap=New Map<Id,Integer>();
            Map<Id,Integer> countOriginalMap=New Map<Id,Integer>();
            Map<Id,Integer> countDischargedMap=New Map<Id,Integer>();
            Map<Id,Decimal> mipValueMap=New Map<Id,Decimal>();
            Map<Id,Decimal> riskValueMap=New Map<Id,Decimal>();
            //Querying out locations from Custom settings
            List <QBEpostCode__c> qbeList = [Select Id,
                                                PostCode_High_RangeNumber__c,
                                                PostCode_Low_RangeNumber__c,
                                                Location__c
                                                From QBEpostCode__c
                                                LIMIT 1000
                                            ];
            List <S_P_Postcode__c> sAndPList = [Select Id,
                                                PostCode_High_RangeNumber__c,
                                                PostCode_Low_RangeNumber__c,
                                                Location__c
                                                From S_P_Postcode__c
                                                LIMIT 1000
                                            ];
            List<loan__Loan_Collateral__c> loanCollateralList=[SELECT id,
                                                                        loan__Loan__c,
                                                                        loan__Loan__r.id,
                                                                        Original_Value__c,
                                                                        MIP_Value__c,
                                                                        Risk_Value__c,
                                                                        Postal_Code__c,
                                                                        S_P_Location__c,
                                                                        QBE_Location__c,
                                                                        Primary_Security__c,
                                                                        Security_Status__c,
                                                                        Created_after_conversion__c
                                                                    FROM loan__Loan_Collateral__c 
                                                                    WHERE loan__Loan__c in: loanAccountList];
            for(loan__Loan_Account__c loanAccount:loanAccountList){
                countMap.put(loanAccount.id, 0);
                countDischargedMap.put(loanAccount.id, 0);
                mipValueMap.put(loanAccount.id, 0.0);
                riskValueMap.put(loanAccount.id, 0.0);
                countOriginalMap.put(loanAccount.id, 0);
            }
            for(loan__Loan_Collateral__c loanCollateral:loanCollateralList){
                countMap.put(loanCollateral.loan__Loan__r.id,countMap.get(loanCollateral.loan__Loan__r.id)+1);
                if(loanCollateral.Created_after_conversion__c==true){
                    countOriginalMap.put(loanCollateral.loan__Loan__r.id,countOriginalMap.get(loanCollateral.loan__Loan__r.id)+1);
                }
                if(loanCollateral.Security_Status__c==ConstantValues.DISCHARGED){
                    countDischargedMap.put(loanCollateral.loan__Loan__r.id,countDischargedMap.get(loanCollateral.loan__Loan__r.id)+1);
                }
                if(loanCollateral.MIP_Value__c!=NULL){
                    mipValueMap.put(loanCollateral.loan__Loan__r.id,mipValueMap.get(loanCollateral.loan__Loan__r.id)+loanCollateral.MIP_Value__c);
                }
                if(loanCollateral.Risk_Value__c!=NULL){
                    riskValueMap.put(loanCollateral.loan__Loan__r.id,riskValueMap.get(loanCollateral.loan__Loan__r.id)+loanCollateral.Risk_Value__c);
                }
            }
            for(loan__Loan_Account__c loanAccount:loanAccountList){
                if(mipValueMap.containsKey(loanAccount.id) 
                        && mipValueMap.get(loanAccount.id) !=NULL 
                        && mipValueMap.get(loanAccount.id) !=0.0){
                    loanAccount.MIP_LVR__c=(loanAccount.Current_Loan_Balance_Excluding_Deposit__c/mipValueMap.get(loanAccount.id))*100;
                }
                if(riskValueMap.containsKey(loanAccount.id) 
                        && riskValueMap.get(loanAccount.id) !=NULL 
                        && riskValueMap.get(loanAccount.id) !=0.0){
                    loanAccount.Risk_LVR__c=(loanAccount.Current_Loan_Balance_Excluding_Deposit__c/riskValueMap.get(loanAccount.id))*100;
                }
                if(countOriginalMap.containsKey(loanAccount.id) 
                        && countOriginalMap.get(loanAccount.id) !=NULL){
                    loanAccount.Original_Total_of_Securities__c=countOriginalMap.get(loanAccount.id);
                }
                if(countMap.containsKey(loanAccount.id) 
                        && countMap.get(loanAccount.id) !=NULL && countDischargedMap.containsKey(loanAccount.id) 
                        && countDischargedMap.get(loanAccount.id) !=NULL ){
                    loanAccount.Current_Total_of_Securities__c=countMap.get(loanAccount.id)-countDischargedMap.get(loanAccount.id);
                }
                if(countDischargedMap.containsKey(loanAccount.id) 
                        && countDischargedMap.get(loanAccount.id) !=NULL){
                    loanAccount.Current_Total_of_Discharged_Securities__c=countDischargedMap.get(loanAccount.id);
                }
            }
            Integer count=0;
            for(loan__Loan_Collateral__c loanCollateral:loanCollateralList){
                if(countMap.containsKey(loanCollateral.loan__Loan__r.id) 
                        && countMap.get(loanCollateral.loan__Loan__r.id) !=NULL && countMap.get(loanCollateral.loan__Loan__r.id)>1){
                    if(loanCollateral.Security_Status__c==ConstantValues.DISCHARGED){
                        loanCollateral.Primary_Security__c=ConstantValues.NO_TAG;
                    }else if( loanCollateral.Security_Status__c !=ConstantValues.DISCHARGED &&  loanCollateral.Primary_Security__c==ConstantValues.NO_TAG){
                        count+=1;
                    }
                }
                if(loanCollateral.Postal_Code__c != NULL && loanCollateral.Postal_Code__c != ''){
                    loanCollateral.QBE_Location__c = ConstantValues.CATEGORY_3_OR_4;
                    for(QBEpostCode__c qbe : qbeList){
                        if(qbe.PostCode_High_RangeNumber__c >= Decimal.ValueOf(loanCollateral.Postal_Code__c)
                                && qbe.PostCode_Low_RangeNumber__c <= Decimal.ValueOf(loanCollateral.Postal_Code__c)){
                                loanCollateral.QBE_Location__c = qbe.Location__c;
                            break;
                        }
                    }
                    loanCollateral.S_P_Location__c = '';
                    for(S_P_Postcode__c sp : sAndPList){
                        if(sp.PostCode_High_RangeNumber__c >= Decimal.ValueOf(loanCollateral.Postal_Code__c)
                                && sp.PostCode_Low_RangeNumber__c <= Decimal.ValueOf(loanCollateral.Postal_Code__c)){
                                loanCollateral.S_P_Location__c = sp.Location__c;
                            break;
                        }
                    }
                }
            }
            for(loan__Loan_Collateral__c loanCollateral:loanCollateralList){
                if(countMap.containsKey(loanCollateral.loan__Loan__r.id) 
                        && countMap.get(loanCollateral.loan__Loan__r.id) !=NULL && countMap.get(loanCollateral.loan__Loan__r.id)>1
                        && count>0
                        && (countMap.get(loanCollateral.loan__Loan__r.id)-countDischargedMap.get(loanCollateral.loan__Loan__r.id))==count
                        && loanCollateral.Security_Status__c!=ConstantValues.DISCHARGED){
                    loanCollateral.Primary_Security__c=ConstantValues.YES_TAG;
                    break;
                }
            }    
            if(loanAccountList.size()>0){
                Database.update(loanAccountList,false);
            }
            if(loanCollateralList.size()>0){
                Database.update(loanCollateralList,false);
            }
        }catch(Exception e){
            GenericUtility.insertBatchProcessLog('ConvertToContract',e);
        }
    }
    
}
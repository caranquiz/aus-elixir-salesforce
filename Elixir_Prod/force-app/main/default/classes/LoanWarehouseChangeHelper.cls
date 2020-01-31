/***********************************************************************************************************************
Class Name -            LoanWarehouseChangeHelper
Developer -             Rameswari Barman
Purpose -               When a record in Loan Warehouse junction is insserted through the object trigger this particular class is called.
                        With the help of this class, values in the records of junction object is updated. 
                        The newly inserted record value is changed to Active and all the existing application/contract loan warehouse record status is changed to Inactive.
                        Also the warehouse atttached in CL Contract gets updated.
Implementation Code:    genesis__applications__c app = [select id from genesis__applications__c where id = 'XXX'];
                        Warehouse__c ware = [select id from Warehouse__c where id = 'XXX'];
                        Loan_Warehouse__c loanWarehouse1 = ElixirTestHelper.returnLoanWarehouse(ware.Id,app.Id);
                        loanWarehouse1.Active__c = true;
                        insert loanWarehouse1;
***********************************************************************************************************************/

global class LoanWarehouseChangeHelper {
    global static void changeActive(List <ID> exID, List <Id> loanWHList){
        //This method helps in changing the existing status of the loan warehouse records to inactive
        List<Loan_Warehouse__c> whList = new List<Loan_Warehouse__c> ();
        List<Loan_Warehouse__c> warehouseList = new List<Loan_Warehouse__c>();
        Savepoint sp=Database.setSavepoint();
        try{
            if(loanWHList != null && loanWHList.size() > 0 && exID != null && exID.size() > 0){
                //Selecting the currently active loan warehouse records
                whList = [SELECT Id,
                                 Active__c,
                                 Application__c 
                                 FROM Loan_Warehouse__c
                                 WHERE Id NOT IN : loanWHList 
                                 AND Application__c IN : exID
                                 AND Active__c = true
                           ];
                //Deactivating all the previous loan warehouse records so that at a moment for a particular application only 1 loan warehouse record is active
                if(whList!=null && whList.size() > 0){
                    for(Loan_Warehouse__c eachWarehouse : whList){
                        eachWarehouse.Active__c = false;
                        warehouseList.add(eachWarehouse);
                    }
                    if(warehouseList != null && warehouseList.size() > 0 && Schema.sObjectType.Loan_Warehouse__c.fields.Active__c.isUpdateable()){
                        update warehouseList;
                    }
                }
            }
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanWarehouseChangeHelper :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
        }
    }
    global static void loanWarehouse(List <Loan_Warehouse__c> newList){
        //This method helps in updating the loan record values and also updates the new warehouse funder in CL Contract when warehouse is changed
        List<Loan_Warehouse__c> listRecLoanWare = [select id,
                                                          Warehouse__c,
                                                          Application__c,
                                                          Balance_Outstanding__c,
                                                          Loan_Warehouse_Number__c,
                                                          Application__r.CL_Contract__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Balance__c,
                                                          Application__r.CL_Contract__r.loan__Interest_Accrued_Not_Due__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Status__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Amount__c,
                                                          Application__r.genesis__Loan_Amount__c,
                                                          Application__r.CL_Contract__r.loan__Pay_Off_Amount_As_Of_Today__c,
                                                          Application__r.genesis__CL_Product_Name__c,
                                                          Application__r.genesis__Initial_Advance__c,
                                                          Application__r.First_Tranche_Prepaid_Interest__c
                                                          from Loan_Warehouse__c 
                                                          where id =: newList
                                                    ]; 
        List<Loan_Warehouse__c> listActiveWH = [select id,
                                                       Active__c,
                                                       Application__c,
                                                       Warehouse__c 
                                                       from Loan_Warehouse__c
                                                       where Active__c = true
                                                ];
        Map<Id,Id> prevId = new Map<Id,Id>();
        List<Id> appId = new List<Id>();
        List<Id> loanWarehouseIds = new List<Id>();
        List<Loan_Warehouse__c> newRecords = new List<Loan_Warehouse__c>();
        Savepoint sp=Database.setSavepoint();
        try{
            //Generating list to which stores the previously active loan warehouse
            if(listActiveWH != null && listActiveWH.size() > 0){
                for(Loan_Warehouse__c lh : listActiveWH){
                    prevId.put(lh.Application__c,lh.Warehouse__c);
                }
            }
            if(listRecLoanWare != null && listRecLoanWare.size() > 0){
                for(Loan_Warehouse__c objLoanWh : listRecLoanWare){
                    objLoanWh.Active__c = true;
                    objLoanWh.Changed_Time__c = (Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
                    objLoanWh.Previous_Warehouse__c = prevId.get(objLoanWh.Application__c);
                    objLoanWh.CL_Contract__c = objLoanWh.Application__r.CL_Contract__c;
                    objLoanWh.Name = objLoanWh.Loan_Warehouse_Number__c;
                    if(objLoanWh.Application__r.CL_Contract__c != null){
                        loan__Loan_Account__c obj = new loan__Loan_Account__c(id=objLoanWh.Application__r.CL_Contract__c);
                        if(obj != null && objLoanWh.Warehouse__c != null){
                            obj.Warehouse__c = objLoanWh.Warehouse__c;
                            update obj;
                        }
                        
                    }
                    if(objLoanWh.CL_Contract__c != NULL && objLoanWh.Application__r.genesis__CL_Product_Name__c != System.label.Construction_Development && objLoanWh.Application__r.genesis__CL_Product_Name__c != System.label.Residential_Construction){
                        objLoanWh.Balance_Outstanding__c =( (objLoanWh.Application__r.CL_Contract__r.loan__Pay_Off_Amount_As_Of_Today__c != NULL && objLoanWh.Application__r.CL_Contract__r.loan__Loan_Status__c != ConstantValues.Approved) ? (objLoanWh.Application__r.CL_Contract__r.loan__Pay_Off_Amount_As_Of_Today__c) : (objLoanWh.Application__r.CL_Contract__r.loan__Loan_Amount__c) );
                    }
                    else if(objLoanWh.CL_Contract__c != NULL && (objLoanWh.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || objLoanWh.Application__r.genesis__CL_Product_Name__c == System.label.Residential_Construction)){
                        objLoanWh.Balance_Outstanding__c = objLoanWh.Balance_Outstanding__c =((objLoanWh.Application__r.CL_Contract__r.loan__Pay_Off_Amount_As_Of_Today__c != NULL && objLoanWh.Application__r.CL_Contract__r.loan__Loan_Status__c != ConstantValues.Approved) ? (objLoanWh.Application__r.CL_Contract__r.loan__Pay_Off_Amount_As_Of_Today__c) : ((objLoanWh.Application__r.genesis__Initial_Advance__c != NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c != NULL) ? (objLoanWh.Application__r.genesis__Initial_Advance__c+objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c):((objLoanWh.Application__r.genesis__Initial_Advance__c == NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c == NULL) ? 0 :((objLoanWh.Application__r.genesis__Initial_Advance__c != NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c == NULL) ? (objLoanWh.Application__r.genesis__Initial_Advance__c):(objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c)))));
                    }    
                    else if(objLoanWh.CL_Contract__c == NULL && objLoanWh.Application__r.genesis__CL_Product_Name__c != System.label.Construction_Development && objLoanWh.Application__r.genesis__CL_Product_Name__c != System.label.Residential_Construction){
                        objLoanWh.Balance_Outstanding__c = objLoanWh.Application__r.genesis__Loan_Amount__c;
                    }
                    else if(objLoanWh.CL_Contract__c == NULL && (objLoanWh.Application__r.genesis__CL_Product_Name__c == System.label.Construction_Development || objLoanWh.Application__r.genesis__CL_Product_Name__c == System.label.Residential_Construction)){
                        objLoanWh.Balance_Outstanding__c = ((objLoanWh.Application__r.genesis__Initial_Advance__c != NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c != NULL) ? (objLoanWh.Application__r.genesis__Initial_Advance__c+objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c):((objLoanWh.Application__r.genesis__Initial_Advance__c == NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c == NULL) ? 0 :((objLoanWh.Application__r.genesis__Initial_Advance__c != NULL && objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c == NULL) ? (objLoanWh.Application__r.genesis__Initial_Advance__c):(objLoanWh.Application__r.First_Tranche_Prepaid_Interest__c))));
                    }
                    else{
                        objLoanWh.Balance_Outstanding__c = 0;
                    }
                    newRecords.add(objLoanWh);
                    appId.add(objLoanWh.Application__c);
                    loanWarehouseIds.add(objLoanWh.Id);
                }
            }
            if(newRecords != null && newRecords.size() > 0){
                update newRecords;
            }
            changeActive(appId,loanWarehouseIds);
        }
        catch(Exception e){
            Database.rollback(sp);
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanWarehouseChangeHelper :'+e.getStackTraceString()+':Error::'+e.getMessage()+' at Line Number '+e.getLineNumber(), clcommon__Timestamp__c = 
                                                    System.Now(),clcommon__Log_Level__c = 'ERROR');  
        }
    }
}
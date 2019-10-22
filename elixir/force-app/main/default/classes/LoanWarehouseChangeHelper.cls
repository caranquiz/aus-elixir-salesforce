/***********************************************************************************************************************
Class Name - LoanWarehouseChangeHelper
Developer - Rameswari Barman
Purpose - When a record in Loan Warehouse junction is insserted through the object trigger this particular class is called.
          With the help of this class, values in the records of junction object is updated. 
          The newly inserted record value is changed to Active and all the existing application/contract loan warehouse record status is changed to Inactive.
          Also the warehouse atttached in CL Contract gets updated.
***********************************************************************************************************************/

global class LoanWarehouseChangeHelper{
    global static void changeActive(List <ID> exID, List <Id> loanWHList){
        //This method helps in changing the existing status of the loan warehouse records to inactive
        List<Loan_Warehouse__c> whList = new List<Loan_Warehouse__c> ();
        List<Loan_Warehouse__c> warehouseList = new List<Loan_Warehouse__c>();
        Savepoint sp=Database.setSavepoint();
        try{
            if(loanWHList != null && loanWHList.size() > 0 && exID != null && exID.size() > 0){
                whList = [SELECT Id,
                                 Active__c,
                                 Application__c 
                                 FROM Loan_Warehouse__c
                                 WHERE Id NOT IN : loanWHList 
                                 AND Application__c IN : exID
                                 AND Active__c = true
                           ];
                if(whList!=null && whList.size() > 0){
                    for(Loan_Warehouse__c eachWarehouse : whList){
                        eachWarehouse.Active__c = false;
                        warehouseList.add(eachWarehouse);
                    }
                    if(warehouseList != null && warehouseList.size() > 0){
                        update warehouseList;
                    }
                }
            }
        }
        catch(Exception e){
            insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanWarehouseChangeHelper :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = 
                                                  System.Now(),clcommon__Log_Level__c = 'ERROR'); 
            Database.rollback(sp);
        }
    }
    global static void loanWarehouse(List <Loan_Warehouse__c> newList){
        //This method helps in updating the loan record values and also updates the new warehouse funder in CL Contract when warehouse is changed
        System.debug('Test 1');
        List<Loan_Warehouse__c> listRecLoanWare = [select id,
                                                          Warehouse__c,
                                                          Application__c,
                                                          Balance_Outstanding__c,
                                                          Loan_Warehouse_Number__c,
                                                          Application__r.CL_Contract__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Balance__c,
                                                          Application__r.CL_Contract__r.loan__Interest_Accrued_Not_Due__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Status__c,
                                                          Application__r.CL_Contract__r.loan__Loan_Amount__c
                                                           
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
        List<loan__Loan_Account__c> loanList = new List<loan__Loan_Account__c>();
        Map<Id,Id> prevId = new Map<Id,Id>();
        List<Id> appId = new List<Id>();
        List<Id> loanWarehouseIds = new List<Id>();
        List<Loan_Warehouse__c> newRecords = new List<Loan_Warehouse__c>();
        Savepoint sp=Database.setSavepoint();
        try{
            if(listActiveWH != null && listActiveWH.size() > 0){
                for(Loan_Warehouse__c lh : listActiveWH){
                    prevId.put(lh.Application__c,lh.Warehouse__c);
                    System.debug('Test 2');
                }
            }
            if(listRecLoanWare != null && listRecLoanWare.size() > 0){
                for(Loan_Warehouse__c objLoanWh : listRecLoanWare){
                    System.debug(objLoanWh);
                    objLoanWh.Active__c = true;
                    objLoanWh.Changed_Time__c = (Test.isRunningTest()?Date.Today():(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate());
                    objLoanWh.Previous_Warehouse__c = prevId.get(objLoanWh.Application__c);
                    objLoanWh.CL_Contract__c = objLoanWh.Application__r.CL_Contract__c;
                    objLoanWh.Name = objLoanWh.Loan_Warehouse_Number__c;
                    if(objLoanWh.Application__r.CL_Contract__c != null){
                        loan__Loan_Account__c obj = new loan__Loan_Account__c(id=objLoanWh.Application__r.CL_Contract__c);
                        obj.Warehouse__c = objLoanWh.Warehouse__c;
                        System.debug('Test 3');
                    }
                        System.debug('====objLoanWh.CL_Contract__c====='+objLoanWh.CL_Contract__c);
                    if(objLoanWh.CL_Contract__c != NULL){
                        System.debug('====objLoanWh.Balance_Outstanding__c===='+objLoanWh.Balance_Outstanding__c);
                        System.debug('====objLoanWh.Application__r.CL_Contract__r.loan__Loan_Balance__c======'+objLoanWh.Application__r.CL_Contract__r.loan__Loan_Balance__c);
                        System.debug('=====objLoanWh.Application__r.CL_Contract__r.loan__Interest_Accrued_Not_Due__c===='+objLoanWh.Application__r.CL_Contract__r.loan__Interest_Accrued_Not_Due__c);
                        
                        objLoanWh.Balance_Outstanding__c =( (objLoanWh.Application__r.CL_Contract__r.loan__Loan_Balance__c != NULL && objLoanWh.Application__r.CL_Contract__r.loan__Loan_Status__c != 'Approved') ? (objLoanWh.Application__r.CL_Contract__r.loan__Loan_Balance__c) : (objLoanWh.Application__r.CL_Contract__r.loan__Loan_Amount__c) )+ objLoanWh.Application__r.CL_Contract__r.loan__Interest_Accrued_Not_Due__c;
                        
                    }
                    newRecords.add(objLoanWh);
                    appId.add(objLoanWh.Application__c);
                    loanWarehouseIds.add(objLoanWh.Id);
                    System.debug('Test 4');
                }
            }
            if(newRecords != null && newRecords.size() > 0){
                System.debug('Test 5');
                update newRecords;
            }
            if(loanList != null && loanList.size() > 0){
                System.debug('Test 6');
                update loanList;
            }
            changeActive(appId,loanWarehouseIds);
            }
            catch(Exception e){
                insert new clcommon__Batch_Process_Log__c(clcommon__Message__c = 'LoanWarehouseChangeHelper :'+e.getStackTraceString()+':Error::'+e.getMessage(), clcommon__Timestamp__c = 
                                                      System.Now(),clcommon__Log_Level__c = 'ERROR'); 
                Database.rollback(sp);
                System.debug(e.getMessage());
                
            }
        }
}
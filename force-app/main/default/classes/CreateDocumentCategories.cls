public with sharing class CreateDocumentCategories {
    public static void createLoanLevelDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Category_Name__c ='Application Documents' AND
                                                                        clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Category__c eachParentDocCategory : parentDocCategoryList){
            appParentDocCategoryMap.put(eachParentDocCategory.genesis__Application__c, eachParentDocCategory.Id);
        }
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Loan Details',:'Serviceability',:'Review Documents')
                                                                        ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = NULL;
            for(Id appId : appIds){
                parentDocId = appParentDocCategoryMap.get(appId);
                if(parentDocId != NULL && parentDocDefinitionList.size() > 0){
                    if(docDefinitionMap.get('Loan Details') != NULL){
                        clcommon__Document_Category__c docCategoryloanDetails = new clcommon__Document_Category__c();
                        docCategoryloanDetails.clcommon__Category_Name__c = 'Loan Details';
                        docCategoryloanDetails.clcommon__Active__c = true;
                        docCategoryloanDetails.genesis__Application__c = appId;
                        docCategoryloanDetails.clcommon__Priority__c = 'Normal';
                        docCategoryloanDetails.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryloanDetails.clcommon__Required__c = true;
                        docCategoryloanDetails.clcommon__Document_Definition__c = docDefinitionMap.get('Loan Details');
                        docCategoryList.add(docCategoryloanDetails);
                    }
                    if(docDefinitionMap.get('Serviceability') != NULL){
                        clcommon__Document_Category__c docCategoryServiceability = new clcommon__Document_Category__c();
                        docCategoryServiceability.clcommon__Category_Name__c = 'Serviceability';
                        docCategoryServiceability.clcommon__Active__c = true;
                        docCategoryServiceability.genesis__Application__c = appId;
                        docCategoryServiceability.clcommon__Priority__c = 'Normal';
                        docCategoryServiceability.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryServiceability.clcommon__Required__c = true;
                        docCategoryServiceability.clcommon__Document_Definition__c = docDefinitionMap.get('Serviceability');
                        docCategoryList.add(docCategoryServiceability);
                    }
                    if(docDefinitionMap.get('Serviceability') != NULL){
                        clcommon__Document_Category__c docCategoryReview = new clcommon__Document_Category__c();
                        docCategoryReview.clcommon__Category_Name__c = 'Review Documents';
                        docCategoryReview.clcommon__Active__c = true;
                        docCategoryReview.genesis__Application__c = appId;
                        docCategoryReview.clcommon__Priority__c = 'Normal';
                        docCategoryReview.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryReview.clcommon__Required__c = true;
                        docCategoryReview.clcommon__Document_Definition__c = docDefinitionMap.get('Review Documents');
                        docCategoryList.add(docCategoryReview);
                    }
                    parentDocId = NULL;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createReviewDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<String,Id> appParentDocCategoryMap = new Map<String,Id>();
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Category_Name__c ='Review Documents' AND
                                                                        clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds
                                                                    ];
        for(clcommon__Document_Category__c eachParentDocCategory : parentDocCategoryList){
            appParentDocCategoryMap.put(eachParentDocCategory.genesis__Application__c, eachParentDocCategory.Id);
        }
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Exception Documents',
                                                                            :'Condition Documents',
                                                                            :'Warning Documents')
                                                                        ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = NULL;
            for(Id appId : appIds){
                parentDocId = appParentDocCategoryMap.get(appId);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Warning Documents') != NULL){
                        clcommon__Document_Category__c docCategoryWarning = new clcommon__Document_Category__c();
                        docCategoryWarning.clcommon__Category_Name__c = 'Warning Documents';
                        docCategoryWarning.clcommon__Active__c = true;
                        docCategoryWarning.genesis__Application__c = appId;
                        docCategoryWarning.clcommon__Priority__c = 'Normal';
                        docCategoryWarning.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryWarning.clcommon__Required__c = true;
                        docCategoryWarning.clcommon__Document_Definition__c = docDefinitionMap.get('Warning Documents');
                        docCategoryList.add(docCategoryWarning);
                    }
                    if(docDefinitionMap.get('Exception Documents') != NULL){
                        clcommon__Document_Category__c docCategoryException = new clcommon__Document_Category__c();
                        docCategoryException.clcommon__Category_Name__c = 'Exception Documents';
                        docCategoryException.clcommon__Active__c = true;
                        docCategoryException.genesis__Application__c = appId;
                        docCategoryException.clcommon__Priority__c = 'Normal';
                        docCategoryException.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryException.clcommon__Required__c = true;
                        docCategoryException.clcommon__Document_Definition__c = docDefinitionMap.get('Exception Documents');
                        docCategoryList.add(docCategoryException); 
                    }
                    if(docDefinitionMap.get('Condition Documents') != NULL){
                        clcommon__Document_Category__c docCategoryCondition = new clcommon__Document_Category__c();
                        docCategoryCondition.clcommon__Category_Name__c = 'Condition Documents';
                        docCategoryCondition.clcommon__Active__c = true;
                        docCategoryCondition.genesis__Application__c = appId;
                        docCategoryCondition.clcommon__Priority__c = 'Normal';
                        docCategoryCondition.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryCondition.clcommon__Required__c = true;
                        docCategoryCondition.clcommon__Document_Definition__c = docDefinitionMap.get('Condition Documents');
                        docCategoryList.add(docCategoryCondition);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createSecurityDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        Map<Id,Id> appCollaterMap =  new Map<Id,Id>(); 
        List <genesis__Application_Collateral__c>  appCollateralList = [SELECT Id,
                                                                            genesis__Application__c,
                                                                            genesis__Collateral__c
                                                                            FROM genesis__Application_Collateral__c
                                                                            WHERE genesis__Application__c =: appIds];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                                Name
                                                                                FROM clcommon__Document_Definition__c
                                                                                WHERE Name = 'Security Documents'
                                                                                LIMIT 1];
        List <Id> securityIds = new List<Id>();
        for(genesis__Application_Collateral__c eachAppCollateral : appCollateralList){
            securityIds.add(eachAppCollateral.genesis__Collateral__c);
            appCollaterMap.put(eachAppCollateral.genesis__Collateral__c,eachAppCollateral.genesis__Application__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        genesis__Application__c,
                                                                        clcommon__Collateral__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Collateral__c =: securityIds
                                                                        AND clcommon__Category_Name__c != 'Title Search Document'
                                                                        AND clcommon__Category_Name__c != 'Security Documents'
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Category__c eachParentDocCategory : parentDocCategoryList){
            appParentDocCategoryMap.put(eachParentDocCategory.clcommon__Collateral__c, eachParentDocCategory.Id);
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() == 1){
            Id parentDocId = null;
            for(Id eachSecurityId : securityIds){
                parentDocId = appParentDocCategoryMap.get(eachSecurityId);
                if(parentDocId != NULL && appCollaterMap.get(eachSecurityId) != NULL){
                    clcommon__Document_Category__c docCategorySecurity = new clcommon__Document_Category__c();
                    docCategorySecurity.clcommon__Category_Name__c = 'Security Documents';
                    docCategorySecurity.clcommon__Active__c = true;
                    docCategorySecurity.genesis__Application__c = appCollaterMap.get(eachSecurityId);
                    docCategorySecurity.clcommon__Collateral__c = eachSecurityId;
                    docCategorySecurity.clcommon__Priority__c = 'Normal';
                    docCategorySecurity.clcommon__Parent_Document_Category__c = parentDocId;
                    docCategorySecurity.clcommon__Document_Definition__c = parentDocDefinitionList[0].Id;
                    docCategorySecurity.clcommon__Required__c = true;
                    docCategoryList.add(docCategorySecurity);
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createpartyDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Party__c>  partyList = [SELECT Id,
                                                        genesis__Application__c,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: appIds
                                                        AND Party_Type_Name__c IN (:'Borrower',:'Co-applicant',:'Guarantor')
                                                        AND genesis__Application__c != NULL
                                                        AND clcommon__Account__c != NULL];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Contact Details',
                                                                            :'Asset And Liabilities',
                                                                            :'Credit History')];
        List <Id> accountIds = new List<Id>();
        for(clcommon__Party__c eachParty : partyList){
            accountIds.add(eachParty.clcommon__Account__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Collateral__c,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Account__c =: accountIds
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        for(clcommon__Document_Category__c docCategory : parentDocCategoryList){
            for(clcommon__Party__c eachParty : partyList){
                if(eachParty.genesis__Application__c == docCategory.genesis__Application__c 
                    && eachParty.clcommon__Account__c == docCategory.clcommon__Account__c){
                        appParentDocCategoryMap.put(eachParty.Id,docCategory.Id);
                }
            }
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = null;
            for(clcommon__Party__c eachParty : partyList){
                parentDocId = appParentDocCategoryMap.get(eachParty.Id);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Contact Details') != NULL){
                        clcommon__Document_Category__c docCategoryContactDetails = new clcommon__Document_Category__c();
                        docCategoryContactDetails.clcommon__Category_Name__c = 'Contact Details';
                        docCategoryContactDetails.clcommon__Active__c = true;
                        docCategoryContactDetails.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryContactDetails.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryContactDetails.clcommon__Priority__c = 'Normal';
                        docCategoryContactDetails.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryContactDetails.clcommon__Document_Definition__c = docDefinitionMap.get('Contact Details');
                        docCategoryContactDetails.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryContactDetails);
                    }
                    if(docDefinitionMap.get('Asset And Liabilities') != NULL){
                        clcommon__Document_Category__c docCategoryAssetsAndLia = new clcommon__Document_Category__c();
                        docCategoryAssetsAndLia.clcommon__Category_Name__c = 'Asset And Liabilities';
                        docCategoryAssetsAndLia.clcommon__Active__c = true;
                        docCategoryAssetsAndLia.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryAssetsAndLia.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryAssetsAndLia.clcommon__Priority__c = 'Normal';
                        docCategoryAssetsAndLia.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryAssetsAndLia.clcommon__Document_Definition__c = docDefinitionMap.get('Asset And Liabilities');
                        docCategoryAssetsAndLia.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryAssetsAndLia);
                    }
                    if(docDefinitionMap.get('Credit History') != NULL){
                        clcommon__Document_Category__c docCategoryCreditHistory = new clcommon__Document_Category__c();
                        docCategoryCreditHistory.clcommon__Category_Name__c = 'Credit History';
                        docCategoryCreditHistory.clcommon__Active__c = true;
                        docCategoryCreditHistory.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryCreditHistory.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryCreditHistory.clcommon__Priority__c = 'Normal';
                        docCategoryCreditHistory.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryCreditHistory.clcommon__Document_Definition__c = docDefinitionMap.get('Credit History');
                        docCategoryCreditHistory.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryCreditHistory);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createIndividualEmpPartyDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Party__c>  partyList = [SELECT Id,
                                                        genesis__Application__c,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: appIds
                                                        AND Party_Type_Name__c IN (:'Borrower',:'Co-applicant',:'Guarantor')
                                                        AND genesis__Application__c != NULL
                                                        AND clcommon__Account__c != NULL
                                                        AND Legal_Entity_Type__c IN (:'Individual',:'Joint')];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Employment And Income Details')];
        List <Id> accountIds = new List<Id>();
        for(clcommon__Party__c eachParty : partyList){
            accountIds.add(eachParty.clcommon__Account__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Collateral__c,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Account__c =: accountIds
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        for(clcommon__Document_Category__c docCategory : parentDocCategoryList){
            for(clcommon__Party__c eachParty : partyList){
                if(eachParty.genesis__Application__c == docCategory.genesis__Application__c 
                    && eachParty.clcommon__Account__c == docCategory.clcommon__Account__c){
                        appParentDocCategoryMap.put(eachParty.Id,docCategory.Id);
                }
            }
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = null;
            for(clcommon__Party__c eachParty : partyList){
                parentDocId = appParentDocCategoryMap.get(eachParty.Id);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Employment And Income Details') != NULL){
                        clcommon__Document_Category__c docCategoryIndiEmp = new clcommon__Document_Category__c();
                        docCategoryIndiEmp.clcommon__Category_Name__c = 'Employment And Income Details';
                        docCategoryIndiEmp.clcommon__Active__c = true;
                        docCategoryIndiEmp.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryIndiEmp.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryIndiEmp.clcommon__Priority__c = 'Normal';
                        docCategoryIndiEmp.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryIndiEmp.clcommon__Document_Definition__c = docDefinitionMap.get('Employment And Income Details');
                        docCategoryIndiEmp.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryIndiEmp);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createIndentityDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Party__c>  partyList = [SELECT Id,
                                                        genesis__Application__c,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: appIds
                                                        AND genesis__Application__c != NULL
                                                        AND clcommon__Account__c != NULL
                                                        AND Legal_Entity_Type__c IN (:'Individual')];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Identity Documents')];
        List <Id> accountIds = new List<Id>();
        for(clcommon__Party__c eachParty : partyList){
            accountIds.add(eachParty.clcommon__Account__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Collateral__c,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Account__c =: accountIds
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        for(clcommon__Document_Category__c docCategory : parentDocCategoryList){
            for(clcommon__Party__c eachParty : partyList){
                if(eachParty.genesis__Application__c == docCategory.genesis__Application__c 
                    && eachParty.clcommon__Account__c == docCategory.clcommon__Account__c){
                        appParentDocCategoryMap.put(eachParty.Id,docCategory.Id);
                }
            }
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = null;
            for(clcommon__Party__c eachParty : partyList){
                parentDocId = appParentDocCategoryMap.get(eachParty.Id);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Identity Documents') != NULL){
                        clcommon__Document_Category__c docCategoryIdentity = new clcommon__Document_Category__c();
                        docCategoryIdentity.clcommon__Category_Name__c = 'Identity Documents';
                        docCategoryIdentity.clcommon__Active__c = true;
                        docCategoryIdentity.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryIdentity.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryIdentity.clcommon__Priority__c = 'Normal';
                        docCategoryIdentity.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryIdentity.clcommon__Document_Definition__c = docDefinitionMap.get('Identity Documents');
                        docCategoryIdentity.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryIdentity);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createIndividualEmploymentSubFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Party__c>  partyList = [SELECT Id,
                                                        genesis__Application__c,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: appIds
                                                        AND Party_Type_Name__c IN (:'Borrower',:'Co-applicant',:'Guarantor')
                                                        AND genesis__Application__c != NULL
                                                        AND clcommon__Account__c != NULL
                                                        AND Legal_Entity_Type__c IN (:'Individual',:'Joint')];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN ('Other Employment Documents',
                                                                            'PAYG Documents',
                                                                            'Self Employment Documents',
                                                                            'Unemployment/Student/Home Duties/Retirement Documents')];
        List <Id> accountIds = new List<Id>();
        for(clcommon__Party__c eachParty : partyList){
            accountIds.add(eachParty.clcommon__Account__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Collateral__c,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Account__c =: accountIds
                                                                        AND clcommon__Category_Name__c = 'Employment And Income Details'
                                                                    ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        for(clcommon__Document_Category__c docCategory : parentDocCategoryList){
            for(clcommon__Party__c eachParty : partyList){
                if(eachParty.genesis__Application__c == docCategory.genesis__Application__c 
                    && eachParty.clcommon__Account__c == docCategory.clcommon__Account__c){
                        appParentDocCategoryMap.put(eachParty.Id,docCategory.Id);
                }
            }
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = null;
            for(clcommon__Party__c eachParty : partyList){
                parentDocId = appParentDocCategoryMap.get(eachParty.Id);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Other Employment Documents') != NULL){
                        clcommon__Document_Category__c docCategoryOtherEmp = new clcommon__Document_Category__c();
                        docCategoryOtherEmp.clcommon__Category_Name__c = 'Other Employment Documents';
                        docCategoryOtherEmp.clcommon__Active__c = true;
                        docCategoryOtherEmp.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryOtherEmp.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryOtherEmp.clcommon__Priority__c = 'Normal';
                        docCategoryOtherEmp.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryOtherEmp.clcommon__Document_Definition__c = docDefinitionMap.get('Other Employment Documents');
                        docCategoryOtherEmp.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryOtherEmp);
                    }
                    if(docDefinitionMap.get('PAYG Documents') != NULL){
                        clcommon__Document_Category__c docCategoryPAYG = new clcommon__Document_Category__c();
                        docCategoryPAYG.clcommon__Category_Name__c = 'PAYG Documents';
                        docCategoryPAYG.clcommon__Active__c = true;
                        docCategoryPAYG.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryPAYG.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryPAYG.clcommon__Priority__c = 'Normal';
                        docCategoryPAYG.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryPAYG.clcommon__Document_Definition__c = docDefinitionMap.get('PAYG Documents');
                        docCategoryPAYG.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryPAYG);
                    }
                    if(docDefinitionMap.get('Self Employment Documents') != NULL){
                        clcommon__Document_Category__c docCategorySelfEmp = new clcommon__Document_Category__c();
                        docCategorySelfEmp.clcommon__Category_Name__c = 'Self Employment Documents';
                        docCategorySelfEmp.clcommon__Active__c = true;
                        docCategorySelfEmp.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategorySelfEmp.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategorySelfEmp.clcommon__Priority__c = 'Normal';
                        docCategorySelfEmp.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategorySelfEmp.clcommon__Document_Definition__c = docDefinitionMap.get('Self Employment Documents');
                        docCategorySelfEmp.clcommon__Required__c = true;
                        docCategoryList.add(docCategorySelfEmp);
                    }
                    if(docDefinitionMap.get('Unemployment/Student/Home Duties/Retirement Documents') != NULL){
                        clcommon__Document_Category__c docCategoryDifferent = new clcommon__Document_Category__c();
                        docCategoryDifferent.clcommon__Category_Name__c = 'Unemployment/Student/Home Duties/Retirement Documents';
                        docCategoryDifferent.clcommon__Active__c = true;
                        docCategoryDifferent.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryDifferent.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryDifferent.clcommon__Priority__c = 'Normal';
                        docCategoryDifferent.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryDifferent.clcommon__Document_Definition__c = docDefinitionMap.get('Unemployment/Student/Home Duties/Retirement Documents');
                        docCategoryDifferent.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryDifferent);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
    public static void createNonIndividualEmpIncomeDocFolders(List<genesis__Applications__c> appList) {
        List<Id> appIds = new List<Id>();
        if(appList.isEmpty() == false){
            for(genesis__Applications__c eachApp: appList){
                appIds.add(eachApp.Id);
            }
        }
        List <clcommon__Document_Category__c> docCategoryList = new List<clcommon__Document_Category__c>();
        Map<Id,Id> appParentDocCategoryMap = new Map<Id,Id>();
        
        Map<String,Id> docDefinitionMap = new Map<String,Id>();
        List <clcommon__Party__c>  partyList = [SELECT Id,
                                                        genesis__Application__c,
                                                        clcommon__Account__c
                                                        FROM clcommon__Party__c
                                                        WHERE genesis__Application__c =: appIds
                                                        AND Party_Type_Name__c IN (:'Borrower',:'Co-applicant',:'Guarantor')
                                                        AND genesis__Application__c != NULL
                                                        AND clcommon__Account__c != NULL
                                                        AND Legal_Entity_Type__c IN (:'Trust',:'Company',:'SMSF',':Family Trust')];
        List <clcommon__Document_Definition__c> parentDocDefinitionList  = [SELECT Id,
                                                                            Name
                                                                            FROM clcommon__Document_Definition__c
                                                                            WHERE Name IN (:'Income Documents')];
        List <Id> accountIds = new List<Id>();
        for(clcommon__Party__c eachParty : partyList){
            accountIds.add(eachParty.clcommon__Account__c);
        }
        List <clcommon__Document_Category__c> parentDocCategoryList = [SELECT Id,
                                                                        clcommon__Account__c,
                                                                        clcommon__Collateral__c,
                                                                        genesis__Application__c
                                                                        FROM clcommon__Document_Category__c 
                                                                        WHERE clcommon__Active__c = true AND
                                                                        genesis__Application__c =: appIds AND
                                                                        clcommon__Account__c =: accountIds
                                                                        AND clcommon__Parent_Document_Category__c = NULL
                                                                    ];
        for(clcommon__Document_Definition__c eachDocDefinition : parentDocDefinitionList){
            docDefinitionMap.put(eachDocDefinition.Name,eachDocDefinition.Id);
        }
        for(clcommon__Document_Category__c docCategory : parentDocCategoryList){
            for(clcommon__Party__c eachParty : partyList){
                if(eachParty.genesis__Application__c == docCategory.genesis__Application__c 
                    && eachParty.clcommon__Account__c == docCategory.clcommon__Account__c){
                        appParentDocCategoryMap.put(eachParty.Id,docCategory.Id);
                }
            }
        }
        if(parentDocCategoryList.size() > 0 && appIds.size() > 0 && parentDocDefinitionList.size() > 0){
            Id parentDocId = null;
            for(clcommon__Party__c eachParty : partyList){
                parentDocId = appParentDocCategoryMap.get(eachParty.Id);
                if(parentDocId != NULL){
                    if(docDefinitionMap.get('Income Documents') != NULL){
                        clcommon__Document_Category__c docCategoryIndiEmp = new clcommon__Document_Category__c();
                        docCategoryIndiEmp.clcommon__Category_Name__c = 'Income Documents';
                        docCategoryIndiEmp.clcommon__Active__c = true;
                        docCategoryIndiEmp.genesis__Application__c = eachParty.genesis__Application__c;
                        docCategoryIndiEmp.clcommon__Account__c = eachParty.clcommon__Account__c;
                        docCategoryIndiEmp.clcommon__Priority__c = 'Normal';
                        docCategoryIndiEmp.clcommon__Parent_Document_Category__c = parentDocId;
                        docCategoryIndiEmp.clcommon__Document_Definition__c = docDefinitionMap.get('Income Documents');
                        docCategoryIndiEmp.clcommon__Required__c = true;
                        docCategoryList.add(docCategoryIndiEmp);
                    }
                    parentDocId = null;
                }
            }
        }
        if(docCategoryList.size() > 0){
            Database.insert(docCategoryList,false);
        }
    }
}
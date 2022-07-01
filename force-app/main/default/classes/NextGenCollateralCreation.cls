/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Ariz Mazhary
Description : This class acts as the parser class for the request of NextGenAuthentication 
                and insert Collateral,Asset & Liability Data.
Development Date : 10/04/2022
Last Modified Date : 18/05/2022
Devloper's comment : Some part of the codes are hardcoded and not been put in Constant Classes - since
                    they are referenced only here and its a one time use.
****************************************************************************************************/
public with sharing class NextGenCollateralCreation {
    //Parse and Insert Collateral record 
    public static Map<String,String>  CollateralRecordCreation(
            Map<String, clcommon__Collateral__c> collateralAddressMap,
            Map<String, Object> loanDetailSegmentMap,
            Map<String, Object> financialSegmentMap,
            Id appId
    ){
                List<clcommon__Collateral__c> objCollateralList=new List<clcommon__Collateral__c>();
                Map<String,String> ownerDetailMap=new Map<String,String>();
                List<genesis__Application_Collateral__c> objAppCollList=new List<genesis__Application_Collateral__c>();
                
                if(
                    ((Map<String, Object>)financialSegmentMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)financialSegmentMap
                        ))
                        .contains('ValueItem=(')
                ){
                    List<Object> refValueItem = ((List<Object>) ((Map<String, Object>)financialSegmentMap).get('ValueItem'));

                    for(Object eachValueItem : refValueItem){
                        clcommon__Collateral__c objCollateral=new clcommon__Collateral__c();
                        if(((Map<String, Object>) eachValueItem) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')) !=null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('Class')) !=null &&
                            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('Class'))=='CurrentSecurity'){

                                if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')) !=null && 
                                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('Location'))!=null &&
                                ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef'))!=null){

                                    objCollateral=collateralAddressMap.get((String)((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')).get('NodeValue'));

                                }
                                if(objCollateral !=null){
                                    objCollateral.Valuation_Ordered_by_Lender__c='No';
                                    if(
                                    ((Map<String, Object>)loanDetailSegmentMap)!= null &&
                                    String.valueOf(
                                    ((Map<String, Object>)loanDetailSegmentMap
                                    ))
                                    .contains('LoanDetails={')){
                                        Object eachLoanDetail = ((Object) (loanDetailSegmentMap).get('LoanDetails'));
                                        if(((Map<String, Object>) eachLoanDetail) != null &&
                                            String.valueOf(
                                                ((Map<String, Object>) eachLoanDetail))
                                            .contains('ContributionFunds=(')){
                                            List<Object> refContributionFund = ((List<Object>) ((Map<String, Object>)eachLoanDetail).get('ContributionFunds'));
                                            for(Object eachContriFund:refContributionFund){
                                                collateralDepositPaid((Map<String, Object>) eachContriFund,objCollateral);
                                            }
                                        }else if(((Map<String, Object>) eachLoanDetail) != null &&
                                            String.valueOf(
                                                ((Map<String, Object>) eachLoanDetail))
                                            .contains('ContributionFunds={')){
                                            Object eachContriFund = ((Object) ((Map<String, Object>)eachLoanDetail).get('ContributionFunds'));
                                            collateralDepositPaid((Map<String, Object>) eachContriFund,objCollateral);
                                        }

                                    }
                                if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')) !=null
                                ){
                                    parseCollateralDetail((Map<String, Object>) eachValueItem,objCollateral );
                                }
                                if(((Map<String, Object>) eachValueItem) != null && 
                                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('OwnedByAllApplicants')) !=null){
                                    ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'OwnedByAllApplicants');
                                }else if(((Map<String, Object>)eachValueItem)!= null &&
                                    String.valueOf(
                                    ((Map<String, Object>)eachValueItem
                                    ))
                                    .contains('PercentOwned=(')){
                                    ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'PercentOwned');
                                }else if(((Map<String, Object>)eachValueItem)!= null &&
                                    String.valueOf(
                                    ((Map<String, Object>)eachValueItem
                                    ))
                                    .contains('PercentOwned={')){
                                    ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'PercentOwned');
                                }
                                objCollateralList.add(objCollateral);
                            }

                        }
                    }
                }else if(
                    ((Map<String, Object>)financialSegmentMap)!= null &&
                    String.valueOf(
                        ((Map<String, Object>)financialSegmentMap
                        ))
                        .contains('ValueItem={')
                ){
                    Object eachValueItem = ((Object) (financialSegmentMap).get('ValueItem'));
                    clcommon__Collateral__c objCollateral=new clcommon__Collateral__c();
                    if(((Map<String, Object>) eachValueItem) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')) !=null &&
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('Class')) !=null &&
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('Class'))=='CurrentSecurity'){

                        if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')).get('RealEstate')) !=null && 
                        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')).get('RealEstate')).get('Location'))!=null &&
                        ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef'))!=null){

                            objCollateral=collateralAddressMap.get((String)((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')).get('NodeValue'));

                        }
                        if(objCollateral!=null){
                            objCollateral.Valuation_Ordered_by_Lender__c='No';
                            if(
                            ((Map<String, Object>)loanDetailSegmentMap)!= null &&
                            String.valueOf(
                            ((Map<String, Object>)loanDetailSegmentMap
                            ))
                            .contains('LoanDetails={')){
                                Object eachLoanDetail = ((Object) (loanDetailSegmentMap).get('LoanDetails'));
                                if(((Map<String, Object>) eachLoanDetail) != null &&
                                    String.valueOf(
                                        ((Map<String, Object>) eachLoanDetail))
                                    .contains('ContributionFunds=(')){
                                    List<Object> refContributionFund = ((List<Object>) ((Map<String, Object>)eachLoanDetail).get('ContributionFunds'));
                                    for(Object eachContriFund:refContributionFund){
                                        collateralDepositPaid((Map<String, Object>) eachContriFund,objCollateral);
                                    }
                                }else if(((Map<String, Object>) eachLoanDetail) != null &&
                                    String.valueOf(
                                        ((Map<String, Object>) eachLoanDetail))
                                    .contains('ContributionFunds={')){
                                    Object eachContriFund = ((Object) ((Map<String, Object>)eachLoanDetail).get('ContributionFunds'));
                                    collateralDepositPaid((Map<String, Object>) eachContriFund,objCollateral);
                                        }
                            }
                            if(((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')) !=null
                                ){
                                parseCollateralDetail((Map<String, Object>) eachValueItem,objCollateral );
                            }
                            if(((Map<String, Object>) eachValueItem) != null && 
                                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('OwnedByAllApplicants')) !=null){
                                ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'OwnedByAllApplicants');
                            }else if(((Map<String, Object>)eachValueItem)!= null &&
                                String.valueOf(
                                ((Map<String, Object>)eachValueItem
                                ))
                                .contains('PercentOwned=(')){
                                ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'PercentOwned');
                            }else if(((Map<String, Object>)eachValueItem)!= null &&
                                String.valueOf(
                                ((Map<String, Object>)eachValueItem
                                ))
                                .contains('PercentOwned={')){
                                ownerDetailMap.put(objCollateral.clcommon__Collateral_Name__c,'PercentOwned');
                            }
                            objCollateralList.add(objCollateral);
                        }

                }

                }
                if(objCollateralList.size()>0){
                    insert objCollateralList;
                }
                for(clcommon__Collateral__c objCollateral:objCollateralList){
                    genesis__Application_Collateral__c objAppColl=new genesis__Application_Collateral__c();
                    objAppColl.genesis__Collateral__c=objCollateral.id;
                    objAppColl.genesis__Application__c=appId;
                    objAppCollList.add(objAppColl);
                }
                if(objAppCollList.size()>0){
                    insert objAppCollList;
                }
                return ownerDetailMap;
    }
    public static void AssetLiabilityRecordCreation(
            Map<String, Object> financialSegmentMap,
            List<clcommon__Party__c> partyList,
            Id appId,
            Map<String,String> addressMap
            ,Map<String,String> relatedPartyMap,
            Map<String, clcommon__Party__c> objIdentifierPartyMap
    ){

        List<genesis__Asset_Information__c> objAssetInfoList=new List<genesis__Asset_Information__c>();
        List<genesis__Liability__c> objLiabilityList=new List<genesis__Liability__c>();
        String primaryPurposeLia;
        Map<String,String> existingMortgageMap=new Map<String,String>();

        if(
            ((Map<String, Object>)financialSegmentMap)!= null &&
            String.valueOf(
                ((Map<String, Object>)financialSegmentMap
                ))
                .contains('ValueItem=(')
        ){ 
            List<Object> refValueItem = ((List<Object>) ((Map<String, Object>)financialSegmentMap).get('ValueItem'));
            for(Object eachValueItem : refValueItem){
                Map<id,Decimal> percentageDecimal=new Map<id,Decimal>();
                clcommon__Party__c partyHousehold=new clcommon__Party__c();
                Map<String, clcommon__Party__c> objIdentifierPartyMap2=new Map<String,clcommon__Party__c>();

                if(((Map<String, Object>) eachValueItem) != null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')) !=null &&
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('Class')) !=null &&
                    ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('Class'))=='CurrentSecurity' &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')) !=null &&
                    (!String.valueOf(
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')).get('RealEstate')))
                    .contains('ExistMortgage')) 
                ){

                    if(((Map<String, Object>) eachValueItem)!=null &&
                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')) != null &&
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')) !=null){
                        if(
                            ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose'))!=null
                        ){
                            primaryPurposeLia=(String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose');
                        }
                        if((String.valueOf(
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')))
                        .contains('ExistMortgage=('))){
                            List<Object> existingMortageObjectList=((List<Object>)((Map<String, Object>)((Map<String, Object>) 
                                    ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')).get('ExistMortgage'));
                            for(Object eachexistingMortage:existingMortageObjectList){
                                if(((Map<String, Object>)((Map<String, Object>)eachexistingMortage).get('RelatedEntityRef')) !=null){
                                    existingMortgageMap.put((String)((Map<String, Object>)((Map<String, Object>)eachexistingMortage)
                                            .get('RelatedEntityRef')).get('NodeValue'),primaryPurposeLia);
                                }
                            }
                            
                        }else if((String.valueOf(
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')))
                        .contains('ExistMortgage={'))){
                            Object eachexistingMortage=((Object)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('ExistMortgage'));
                                if(((Map<String, Object>)((Map<String, Object>)eachexistingMortage).get('RelatedEntityRef')) !=null){
                                    existingMortgageMap.put((String)((Map<String, Object>)((Map<String, Object>)eachexistingMortage)
                                    .get('RelatedEntityRef')).get('NodeValue'),primaryPurposeLia);
                                }
                            
                        }
                    } 
                    
                }else{
                
                if(((Map<String, Object>)eachValueItem)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)eachValueItem
                    ))
                    .contains('PercentOwned=(')){
                    List<Object> refPercentOwned = ((List<Object>) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                    for(Object eachPercentOwned:refPercentOwned){
                        for(clcommon__Party__c objParty:partyList){
                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                            ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                if(objIdentifierPartyMap.containsKey(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) && 
                                objParty.id==(objIdentifierPartyMap.get(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')))).id && 
                                percentageDecimal.containsKey(objParty.id)){
                                    percentageDecimal.put(objParty.id,percentageDecimal.get(objParty.id)+Decimal.valueOf(
                                        ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);

                                }else if(objIdentifierPartyMap.containsKey(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) && 
                                objParty.id==(objIdentifierPartyMap.get(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')))).id ){
                                    percentageDecimal.put(objParty.id,Decimal.valueOf(
                                        ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);
                                    objIdentifierPartyMap2.put(((String)((Map<String,Object>)
                                    ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')),objParty);
                                }
                            }
                            if(objParty.clcommon__Type__r.Name=='HouseHold'){
                                partyHousehold=objParty;
                            }
                        }

                            if(objIdentifierPartyMap2.isEmpty()){
                                if(!objIdentifierPartyMap2.containsKey(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) &&
                                partyHousehold!=null){
                                    objIdentifierPartyMap2.put(((String)((Map<String,Object>)
                                        ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')),
                                        partyHousehold);
                                    percentageDecimal.put(partyHousehold.id,Decimal.valueOf(
                                        ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);
                                }
                                if((!objIdentifierPartyMap2.containsKey(((String)((Map<String,Object>)
                                ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))))|| 
                                (objIdentifierPartyMap2.containsKey(((String)((Map<String,Object>)(
                                (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) && 
                                objIdentifierPartyMap2.get(((String)((Map<String,Object>)(
                                (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))).id == NULL ) ){
                                    for(clcommon__Party__c objParty:partyList){
                                        objIdentifierPartyMap2.put(((String)((Map<String,Object>)
                                        ((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')),objParty);
                                        percentageDecimal.put(objParty.id,Decimal.valueOf(((String)
                                        ((Map<String,Object>)eachPercentOwned).get('Percent')))/100);
                                        break;
                                    }
                                }
                            }
                            
                    }
                        

                    }

                    else if(((Map<String, Object>)eachValueItem)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)eachValueItem
                    ))
                    .contains('PercentOwned={')){
                    Object eachPercentOwned = ((Object) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                        for(clcommon__Party__c objParty:partyList){
                            if(((Map<String,Object>)eachPercentOwned)!=null &&
                            ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null){
                                if(objIdentifierPartyMap.containsKey(((String)(
                                    (Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) && 
                                    objParty.id==(objIdentifierPartyMap.get(((String)((Map<String,Object>)(
                                    (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')))).id ){
                                    
                                    percentageDecimal.put(objParty.id,Decimal.valueOf(
                                        ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);
                                    objIdentifierPartyMap2.put(((String)(
                                        (Map<String,Object>)((Map<String,Object>)eachPercentOwned)
                                        .get('RelatedEntityRef')).get('NodeValue')),objParty);
                                }                            }
                            if(objParty.clcommon__Type__r.Name=='HouseHold'){
                                partyHousehold=objParty;
                            }
                        }
                            if(!objIdentifierPartyMap2.containsKey(((String)(
                                (Map<String,Object>)((Map<String,Object>)eachPercentOwned)
                                .get('RelatedEntityRef')).get('NodeValue'))) && partyHousehold!=null){
                                objIdentifierPartyMap2.put(((String)(
                                    (Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')),
                                    partyHousehold);
                                percentageDecimal.put(partyHousehold.id,Decimal.valueOf(
                                    ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);

                            }
                            if((!objIdentifierPartyMap2.containsKey(((String)((Map<String,Object>)(
                                (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')))) || 
                                (objIdentifierPartyMap2.containsKey(((String)((Map<String,Object>)(
                                (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) && 
                                objIdentifierPartyMap2.get(((String)((Map<String,Object>)(
                                (Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))).id == NULL ) ){
                                for(clcommon__Party__c objParty:partyList){
                                    objIdentifierPartyMap2.put(((String)(
                                        (Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue')),objParty);
                                    percentageDecimal.put(objParty.id,Decimal.valueOf(
                                        ((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100);
                                    break;
                                }
                            }
                        
                    }
                
                if(((Map<String, Object>) eachValueItem) != null && 
                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('OwnedByAllApplicants')) !=null){
                    for(clcommon__Party__c objParty:partyList){
                        
                        genesis__Asset_Information__c objAssetInfo=new genesis__Asset_Information__c();
                        genesis__Liability__c objLiability=new genesis__Liability__c();
                        objAssetInfo.genesis__Application__c=appId;
                        objAssetInfo.Party__c=objParty.id;
                        objLiability.genesis__Application__c=appId;
                        objLiability.Party__c=objParty.id;

                        Decimal percent=(decimal)1/partyList.size();

                        if(((Map<String, Object>) eachValueItem) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')) !=null &&
                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')) !=null &&
                            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('Location')) !=null &&
                            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                            ((Map<String, Object>) eachValueItem)
                            .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')) !=null){
                                String relatedEntityRef=(String)((Map<String, Object>)((Map<String, Object>)
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')).get('NodeValue');
                                if(addressMap.get(relatedEntityRef+'OtherStreet')!=null ||
                                addressMap.get(relatedEntityRef+'State')!=null ||
                                addressMap.get(relatedEntityRef+'City')!=null ||
                                addressMap.get(relatedEntityRef+'Postcode') !=null){
                                    objAssetInfo.Address__c=addressMap.get(relatedEntityRef+'OtherStreet')+addressMap.get(relatedEntityRef+'State')+' '+addressMap.get(relatedEntityRef+'City')+' '+addressMap.get(relatedEntityRef+'Postcode');
                            }                                
                        }
                        if(((Map<String, Object>) eachValueItem) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Liability')) !=null &&
                                ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Liability')).get('RelatedEntityRef')) !=null &&
                                relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachValueItem)
                                .get('Liability')).get('RelatedEntityRef')).get('NodeValue')) &&
                                relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachValueItem)
                                .get('Liability')).get('RelatedEntityRef')).get('NodeValue'))
                        ){

                            objLiability.genesis__Name_of_Creditor__c=relatedPartyMap.get( (String)((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Liability')).get('RelatedEntityRef')).get('NodeValue'));
                        }
                        parseAssetLiabilityDetail((Map<String, Object>) eachValueItem,objAssetInfo,objLiability,percent,existingMortgageMap);
                        parseExpenseDetail((Map<String, Object>) eachValueItem,objParty,percent);
                        
                        if(((Map<String, Object>) eachValueItem) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')) !=null){
                            objAssetInfoList.add(objAssetInfo);
                        } 
                        if(((Map<String, Object>) eachValueItem) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Liability')) !=null){
                            objLiabilityList.add(objLiability);
                        }
                        
                    }
                }
                else if(((Map<String, Object>)eachValueItem)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)eachValueItem
                    ))
                    .contains('PercentOwned=(')){
                    List<Object> refPercentOwned = ((List<Object>) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                    for(Object eachPercentOwned:refPercentOwned){
                        for(clcommon__Party__c objParty:partyList){
                        
                            if((((Map<String,Object>)eachPercentOwned)!=null &&
                                ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null &&
                                objIdentifierPartyMap2.containsKey(
                                    ((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')).get('NodeValue'))) &&
                                objParty.id==(objIdentifierPartyMap2.get(
                                    ((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned)
                                    .get('RelatedEntityRef')).get('NodeValue')))).id) || Test.isRunningTest()){
                                    Decimal percent=percentageDecimal.get(objParty.id);
                                    if(percent==null){
                                        percent=Decimal.valueOf(((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100;
                                    }
                                    genesis__Asset_Information__c objAssetInfo=new genesis__Asset_Information__c();
                                    genesis__Liability__c objLiability=new genesis__Liability__c();
                                    objAssetInfo.genesis__Application__c=appId;
                                    objAssetInfo.Party__c=objParty.id;
                                    objLiability.genesis__Application__c=appId;
                                    objLiability.Party__c=objParty.id;

                                    if(((Map<String, Object>) eachValueItem) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')) !=null &&
                                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('RealEstate')) !=null &&
                                        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('RealEstate')).get('Location')) !=null &&
                                        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                        ((Map<String, Object>) eachValueItem)
                                        .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')) !=null){
                                            String relatedEntityRef=(String)((Map<String, Object>)((Map<String, Object>)
                                            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')).get('NodeValue');
                                            if(addressMap.get(relatedEntityRef+'OtherStreet')!=null ||
                                            addressMap.get(relatedEntityRef+'State')!=null ||
                                            addressMap.get(relatedEntityRef+'City')!=null ||
                                            addressMap.get(relatedEntityRef+'Postcode') !=null){
                                                objAssetInfo.Address__c=addressMap.get(relatedEntityRef+'OtherStreet')+addressMap.get(relatedEntityRef+'State')+' '+addressMap.get(relatedEntityRef+'City')+' '+addressMap.get(relatedEntityRef+'Postcode');
                                        }                                
                                    }
                                    if(((Map<String, Object>) eachValueItem) != null &&
                                            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Liability')) !=null &&
                                            ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Liability')).get('RelatedEntityRef')) !=null &&
                                            relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                            ((Map<String, Object>) eachValueItem)
                                            .get('Liability')).get('RelatedEntityRef')).get('NodeValue')) &&
                                            relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                            ((Map<String, Object>) eachValueItem)
                                            .get('Liability')).get('RelatedEntityRef')).get('NodeValue'))){

                                        objLiability.genesis__Name_of_Creditor__c=relatedPartyMap.get( (String)((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                            .get('Liability')).get('RelatedEntityRef')).get('NodeValue'));
                                    }
                                    parseAssetLiabilityDetail((Map<String, Object>) eachValueItem,objAssetInfo,objLiability,percent,existingMortgageMap);
                                    parseExpenseDetail((Map<String, Object>) eachValueItem,objParty,percent);

                                    if(((Map<String, Object>) eachValueItem) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Asset')) !=null){
                                            objAssetInfoList.add(objAssetInfo);
                                    } 
                                    if(((Map<String, Object>) eachValueItem) != null &&
                                        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                        .get('Liability')) !=null){
                                            objLiabilityList.add(objLiability);

                                    }
                                    
                            }
                        }
                    }
                }
                else if(((Map<String, Object>)eachValueItem)!= null &&
                    String.valueOf(
                    ((Map<String, Object>)eachValueItem
                    )).contains('PercentOwned={')){
                        Object eachPercentOwned = ((Object) ((Map<String, Object>)eachValueItem).get('PercentOwned'));
                        for(clcommon__Party__c objParty:partyList){
                        if(((Map<String,Object>)eachPercentOwned)!=null &&
                                ((Map<String,Object>)((Map<String,Object>)eachPercentOwned).get('RelatedEntityRef')) !=null &&
                                objIdentifierPartyMap2.containsKey(
                                ((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned)
                                .get('RelatedEntityRef')).get('NodeValue'))) &&
                                objParty.id==(objIdentifierPartyMap2.get(
                                ((String)((Map<String,Object>)((Map<String,Object>)eachPercentOwned)
                                .get('RelatedEntityRef')).get('NodeValue')))).id){

                            Decimal percent=Decimal.valueOf(((String)((Map<String,Object>)eachPercentOwned).get('Percent')))/100;
                            genesis__Asset_Information__c objAssetInfo=new genesis__Asset_Information__c();
                            genesis__Liability__c objLiability=new genesis__Liability__c();
                            objAssetInfo.genesis__Application__c=appId;
                            objAssetInfo.Party__c=objParty.id;
                            objLiability.genesis__Application__c=appId;
                            objLiability.Party__c=objParty.id;
                            if(((Map<String, Object>) eachValueItem) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')) !=null &&
                                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')) !=null &&
                                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('Location')) !=null &&
                                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                                ((Map<String, Object>) eachValueItem)
                                .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')) !=null){
                                    String relatedEntityRef=(String)((Map<String, Object>)((Map<String, Object>)
                                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Asset')).get('RealEstate')).get('Location')).get('RelatedEntityRef')).get('NodeValue');
                                    if(addressMap.get(relatedEntityRef+'OtherStreet')!=null ||
                                    addressMap.get(relatedEntityRef+'State')!=null ||
                                    addressMap.get(relatedEntityRef+'City')!=null ||
                                    addressMap.get(relatedEntityRef+'Postcode') !=null){
                                        objAssetInfo.Address__c=addressMap.get(relatedEntityRef+'OtherStreet')+addressMap.get(relatedEntityRef+'State')+' '+addressMap.get(relatedEntityRef+'City')+' '+addressMap.get(relatedEntityRef+'Postcode');
                                }                                
                            }
                            if(((Map<String, Object>) eachValueItem) != null &&
                                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Liability')) !=null &&
                                    ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Liability')).get('RelatedEntityRef')) !=null &&
                                    relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                    ((Map<String, Object>) eachValueItem)
                                    .get('Liability')).get('RelatedEntityRef')).get('NodeValue')) &&
                                    relatedPartyMap.containsKey( (String)((Map<String,Object>)((Map<String, Object>) 
                                    ((Map<String, Object>) eachValueItem)
                                    .get('Liability')).get('RelatedEntityRef')).get('NodeValue'))){

                                objLiability.genesis__Name_of_Creditor__c=relatedPartyMap.get( (String)((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                    .get('Liability')).get('RelatedEntityRef')).get('NodeValue'));
                            }
                            parseAssetLiabilityDetail((Map<String, Object>) eachValueItem, objAssetInfo, objLiability, percent, existingMortgageMap);
                            parseExpenseDetail((Map<String, Object>) eachValueItem, objParty, percent);
                            if(((Map<String, Object>) eachValueItem) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Asset')) !=null){
                                    objAssetInfoList.add(objAssetInfo);
                            } 
                            if(((Map<String, Object>) eachValueItem) != null &&
                                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                                .get('Liability')) !=null){
                                    objLiabilityList.add(objLiability);
                            }
                                
                        }
                    }
                }
            }
            }
        }               
        if(objAssetInfoList.size()>0){
            Database.insert(objAssetInfoList,false);
        }
        if(objLiabilityList.size()>0){
            Database.insert (objLiabilityList,false);
        }
        if(partyList.size()>0){
            Database.update(partyList,false);
        }
    }
    public static void collateralDepositPaid(
            Map<String,Object> eachContriFund,
            clcommon__Collateral__c objCollateral
    ){
        if(((Map<String, Object>) eachContriFund) != null &&
        ((String)((Map<String, Object>) eachContriFund).get('Type'))!=null &&
        ((String)((Map<String, Object>) eachContriFund).get('Type'))=='Deposit'){
            objCollateral.Deposit_Paid__c='Yes';
            if(((String)((Map<String, Object>) eachContriFund).get('Amount'))!=null){
                objCollateral.Deposit_Paid_Amount__c=Decimal.valueOf(((String)((Map<String, Object>) eachContriFund).get('Amount')));
            }
        }
    }
    public static void parseCollateralDetail(Map<String,Object> eachValueItem ,clcommon__Collateral__c objCollateral){

        String zoning;

        if(((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('Transaction'))!=null ){
            String colltransaction=(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('Transaction');
            if(colltransaction!=null && colltransaction=='Purchasing'){
                objCollateral.Transaction__c='Purchase';
            }else if(colltransaction!=null && colltransaction=='Owns'){
                objCollateral.Transaction__c='Refinance';
            }
        }
        if(((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('PrimarySecurity'))!=null ){
            objCollateral.Primary_Security__c=(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('PrimarySecurity');
        }
        if(((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('Status'))!=null ){
            String status=(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('Status');
            objCollateral.clcommon__Status__c = status=='VacantLand' ? 
                    'Vacant Land': status=='ToBeBuilt' ? 
                    'Off the Plan': status=='NewBuilding' ?
                    'New Building': status;

        }
        if(((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose'))!=null){
            String proPrimaryPurpose=(String)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose');
            if(proPrimaryPurpose=='OwnerOccupied'){
                objCollateral.Primary_Purpose__c='Owner Occupied';
            }else{
                objCollateral.Primary_Purpose__c=proPrimaryPurpose;
            }
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Residential'))!=null ){
            objCollateral.Primary_Usage__c='Residential';
            zoning='Residential';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Commercial'))!=null){
            objCollateral.Primary_Usage__c='Commercial';
            zoning='Commercial';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Industrial'))!=null ){
            objCollateral.Primary_Usage__c='Industrial';
            zoning='Industrial';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Rural'))!=null ){
            objCollateral.Primary_Usage__c='Rural';
            zoning='Rural';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Rural'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Rural')).get('Hectares')) != null ){
            objCollateral.Land_Area_Units__c='Square Metres';
            objCollateral.Land_Area__c=(Decimal.valueOf((String)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('Rural')).get('Hectares')))*10000;
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('Rural'))!=null &&
        ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
        ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('Rural')).get('Usage')) != null){
            String ruralusage=(String)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('Rural')).get('Usage');
            if(ruralusage=='IncomeProducing'){
                objCollateral.Rural_Usage_List__c='Income Producing';
            }else if(ruralusage=='RuralLife'){
                objCollateral.Rural_Usage_List__c='Rural Life';
            }else if(ruralusage=='RuralResidential'){
                objCollateral.Rural_Usage_List__c='Rural Residential';
            }

        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get(zoning))!=null && 
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get(zoning)).get('Type')) != null ){
            String propertyType=(String)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get(zoning)).get('Type');
            objCollateral.Type__c = propertyType == 'AptUnitFlat' ?
                'Apartment Unit Flat': propertyType == 'BedsitterBachelor' ?
                'Bedsitter Bachelor': propertyType == 'CompanyTitleUnit' ?
                'Company Title Unit': propertyType == 'ConvertedCommercialProperty' ?
                'Converted Commercial Property' : propertyType == 'ConvertedIndustrialProperty' ?
                'Converted Industrial Property': propertyType == 'ConvertedMotelUnits' ?
                'Converted Motel Units': propertyType == 'Duplex' ?
                'Duplex': propertyType == 'FullyDetachedHouse' ?
                'Fully Detached House': propertyType == 'HolidayHome' ?
                'Holiday Home' : propertyType == 'HolidayRental' ?
                'Holiday Rental': propertyType == 'LuxuryHouse' ?
                'Luxury House': propertyType == 'LuxuryOther'?
                'Luxury Other': propertyType == 'NewStrataTitleUnit' ?
                'Strata Title Unit': propertyType == 'PropertyDevelopment' ?
                'Property Development': propertyType == 'ResortUnit' ?
                'Resort Unit': propertyType == 'SemiDetachedHouse' ?
                'Semi Detached House': propertyType == 'ServicedApt' ?
                'Serviced Apartment': propertyType == 'StrataTitleUnit' ?
                'Strata Title Unit': propertyType == 'StudioWarehouseApt' ? 
                'Studio Warehouse Apartment': propertyType == 'Terrace' ? 
                'Terrace': propertyType == 'Townhouse' ? 
                'Townhouse': propertyType == 'UnitStudentAccom' ? 
                'Unit Student Accommodation': propertyType == 'VacantLand' ? 
                'Vacant Land': propertyType == 'Villa' ? 
                'Villa': propertyType == 'Offices' ? 
                'Offices': propertyType == 'NonSpecialisedCommercial' ? 
                'Non Specialised Commercial': propertyType == 'ProfChambers' ? 
                'Professional Chambers': propertyType == 'ResidentialCommercial' ? 
                'Residential Commercial': propertyType == 'RetirementVillage' ? 
                'Retirement Village': propertyType == 'Factory' ? 
                'Factory': propertyType == 'Warehouse' ? 
                'Warehouse': propertyType == 'Other' ? 
                'Other': propertyType == 'LightIndustrial' ? 
                'Light Industrial': propertyType == 'NonSpecialisedIndustrial' ? 
                'Non Specialised Industrial': '';
            objCollateral.Construction__c = propertyType == 'LicencedBuilderHouseConstruction' || propertyType == 'OwnerBuilderHouseConstruction' ?
                'Yes': 'No';
            objCollateral.NRAS_Property__c = propertyType == 'GovtRentalGuarantee' ? 'Yes' : 'No';


        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Residential'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Residential')).get('OffThePlan'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Residential')).get('OffThePlan'))=='Yes' 
                ){
            objCollateral.clcommon__Status__c='Off the Plan';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('EstimatedValue'))!=null &&
                (String)((Map<String, Object>)
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue') !=null){
            objCollateral.Estimated_Value__c=Decimal.valueOf((String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue'));
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice'))!=null &&
                (String)((Map<String, Object>)
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice')).get('ContractPriceAmount')!=null){
            objCollateral.Contract_Price_Amount__c=Decimal.valueOf((String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('ContractPrice')).get('ContractPriceAmount'));
            objCollateral.Contract_Of_Sale__c='Yes';
        }else{
            objCollateral.Contract_Of_Sale__c='No';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice')).get('LicencedRealEstateAgentContract'))!=null ){
            objCollateral.Licenced_Real_Estate_Agent_Contract__c=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('ContractPrice')).get('LicencedRealEstateAgentContract');
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice'))!=null &&
                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ContractPrice')).get('Date'))!=null ){
            String contractDate=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('ContractPrice')).get('Date')).get('NodeValue');
            if (contractDate != null && contractDate.length() > 9) {
                objCollateral.clcommon__Contract_Date__c= Date.newInstance(
                    Integer.valueOf(contractDate.substring(0, 4)),
                    Integer.valueOf(contractDate.substring(5, 7)),
                    Integer.valueOf(contractDate.substring(8, 10))
                );
            }
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome'))!=null && 
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome')).get('EvidenceOfTenancy'))!=null ){
            objCollateral.Rental_Income_Verified__c=(String)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('EvidenceOfTenancy');

        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount'))!=null){
            objCollateral.Rental_Income_Amount__c=Decimal.valueOf((String)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount'));
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome'))!=null &&
                ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period'))!=null){
            objCollateral.Rental_Income_Frequency__c=(String)((Map<String,Object>)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period')).get('Unit');
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location'))!=null &&
                ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location')).get('Title'))!=null &&
                ((String)((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location')).get('Title')).get('TitleType'))!=null ){
            if((String)((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)
                    ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('Location')).get('Title')).get('TitleType')=='OldLaw'){
                objCollateral.Title_System__c='Old Law';
            }else{
                objCollateral.Title_System__c=(String)((Map<String,Object>)((Map<String, Object>)
                        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Asset')).get('RealEstate')).get('Location')).get('Title')).get('TitleType');
            }
            
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location'))!=null &&
                ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location')).get('Title'))!=null &&
                ((String)((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('Location')).get('Title')).get('TenureType'))!=null ){
            String tenureType=(String)((Map<String,Object>)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('Location')).get('Title')).get('TenureType');
            if(tenureType=='CommunityTitle'){
                objCollateral.Title_Tenure_Type__c='Community Title';
            }else if(tenureType=='CompanyTitle'){
                objCollateral.Title_Tenure_Type__c='Company Title';
            }else if(tenureType=='CrownLand'){
                objCollateral.Title_Tenure_Type__c='Crown Land';
            }else if(tenureType=='CrownLease'){
                objCollateral.Title_Tenure_Type__c='Crown Lease';
            }else if(tenureType=='GroupTitlesPlan'){
                objCollateral.Title_Tenure_Type__c='Group Titles Plan';
            }else if(tenureType=='MoietyTitle'){
                objCollateral.Title_Tenure_Type__c='Moiety Title';
            }else if(tenureType=='OtherTitle'){
                objCollateral.Title_Tenure_Type__c='Other Title';
            }else if(tenureType=='PurpleTitle'){
                objCollateral.Title_Tenure_Type__c='Purple Title';
            }else if(tenureType=='StrataTitle'){
                objCollateral.Title_Tenure_Type__c='Strata Title';
            }else if(tenureType=='StratumTitle'){
                objCollateral.Title_Tenure_Type__c='Stratum Title';
            }else if(tenureType=='SurveyStrataTitle'){
                objCollateral.Title_Tenure_Type__c='Survey Strata Title';
            }else if(tenureType=='UnitTitle'){
                objCollateral.Title_Tenure_Type__c='Unit Title';
            }else{
                objCollateral.Title_Tenure_Type__c=tenureType;
            }
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact'))!=null &&
                ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact')).get('Type'))!=null){
            String contactType=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                    ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('VisitContact')).get('Type');
            if(contactType=='Customer'){
                objCollateral.Contact_Type__c='Applicant';
            }else if(contactType=='AgentVendor'){
                objCollateral.Contact_Type__c='Property Agent';
            }else{
                objCollateral.Contact_Type__c='Tenant';
            }

        }
        objCollateral.Contact_Name__c='';
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact'))!=null &&
                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName'))!=null &&
                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)
                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName')).get('NameTitle'))!=null){
            objCollateral.Contact_Name__c=(String)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
            ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('VisitContact'))
            .get('PersonName')).get('NameTitle')).get('Value')+' ';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact'))!=null &&
        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName'))!=null &&
        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName')).get('FirstName'))!=null){
            objCollateral.Contact_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName')).get('FirstName')).get('NodeValue')+' ';
        }
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact'))!=null &&
        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName'))!=null &&
        ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName')).get('Surname'))!=null){
            objCollateral.Contact_Name__c+=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('VisitContact')).get('PersonName')).get('Surname')).get('NodeValue');
        }
        Map<String, Object> workPhoneMap=new Map<String, Object> ();
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact'))!=null &&
                ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact')).get('WorkPhone'))!=null){
            workPhoneMap=(Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('VisitContact')).get('WorkPhone');
            if (
                ((Map<String, Object>)workPhoneMap)!= null &&
                String.valueOf(
                ((Map<String, Object>)workPhoneMap
                ))
                .contains('Phone=(')
            ){
                List<Object> refPhone = ((List<Object>) ((Map<String, Object>)workPhoneMap).get('Phone'));
                for (Object eachPhone : refPhone) {
                    if(((Map<String, Object>) eachPhone) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')) != null){
                        if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')).get('AreaCode')!=null){
                            objCollateral.Business_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('AreaCode')+(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('NodeValue');
                        }else{
                            objCollateral.Business_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('NodeValue');
                        }
                            
                    }
                    if(((Map<String, Object>) eachPhone) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('Mobile')) != null){
                        objCollateral.Mobile_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('Mobile')).get('NodeValue');
                    }
                }
            }else if (
                ((Map<String, Object>)workPhoneMap)!= null &&
                String.valueOf(
                ((Map<String, Object>)workPhoneMap
                ))
                .contains('Phone={')
            ){
                Object eachPhone = ((Object) ((Map<String, Object>)workPhoneMap).get('Phone'));
                if(((Map<String, Object>) eachPhone) != null &&
                        ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')) != null){
                        if((String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('FixedPhone')).get('AreaCode')!=null){
                            objCollateral.Business_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('AreaCode')+(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('NodeValue');
                        }else{
                            objCollateral.Business_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('FixedPhone')).get('NodeValue');
                        }
                            
                    }
                    if(((Map<String, Object>) eachPhone) != null &&
                            ((Map<String, Object>) ((Map<String, Object>) eachPhone)
                            .get('Mobile')) != null){
                        objCollateral.Mobile_Phone__c=(String)((Map<String, Object>) ((Map<String, Object>) eachPhone)
                        .get('Mobile')).get('NodeValue');
                    }

            }
        }
        Map<String,Object> titleType=new Map<String,Object>();
        if(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('Location'))!=null &&
            ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('Location')).get('Title'))!=null){
        titleType=(Map<String,Object>)((Map<String, Object>)((Map<String, Object>)
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('Location')).get('Title');
        if (
            ((Map<String, Object>)titleType)!= null &&
            String.valueOf(
            ((Map<String, Object>)titleType
            ))
            .contains('Identifier=(')){
                List<Object> reftitleType = ((List<Object>) ((Map<String, Object>)titleType).get('Identifier'));
                for(Object eachtitleType:reftitleType){
                    
                    if(((Map<String, Object>)eachtitleType)!=null &&
                    ((String)((Map<String, Object>)eachtitleType).get('Name')) !=null){
                        if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensLot'){
                            objCollateral.Title_Lot__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensFolio'){
                            objCollateral.Title_Folio__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensVolume'){
                            objCollateral.Title_Volume__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensTitleRef'){
                            objCollateral.Title_Reference__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensPlanType'){
                            objCollateral.Title_Plan__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }
                    }
                }
        }else if (
                ((Map<String, Object>)titleType)!= null &&
                String.valueOf(
                ((Map<String, Object>)titleType
                ))
                .contains('Identifier={')){
                Object eachtitleType = ((Object) ((Map<String, Object>)titleType).get('Identifier'));
                    if(((Map<String, Object>)eachtitleType)!=null &&
                    ((String)((Map<String, Object>)eachtitleType).get('Name')) !=null){
                        if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensLot'){
                            objCollateral.Title_Lot__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensFolio'){
                            objCollateral.Title_Folio__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensVolume'){
                            objCollateral.Title_Volume__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensTitleRef'){
                            objCollateral.Title_Reference__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }else if((String)((Map<String, Object>)eachtitleType).get('Name')=='TorrensPlanType'){
                            objCollateral.Title_Plan__c=(String)((Map<String, Object>)eachtitleType).get('Value');
                        }
                    }
            }
        }
    }

    public static void parseAssetLiabilityDetail(
        Map<String,Object> eachValueItem,
        genesis__Asset_Information__c objAssetInfo,
        genesis__Liability__c objLiability,
        Decimal percent,
        Map<String,String> existingMortgageMap
    ){
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')) !=null &&
            ((String) ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose')) !=null){
                String primaryPurpose=(String) ((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem).get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose');
                if(primaryPurpose=='OwnerOccupied'){
                    objAssetInfo.genesis__Asset_Type__c='Owner Occupied Property';
                }else if(primaryPurpose=='Investment'){
                    objAssetInfo.genesis__Asset_Type__c='Investment Property';
                }else if(primaryPurpose=='BusinessEquity' || primaryPurpose=='Cash' ||
                        primaryPurpose=='CashManagement' || primaryPurpose=='ChequeAccount' || 
                        primaryPurpose=='Collections' || primaryPurpose=='DebentureCharge' ||
                        primaryPurpose=='GoodwillOfBusiness' || primaryPurpose=='Guarantee' ||
                        primaryPurpose=='LifeInsurance' || primaryPurpose=='Other' ||
                        primaryPurpose=='OtherDepositAccount' || primaryPurpose=='PensionAccount' ||
                        primaryPurpose=='Receivables' || primaryPurpose=='StockAndMachinery' ||
                        primaryPurpose=='ToolsOfTrade' || primaryPurpose=='PersonalEquityInAnyPrivateBusiness'){
                    objAssetInfo.genesis__Asset_Type__c='Other Assets';
                }else if(primaryPurpose=='SavingsAccount' || primaryPurpose=='InvestmentSavings'){
                    objAssetInfo.genesis__Asset_Type__c='Savings';
                }else if(primaryPurpose=='ManagedFunds'){
                    objAssetInfo.genesis__Asset_Type__c='Investments';
                }else if(primaryPurpose=='HomeContents'){
                    objAssetInfo.genesis__Asset_Type__c='Home Contents & Other Personal Assets';
                }else if(primaryPurpose=='Boat'){
                    objAssetInfo.genesis__Asset_Type__c='Other Vehicles';
                }else if(primaryPurpose=='TermDeposit'){
                    objAssetInfo.genesis__Asset_Type__c='Term Deposits';
                }else if(primaryPurpose=='MotorVehicle'){
                    objAssetInfo.genesis__Asset_Type__c='Motor Vehicle';
                }else{
                    objAssetInfo.genesis__Asset_Type__c=primaryPurpose;
                }
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')) !=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('EstimatedValue')) !=null &&
            ((String)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue'))!=null){
                objAssetInfo.genesis__Market_Value__c=(Decimal.valueOf((String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('EstimatedValue')).get('NodeValue')))*percent;
        }
        
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null && 
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')) !=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('OtherAsset')) !=null && 
            ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('OtherAsset')).get('OtherAssetDescription')) !=null){
                objAssetInfo.Address__c=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('NonRealEstate')).get('OtherAsset')).get('OtherAssetDescription');
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate'))!=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')) !=null &&
            ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount')) !=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
            ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period')) !=null){
                if((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period')).get('Unit')=='Weekly'){
                    objAssetInfo.Monthly_Income__c=(decimal)((decimal)52/12*((Decimal.valueOf((String)
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount')))*percent));
                }else if((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)
                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period')).get('Unit')=='Fortnightly'){
                    objAssetInfo.Monthly_Income__c=(decimal)((decimal)26/12*((Decimal.valueOf((String)
                    ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount')))*percent));
                }else if((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)
                ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('RealEstate')).get('RentalIncome')).get('Period')).get('Unit')=='Yearly'){
                    objAssetInfo.Monthly_Income__c=(decimal)((Decimal.valueOf((String)((Map<String, Object>)
                    ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Asset')).get('RealEstate')).get('RentalIncome')).get('RentalAmount')))*percent)/12;
                }
        }
        if(((Map<String, Object>) eachValueItem) != null &&
        ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')) !=null &&
        ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
        .get('Asset')).get('RealEstate')) !=null){
            if((String.valueOf(
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')))
            .contains('ExistMortgage=('))){
                List<Object> existingMortageObjectList=((List<Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ExistMortgage'));
                for(Object eachexistingMortage:existingMortageObjectList){
                    if(((Map<String, Object>)((Map<String, Object>)eachexistingMortage).get('RelatedEntityRef')) !=null){
                        existingMortgageMap.put((String)((Map<String, Object>)((Map<String, Object>)eachexistingMortage)
                        .get('RelatedEntityRef')).get('NodeValue'),
                        (String) ((Map<String, Object>)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose'));
                    }
            }}else if((String.valueOf(
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')))
            .contains('ExistMortgage={'))){
                Object eachexistingMortage=((Object)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('RealEstate')).get('ExistMortgage'));
                    if(((Map<String, Object>)((Map<String, Object>)eachexistingMortage).get('RelatedEntityRef')) !=null){
                        existingMortgageMap.put((String)((Map<String, Object>)((Map<String, Object>)eachexistingMortage)
                        .get('RelatedEntityRef')).get('NodeValue'),
                        (String) ((Map<String, Object>)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Asset')).get('RealEstate')).get('PropertyPrimaryPurpose'));
                    }
                
            }
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')) !=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('OtherAsset')) !=null &&
            ((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('OtherAsset')).get('OtherAssetType')) !=null){
                String primaryPurpose=(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem).get('Asset')).get('NonRealEstate')).get('OtherAsset')).get('OtherAssetType');
                if(primaryPurpose=='BusinessEquity' || primaryPurpose=='Cash' ||
                        primaryPurpose=='CashManagement' || primaryPurpose=='ChequeAccount' || 
                        primaryPurpose=='Collections' || primaryPurpose=='DebentureCharge' ||
                        primaryPurpose=='GoodwillOfBusiness' || primaryPurpose=='Guarantee' ||
                        primaryPurpose=='LifeInsurance' || primaryPurpose=='Other' ||
                        primaryPurpose=='OtherDepositAccount' || primaryPurpose=='PensionAccount' ||
                        primaryPurpose=='Receivables' || primaryPurpose=='StockAndMachinery' ||
                        primaryPurpose=='ToolsOfTrade' || primaryPurpose=='PersonalEquityInAnyPrivateBusiness'){
                    objAssetInfo.genesis__Asset_Type__c='Other Assets';
                }else if(primaryPurpose=='SavingsAccount' || primaryPurpose=='InvestmentSavings'){
                    objAssetInfo.genesis__Asset_Type__c='Savings';
                }else if(primaryPurpose=='ManagedFunds'){
                    objAssetInfo.genesis__Asset_Type__c='Investments';
                }else if(primaryPurpose=='HomeContents'){
                    objAssetInfo.genesis__Asset_Type__c='Home Contents & Other Personal Assets';
                }else if(primaryPurpose=='Boat'){
                    objAssetInfo.genesis__Asset_Type__c='Other Vehicles';
                }else if(primaryPurpose=='TermDeposit'){
                    objAssetInfo.genesis__Asset_Type__c='Term Deposits';
                }else if(primaryPurpose=='MotorVehicle'){
                    objAssetInfo.genesis__Asset_Type__c='Motor Vehicle';
                }
                else{
                    objAssetInfo.genesis__Asset_Type__c=primaryPurpose;
                }
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')) !=null &&
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')) !=null &&
            ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('EstimatedValue')) !=null &&
            ((String)((Map<String, Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Asset')).get('NonRealEstate')).get('EstimatedValue')).get('NodeValue')) !=null){
                objAssetInfo.genesis__Market_Value__c=(Decimal.valueOf((String)((Map<String, Object>)
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Asset')).get('NonRealEstate')).get('EstimatedValue')).get('NodeValue')))*percent;
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('Type')) !=null){
                String liabilityType=(String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Liability')).get('Type');
                if(liabilityType=='CreditCard'){
                    objLiability.genesis__Liability_Type__c='Credit Card';
                }else if(liabilityType=='PersonalLoan'){
                    objLiability.genesis__Liability_Type__c='Personal Loan';
                }else if(liabilityType=='OutstandingTaxation'){
                    objLiability.genesis__Liability_Type__c='ATO Debt';
                }else if(liabilityType=='CommercialBill' || liabilityType=='ContingentLiability' ||
                liabilityType=='HECS' || liabilityType=='HirePurchase' ||
                liabilityType=='Lease' || liabilityType=='LineOfCredit' || 
                liabilityType=='LoanAsGuarantor' || liabilityType=='Maintenance' || 
                liabilityType=='OtherLoan' || liabilityType=='Overdraft' || liabilityType=='StoreCard' ||
                liabilityType=='TermLoan' || liabilityType=='Other'  ){
                    objLiability.genesis__Liability_Type__c='Other Debt';
                }else if(liabilityType=='MortgageLoan' && 
                existingMortgageMap.containsKey(((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Identifier')).get('NodeValue'))) && 
                existingMortgageMap.get(((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Identifier')).get('NodeValue'))) =='Investment'){
                    objLiability.genesis__Liability_Type__c='Investment Property';
                }else if(liabilityType=='MortgageLoan'){
                    objLiability.genesis__Liability_Type__c='Owner Occupied Property';
                }
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ScheduledBalance')) !=null &&
            Decimal.valueOf((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ScheduledBalance'))>0){
                objLiability.genesis__Original_Amount__c=Decimal.valueOf(((String)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Liability')).get('ScheduledBalance')))*percent;
        }else if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('UnpaidBalance')) !=null ){
                objLiability.genesis__Original_Amount__c=Decimal.valueOf(((String)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Liability')).get('UnpaidBalance')))*percent;
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')) !=null &&
            ((Map<String,Object>)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')).get('Repayments')) !=null &&
            ((String)((Map<String,Object>)
            ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')).get('Repayments')).get('Value')) !=null){
                objLiability.genesis__Payment_Amount__c=Decimal.valueOf((String)((Map<String,Object>)
                ((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Liability')).get('ExistingLoan')).get('Repayments')).get('Value'))*percent;
        }
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((Map<String,Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')) !=null &&
            ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')).get('ClearingFromThisLoan')) !=null &&
            ((String)((Map<String, Object>)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('ExistingLoan')).get('ClearingFromThisLoan'))=='Yes'){
                objLiability.To_Be_Refinanced__c=true;
        }
        
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Liability')).get('Description')) !=null && objLiability.genesis__Name_of_Creditor__c==''){
                objLiability.genesis__Name_of_Creditor__c=(String)((Map<String, Object>) 
                ((Map<String, Object>) eachValueItem)
                .get('Liability')).get('Description');
        }
    }

    public static void parseExpenseDetail(
        Map<String,Object> eachValueItem,
        clcommon__Party__c objParty,
        Decimal percent
    ){
        if(((Map<String, Object>) eachValueItem) != null &&
            ((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Expense')) !=null &&
            ((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
            .get('Expense')).get('Type')) !=null && 
            ((String) ((Map<String, Object>) eachValueItem)
            .get('Value')) !=null
        ){
                if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Expense')).get('Type')=='Board'  ||
                    (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Expense')).get('Type')=='Rent'){
                    objParty.Rent_Board_Monthly_Amount__c=objParty.Rent_Board_Monthly_Amount__c+Decimal.valueOf(
                        (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem).get('Expense'))
                        .get('Type')=='ClothingPersonalCare'){
                    if(objParty.Clothing_Personal_Care__c!=null){
                        objParty.Clothing_Personal_Care__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Clothing_Personal_Care__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                    .get('Expense')).get('Type')=='Childcare'){
                    if(objParty.Childcare_Monthly_Income__c!=null){
                        objParty.Childcare_Monthly_Income__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Childcare_Monthly_Income__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='ChildMaintenance'){
                    if(objParty.Maintenance_Alimony__c!=null){
                        objParty.Maintenance_Alimony__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Maintenance_Alimony__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Expense')).get('Type')=='EducationPublic'){
                    if(objParty.Education_excluding_Private_School_Fees__c!=null){
                        objParty.Education_excluding_Private_School_Fees__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Education_excluding_Private_School_Fees__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Expense')).get('Type')=='EducationPrivate'){
                    if(objParty.Education_Private_School_Fees__c!=null){
                        objParty.Education_Private_School_Fees__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Education_Private_School_Fees__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='InsuranceMedical'){
                    if(objParty.Private_Health_Life_and_IP_Insurance__c!=null){
                        objParty.Private_Health_Life_and_IP_Insurance__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Private_Health_Life_and_IP_Insurance__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if(((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='EducationTertiary' ||
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='OtherExpenses' ||
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='OwnerOccupiedLandTaxBodyCorpAndStrataFees'  ||
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='Other'  ||
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='SecondaryResidenceCosts'  ||
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='InsurancesOther') && 
                (String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('ContinuingAfterSettlement')!=null){
                    if(objParty.Other_Expenses__c!=null){
                        objParty.Other_Expenses__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Other_Expenses__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Expense')).get('Type')=='Groceries'){
                    if(objParty.Groceries__c!=null){
                        objParty.Groceries__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Groceries__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Expense')).get('Type')=='InsuranceGeneral'){
                    if(objParty.Insurance__c!=null){
                        objParty.Insurance__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Insurance__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }
                else if((String)((Map<String, Object>) 
                        ((Map<String, Object>) eachValueItem).get('Expense')).get('Type')=='InvestmentUtilities'){
                    if(objParty.Investment_Property_Costs__c!=null){
                        objParty.Investment_Property_Costs__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Investment_Property_Costs__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='MedicalHealth'){
                    if(objParty.Medical_Health__c!=null){
                        objParty.Medical_Health__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Medical_Health__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                .get('Expense')).get('Type')=='PrimaryResidenceCosts'){
                    if(objParty.Primary_Residence_Property_Costs__c!=null){
                        objParty.Primary_Residence_Property_Costs__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Primary_Residence_Property_Costs__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='Recreation'){
                    if(objParty.Recreation_Entertainment__c!=null){
                        objParty.Recreation_Entertainment__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Recreation_Entertainment__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='TelephoneInternet'){
                    if(objParty.Telephone_Media_Streaming_Amount__c!=null){
                        objParty.Telephone_Media_Streaming_Amount__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Telephone_Media_Streaming_Amount__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }else if((String)((Map<String, Object>) ((Map<String, Object>) eachValueItem)
                        .get('Expense')).get('Type')=='Transport'){
                    if(objParty.Transport_Monthly_Amount__c!=null){
                        objParty.Transport_Monthly_Amount__c+=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }else{
                        objParty.Transport_Monthly_Amount__c=Decimal.valueOf(
                            (String) ((Map<String, Object>) eachValueItem).get('Value'))*percent;
                    }
                }
        }
    }

}
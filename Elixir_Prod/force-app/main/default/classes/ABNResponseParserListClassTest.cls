/********************
Developer - Rameswari Barman
Development Date - 23/01/2020
Description - Test class for ABNResponseParserListClass
*********************/
@IsTest
public class ABNResponseParserListClassTest {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{\"response\":{\"businessEntity\":{\"mainBusinessPhysicalAddress\":{\"effectiveTo\":\"0000-12-30\",\"effectiveFrom\":\"2014-09-18\",\"postcode\":3131,\"stateCode\":\"VIC\"},\"mainTradingName\":{\"effectiveFrom\":\"2011-10-28\",\"organisationName\":\"LALISSE AUSTRALIA PTY LTD\"},\"mainName\":[{\"effectiveFrom\":\"2010-11-23\",\"organisationName\":\"LALISSE AUSTRALIA PTY LTD\"}],\"goodsAndServicesTax\":{\"effectiveTo\":\"0000-12-30\",\"effectiveFrom\":\"2001-05-01\"},\"entityType\":{\"entityDescription\":\"Australian Private Company\",\"entityTypeCode\":\"PRV\"},\"ASICNumber\":95926640,\"entityStatus\":{\"effectiveTo\":\"0000-12-30\",\"effectiveFrom\":\"2001-05-01\",\"entityStatusCode\":\"Active\"},\"ABN\":[{\"replacedFrom\":\"0000-12-30\",\"isCurrentIndicator\":\"Y\",\"identifierValue\":36095926640},{\"replacedFrom\":\"2001-05-01\",\"replacedIdentifierValue\":54095726640,\"isCurrentIndicator\":\"Y\",\"identifierValue\":36095926640}],\"recordLastUpdatedDate\":\"2016-10-28\"},\"dateTimeRetrieved\":\"2020-01-22T17:27:12.7486812+11:00\",\"dateRegisterLastUpdated\":\"2020-01-22\",\"usageStatement\":\"The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.\"},\"request\":{\"identifierSearchRequest\":{\"history\":\"N\",\"identifierValue\":36095926640,\"identifierType\":\"ABN\",\"authenticationGUID\":\"c74fa70d-610f-4a9c-9703-2321c82ce510\"}}}';
        ABNResponseParserListClass r = ABNResponseParserListClass.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.EntityType objEntityType = new ABNResponseParserListClass.EntityType(System.JSON.createParser(json));
        System.assert(objEntityType != null);
        System.assert(objEntityType.entityDescription == null);
        System.assert(objEntityType.entityTypeCode == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.Response objResponse = new ABNResponseParserListClass.Response(System.JSON.createParser(json));
        System.assert(objResponse != null);
        System.assert(objResponse.businessEntity == null);
        System.assert(objResponse.dateTimeRetrieved == null);
        System.assert(objResponse.dateRegisterLastUpdated == null);
        System.assert(objResponse.usageStatement == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.MainBusinessPhysicalAddress objMainBusinessPhysicalAddress = new ABNResponseParserListClass.MainBusinessPhysicalAddress(System.JSON.createParser(json));
        System.assert(objMainBusinessPhysicalAddress != null);
        System.assert(objMainBusinessPhysicalAddress.effectiveTo == null);
        System.assert(objMainBusinessPhysicalAddress.effectiveFrom == null);
        System.assert(objMainBusinessPhysicalAddress.postcode == null);
        System.assert(objMainBusinessPhysicalAddress.stateCode == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.GoodsAndServicesTax objGoodsAndServicesTax = new ABNResponseParserListClass.GoodsAndServicesTax(System.JSON.createParser(json));
        System.assert(objGoodsAndServicesTax != null);
        System.assert(objGoodsAndServicesTax.effectiveTo == null);
        System.assert(objGoodsAndServicesTax.effectiveFrom == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.MainTradingName objMainTradingName = new ABNResponseParserListClass.MainTradingName(System.JSON.createParser(json));
        System.assert(objMainTradingName != null);
        System.assert(objMainTradingName.effectiveFrom == null);
        System.assert(objMainTradingName.organisationName == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.IdentifierSearchRequest objIdentifierSearchRequest = new ABNResponseParserListClass.IdentifierSearchRequest(System.JSON.createParser(json));
        System.assert(objIdentifierSearchRequest != null);
        System.assert(objIdentifierSearchRequest.history == null);
        System.assert(objIdentifierSearchRequest.identifierValue == null);
        System.assert(objIdentifierSearchRequest.identifierType == null);
        System.assert(objIdentifierSearchRequest.authenticationGUID == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass objABNResponseParser = new ABNResponseParserListClass(System.JSON.createParser(json));
        System.assert(objABNResponseParser != null);
        System.assert(objABNResponseParser.response == null);
        System.assert(objABNResponseParser.request == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.Request objRequest = new ABNResponseParserListClass.Request(System.JSON.createParser(json));
        System.assert(objRequest != null);
        System.assert(objRequest.identifierSearchRequest == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.EntityStatus objEntityStatus = new ABNResponseParserListClass.EntityStatus(System.JSON.createParser(json));
        System.assert(objEntityStatus != null);
        System.assert(objEntityStatus.effectiveTo == null);
        System.assert(objEntityStatus.effectiveFrom == null);
        System.assert(objEntityStatus.entityStatusCode == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.BusinessEntity objBusinessEntity = new ABNResponseParserListClass.BusinessEntity(System.JSON.createParser(json));
        System.assert(objBusinessEntity != null);
        System.assert(objBusinessEntity.mainBusinessPhysicalAddress == null);
        System.assert(objBusinessEntity.mainTradingName == null);
        System.assert(objBusinessEntity.mainName == null);
        System.assert(objBusinessEntity.goodsAndServicesTax == null);
        System.assert(objBusinessEntity.entityType == null);
        System.assert(objBusinessEntity.ASICNumber == null);
        System.assert(objBusinessEntity.entityStatus == null);
        System.assert(objBusinessEntity.ABN == null);
        System.assert(objBusinessEntity.recordLastUpdatedDate == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ABNResponseParserListClass.ABN objABN = new ABNResponseParserListClass.ABN(System.JSON.createParser(json));
        System.assert(objABN != null);
        System.assert(objABN.replacedFrom == null);
        System.assert(objABN.isCurrentIndicator == null);
        System.assert(objABN.identifierValue == null);
        System.assert(objABN.replacedIdentifierValue == null);
    }
}
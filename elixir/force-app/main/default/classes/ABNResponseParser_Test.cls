@IsTest
public class ABNResponseParser_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"response\": {'+
        '    \"businessEntity\": {'+
        '      \"mainBusinessPhysicalAddress\": {'+
        '        \"effectiveTo\": \"0000-12-30\",'+
        '        \"effectiveFrom\": \"2000-03-29\",'+
        '        \"postcode\": 4310,'+
        '        \"stateCode\": \"QLD\"'+
        '      },'+
        '      \"mainTradingName\": {'+
        '        \"effectiveFrom\": \"2000-03-29\",'+
        '        \"organisationName\": \"DEMAIN ELECTRICAL SERVICES\"'+
        '      },'+
        '      \"mainName\": ['+
        '        {'+
        '          \"effectiveFrom\": \"2006-02-01\",'+
        '          \"organisationName\": \"A DE MAIN & P.A DE MAIN\"'+
        '        },'+
        '        {'+
        '          \"effectiveTo\": \"2006-02-01\",'+
        '          \"effectiveFrom\": \"2002-05-21\",'+
        '          \"organisationName\": \"DEMAIN ARTHUR & PHILLIPA ANN\"'+
        '        },'+
        '        {'+
        '          \"effectiveTo\": \"2002-05-21\",'+
        '          \"effectiveFrom\": \"2001-02-08\",'+
        '          \"organisationName\": \"A & PA DE MAIN\"'+
        '        },'+
        '        {'+
        '          \"effectiveTo\": \"2001-02-08\",'+
        '          \"effectiveFrom\": \"2000-03-29\",'+
        '          \"organisationName\": \"ARTHUR DEMAIN & PHILLIPA A BAKER\"'+
        '        }'+
        '      ],'+
        '      \"goodsAndServicesTax\": {'+
        '        \"effectiveTo\": \"0000-12-30\",'+
        '        \"effectiveFrom\": \"2000-07-01\"'+
        '      },'+
        '      \"entityType\": {'+
        '        \"entityDescription\": \"Family Partnership\",'+
        '        \"entityTypeCode\": \"FPT\"'+
        '      },'+
        '      \"entityStatus\": {'+
        '        \"effectiveTo\": \"0000-12-30\",'+
        '        \"effectiveFrom\": \"2000-03-29\",'+
        '        \"entityStatusCode\": \"Active\"'+
        '      },'+
        '      \"ABN\": {'+
        '        \"replacedFrom\": \"0000-12-30\",'+
        '        \"isCurrentIndicator\": \"Y\",'+
        '        \"identifierValue\": 12449090744'+
        '      },'+
        '      \"recordLastUpdatedDate\": \"2006-02-01\"'+
        '    },'+
        '    \"dateTimeRetrieved\": \"2019-10-18T22:21:12.1290279+11:00\",'+
        '    \"dateRegisterLastUpdated\": \"2019-10-18\",'+
        '    \"usageStatement\": \"The Registrar of the ABR monitors the quality of the information available on this website and updates the information regularly. However, neither the Registrar of the ABR nor the Commonwealth guarantee that the information available through this service (including search results) is accurate, up to date, complete or accept any liability arising from the use of or reliance upon this site.\"'+
        '  },'+
        '  \"request\": {'+
        '    \"identifierSearchRequest\": {'+
        '      \"history\": \"Y\",'+
        '      \"identifierValue\": 12449090744,'+
        '      \"identifierType\": \"ABN\",'+
        '      \"authenticationGUID\": \"c74fa70d-610f-4a9c-9703-2321c82ce510\"'+
        '    }'+
        '  }'+
        '}';
        ABNResponseParser obj = ABNResponseParser.parse(json);
        System.assert(obj != null);
    }
}
/********************************************************************************
Description:    This class acts as the parser class for the response of ABNNameAPI
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

public class ABNResponseParserListClass {

    public class EntityType {
        public String entityDescription {get;set;} 
        public String entityTypeCode {get;set;} 

        public EntityType(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'entityDescription') {
                            entityDescription = parser.getText();
                        } else if (text == 'entityTypeCode') {
                            entityTypeCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'EntityType consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Response {
        public BusinessEntity businessEntity {get;set;} 
        public String dateTimeRetrieved {get;set;} 
        public String dateRegisterLastUpdated {get;set;} 
        public String usageStatement {get;set;} 

        public Response(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'businessEntity') {
                            businessEntity = new BusinessEntity(parser);
                        } else if (text == 'dateTimeRetrieved') {
                            dateTimeRetrieved = parser.getText();
                        } else if (text == 'dateRegisterLastUpdated') {
                            dateRegisterLastUpdated = parser.getText();
                        } else if (text == 'usageStatement') {
                            usageStatement = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Response consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class MainBusinessPhysicalAddress {
        public String effectiveTo {get;set;} 
        public String effectiveFrom {get;set;} 
        public Integer postcode {get;set;} 
        public String stateCode {get;set;} 

        public MainBusinessPhysicalAddress(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'effectiveTo') {
                            effectiveTo = parser.getText();
                        } else if (text == 'effectiveFrom') {
                            effectiveFrom = parser.getText();
                        } else if (text == 'postcode') {
                            postcode = parser.getIntegerValue();
                        } else if (text == 'stateCode') {
                            stateCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'MainBusinessPhysicalAddress consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class GoodsAndServicesTax {
        public String effectiveTo {get;set;} 
        public String effectiveFrom {get;set;} 

        public GoodsAndServicesTax(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'effectiveTo') {
                            effectiveTo = parser.getText();
                        } else if (text == 'effectiveFrom') {
                            effectiveFrom = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'GoodsAndServicesTax consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class MainTradingName {
        public String effectiveFrom {get;set;} 
        public String organisationName {get;set;}
        public String effectiveTo {get;set;} 

        public MainTradingName(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'effectiveFrom') {
                            effectiveFrom = parser.getText();
                        } else if (text == 'effectiveTo') {
                            effectiveTo = parser.getText();
                        }
                         else if (text == 'organisationName') {
                            organisationName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'MainTradingName consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class LegalName {
        public String effectiveFrom {get;set;} 
        public String organisationName {get;set;} 
        public String familyName {get;set;}
        public String givenName {get;set;}
        public String otherGivenName {get;set;}

        public LegalName(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'effectiveFrom') {
                            effectiveFrom = parser.getText();
                        } else if (text == 'organisationName') {
                            organisationName = parser.getText();
                        } 
                        else if (text == 'familyName') {
                            familyName = parser.getText();
                        } 
                        else if (text == 'givenName') {
                            givenName = parser.getText();
                        } 
                        else if (text == 'otherGivenName') {
                            otherGivenName = parser.getText();
                        } 
                        else {
                            System.debug(LoggingLevel.WARN, 'LegalName consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class IdentifierSearchRequest {
        public String history {get;set;} 
        public Long identifierValue {get;set;} 
        public String identifierType {get;set;} 
        public String authenticationGUID {get;set;} 

        public IdentifierSearchRequest(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'history') {
                            history = parser.getText();
                        } else if (text == 'identifierValue') {
                            identifierValue = parser.getLongValue();
                        } else if (text == 'identifierType') {
                            identifierType = parser.getText();
                        } else if (text == 'authenticationGUID') {
                            authenticationGUID = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'IdentifierSearchRequest consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Response response {get;set;} 
    public Request request {get;set;} 

    public ABNResponseParserListClass(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'response') {
                        response = new Response(parser);
                    } else if (text == 'request') {
                        request = new Request(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'ABNResponseParserListClass consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Request {
        public IdentifierSearchRequest identifierSearchRequest {get;set;} 

        public Request(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'identifierSearchRequest') {
                            identifierSearchRequest = new IdentifierSearchRequest(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Request consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class EntityStatus {
        public String effectiveTo {get;set;} 
        public String effectiveFrom {get;set;} 
        public String entityStatusCode {get;set;} 

        public EntityStatus(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'effectiveTo') {
                            effectiveTo = parser.getText();
                        } else if (text == 'effectiveFrom') {
                            effectiveFrom = parser.getText();
                        } else if (text == 'entityStatusCode') {
                            entityStatusCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'EntityStatus consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BusinessEntity {
        public MainBusinessPhysicalAddress mainBusinessPhysicalAddress {get;set;} 
        public MainTradingName mainTradingName {get;set;} 
        public List<MainTradingName> mainName {get;set;} 
        public GoodsAndServicesTax goodsAndServicesTax {get;set;} 
        public EntityType entityType {get;set;} 
        public Integer ASICNumber {get;set;} 
        public EntityStatus entityStatus {get;set;} 
        public List<ABN> ABN {get;set;} 
        public String recordLastUpdatedDate {get;set;} 
        public LegalName legalName {get;set;}

        public BusinessEntity(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'mainBusinessPhysicalAddress') {
                            mainBusinessPhysicalAddress = new MainBusinessPhysicalAddress(parser);
                        } else if (text == 'mainTradingName') {
                            mainTradingName = new MainTradingName(parser);
                        } else if (text == 'mainName') {
                            mainName = arrayOfMainTradingName(parser);
                        } else if (text == 'goodsAndServicesTax') {
                            goodsAndServicesTax = new GoodsAndServicesTax(parser);
                        } else if (text == 'entityType') {
                            entityType = new EntityType(parser);
                        } else if (text == 'ASICNumber') {
                            ASICNumber = parser.getIntegerValue();
                        } else if (text == 'entityStatus') {
                            entityStatus = new EntityStatus(parser);
                        } else if (text == 'ABN') {
                            ABN = arrayOfABN(parser);
                        } else if (text == 'recordLastUpdatedDate') {
                            recordLastUpdatedDate = parser.getText();
                        }else if (text == 'legalName') {
                            legalName = new LegalName(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BusinessEntity consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ABN {
        public String replacedFrom {get;set;} 
        public String isCurrentIndicator {get;set;} 
        public Long identifierValue {get;set;} 
        public Long replacedIdentifierValue {get;set;} 

        public ABN(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'replacedFrom') {
                            replacedFrom = parser.getText();
                        } else if (text == 'isCurrentIndicator') {
                            isCurrentIndicator = parser.getText();
                        } else if (text == 'identifierValue') {
                            identifierValue = parser.getLongValue();
                        } else if (text == 'replacedIdentifierValue') {
                            replacedIdentifierValue = parser.getLongValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ABN consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static ABNResponseParserListClass parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new ABNResponseParserListClass(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    




    private static List<MainTradingName> arrayOfMainTradingName(System.JSONParser p) {
        List<MainTradingName> res = new List<MainTradingName>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MainTradingName(p));
        }
        return res;
    }

    private static List<ABN> arrayOfABN(System.JSONParser p) {
        List<ABN> res = new List<ABN>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ABN(p));
        }
        return res;
    }

}
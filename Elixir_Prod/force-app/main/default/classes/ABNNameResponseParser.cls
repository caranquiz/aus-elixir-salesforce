/********
Developer : Deepro De
Description : Adds as a parser class for ABN Name Response
Development Date : 24/20/2019

*********/
public class ABNNameResponseParser {

    public class Response {
        public SearchResultsList searchResultsList;
        public String dateTimeRetrieved;
        public String dateRegisterLastUpdated;
        public String usageStatement;
    }

    public class MainBusinessPhysicalAddress {
        public String isCurrentIndicator;
        public Integer postcode;
        public String stateCode;
    }

    public class MainName {
        public String isCurrentIndicator;
        public Integer score;
        public String organisationName;
    }

    public class Filters {
        public String activeABNsOnly;
        public StateCode stateCode;
        public NameType nameType;
    }

    public class SearchResultsRecord {
        public MainBusinessPhysicalAddress mainBusinessPhysicalAddress;
        public MainName mainName;
        public ABN ABN;
        public MainName mainTradingName;
        public MainName businessName;
        public MainName otherTradingName;
        public String ASICNumber;
        public EntityStatus entityStatus;
        public EntityType entityType;
        public GoodsAndServicesTax goodsAndServicesTax;
        public LegalName legalName;
        
    }

    public class SearchResultsList {
        public List<SearchResultsRecord> searchResultsRecord;
        public String exceedsMaximum;
        public Integer numberOfRecords;
    }

    public Response response;
    public Request request;

    public class StateCode {
        public String NSW;
        public String TAS;
        public String ACT;
        public String VIC;
        public String WA;
        public String SA;
        public String NT;
        public String QLD;
    }

    public class Request {
        public NameSearchRequestAdvanced2017 nameSearchRequestAdvanced2017;
    }

    public class NameType {
        public String businessName;
        public String legalName;
        public String tradingName;
    }

    public class ABN {
        public String identifierStatus;
        public Long identifierValue;
    }

    public class NameSearchRequestAdvanced2017 {
        public Integer maxSearchResults;
        public Integer minimumScore;
        public String searchWidth;
        public Filters filters;
        public String name;
        public String authenticationGUID;
    }
    
    public class EntityStatus{
        public String entityStatusCode;
        public String effectiveFrom;
    }
    
    public class EntityType{
        public String entityTypeCode;
        public String entityDescription;
    }
    
    public class GoodsAndServicesTax{
        public String effectiveFrom;
        public String effectiveTo;
    }
    
    public class LegalName{
        public String fullName;
        public String score;
        public String isCurrentIndicator;
    }

    
    public static ABNNameResponseParser parse(String json) {
        return (ABNNameResponseParser) System.JSON.deserialize(json, ABNNameResponseParser.class);
    }
}
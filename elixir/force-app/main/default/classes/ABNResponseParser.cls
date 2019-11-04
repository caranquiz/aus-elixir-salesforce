/********************************************************************************
Description:    This class acts as the POJO for the response of ABNNameAPI
Developer:      Deepro De
Created Date:   05/10/2018
*********************************************************************************/

public class ABNResponseParser {

    public class EntityType {
        public String entityDescription;
        public String entityTypeCode;
    }

    public class Response {
        public BusinessEntity businessEntity;
        public String dateTimeRetrieved;
        public String dateRegisterLastUpdated;
        public String usageStatement;
    }

    public class MainBusinessPhysicalAddress {
        public String effectiveTo;
        public String effectiveFrom;
        public Integer postcode;
        public String stateCode;
    }

    public class GoodsAndServicesTax {
        public String effectiveTo;
        public String effectiveFrom;
    }

    public class MainName {
        public String effectiveFrom;
        public String organisationName;
        public String effectiveTo;
    }

    public class IdentifierSearchRequest {
        public String history;
        public Long identifierValue;
        public String identifierType;
        public String authenticationGUID;
    }

    public Response response;
    public Request request;

    public class Request {
        public IdentifierSearchRequest identifierSearchRequest;
    }

    public class EntityStatus {
        public String effectiveTo;
        public String effectiveFrom;
        public String entityStatusCode;
    }

    public class BusinessEntity {
        public MainBusinessPhysicalAddress mainBusinessPhysicalAddress;
        public List<MainName> mainName;
        public GoodsAndServicesTax goodsAndServicesTax;
        public EntityType entityType;
        public Integer ASICNumber;
        public EntityStatus entityStatus;
        public ABN ABN;
        public String recordLastUpdatedDate;
    }

    public class ABN {
        public String replacedFrom;
        public String isCurrentIndicator;
        public Long identifierValue;
    }

    
    public static ABNResponseParser parse(String json) {
        return (ABNResponseParser) System.JSON.deserialize(json, ABNResponseParser.class);
    }
}
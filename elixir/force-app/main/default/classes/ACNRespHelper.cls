public class ACNRespHelper {

    public class EntityType {
        public String entityDescription;
        public String entityTypeCode;
    }

    public class Response {
        public BusinessEntity201408 businessEntity201408;
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
    }

    public class BusinessEntity201408 {
        public MainBusinessPhysicalAddress mainBusinessPhysicalAddress;
        public MainName mainName;
        public GoodsAndServicesTax goodsAndServicesTax;
        public EntityType entityType;
        public Integer ASICNumber;
        public EntityStatus entityStatus;
        public ABN ABN;
        public String recordLastUpdatedDate;
    }

    public class IdentifierSearchRequest {
        public String history;
        public Integer identifierValue;
        public String identifierType;
        public String authenticationGUID;
    }

    public class Request {
        public IdentifierSearchRequest identifierSearchRequest;
    }

    public class EntityStatus {
        public String effectiveTo;
        public String effectiveFrom;
        public String entityStatusCode;
    }

    public class ABN {
        public String replacedFrom;
        public String isCurrentIndicator;
        public Long identifierValue;
    }

    public Response response;
    public Request request;

    
    public static ACNRespHelper parse(String json) {
        return (ACNRespHelper) System.JSON.deserialize(json, ACNRespHelper.class);
    }
    
}
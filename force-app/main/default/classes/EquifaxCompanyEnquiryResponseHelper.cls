public class EquifaxCompanyEnquiryResponseHelper{
	public class CommonException extends Exception {}  
	public static Map<String, Object> findInSummaryData(List<Object> all,String val) {
	if (all == null) {
	return new Map<String, Object>();
		}
	for (Object each : all) {
	if(each == null || ((Map<String, Object>)each).get(ConstantValues.SUMMARY_NAME) == null ){
		continue;
		}
	if ((String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SUMMARY_NAME)).get(ConstantValues.NODE_VALUE) == val) {
		return ((Map<String, Object>)each);
		}
	}
	return new Map<String, Object>();
	}
  
	public static string processAddressLines(Map<String, Object> s){
		String res = '';
		try {
			res += (String)((Map<String, Object>)s.get(ConstantValues.ADDRESS_PREFIX)).get(ConstantValues.NODE_VALUE) + ',';
		} catch(Exception ex) {}
		try {
			res += (String)((Map<String, Object>)s.get(ConstantValues.STREET_DETAILS)).get(ConstantValues.NODE_VALUE) + ',';
		} catch(Exception ex) {}
		try {
			res += (String)((Map<String, Object>)s.get(ConstantValues.LOCALITY_DETAILS)).get(ConstantValues.NODE_VALUE) + ',';
		} catch (Exception ex) {}
		try {
			res += (String)((Map<String, Object>)s.get(ConstantValues.STATE)).get(ConstantValues.NODE_VALUE) + ',';
		} catch (Exception ex) {}
		try {
			res += (String)((Map<String, Object>)s.get(ConstantValues.POSTCODE)).get(ConstantValues.NODE_VALUE) + ' ';
		} catch (Exception ex) {}
		return res;
	}
  
	public static String processAddress(Map<String, Object> s){
	String res = '';
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.UNIT_NUMBER)).get(ConstantValues.NODE_VALUE) + ',';
	} catch(Exception ex) {}
  
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.STREET_NUMBER)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}
  
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.STREET_NAME)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}
  
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.STREET_TYPE)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}
  
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.SUBURB)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}
	
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.STATE)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}
  
	try {
	  	res += (String)((Map<String, Object>)s.get(ConstantValues.POSTCODE)).get(ConstantValues.NODE_VALUE) + ',';
	} catch (Exception ex) {}

	return res;
  	}
	
	public static String parse(String json, clcommon__Party__c partyObj, Map<String, Object> response){
		String returnValue = ConstantValues.COMPANY_ENQUIRY_RESPONSE_RECEIVED_SUCCESSFULLY;
		EquifaxCompanyEnquiryResponseHelper helperObject;
		try{
	  		try{

				String errorForUser = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.FAULT)).get(ConstantValues.DETAIL)).get(ConstantValues.ERROR)).get(ConstantValues.DESCRIPTION)).get(ConstantValues.NODE_VALUE);
				if(errorForUser != null){
		  			return errorForUser;
				}
				
	  		} catch (Exception ex) {
			}
			clearPartyObjectData(partyObj);  
	  		try {
				partyObj.File_Number__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.COMPANY_IDENTITY)).get(ConstantValues.BUREAU_INFO)).get(ConstantValues.BUREAU_REFERENCE)).get(ConstantValues.NODE_VALUE);
	  		} catch(Exception ex) {
			}

	  		try {
				partyObj.Request_Id__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.ORGANISATION_REPORT_HEADER)).get(ConstantValues.REQUEST_ID)).get(ConstantValues.NODE_VALUE);
	  		} catch(Exception ex) {}
	  
			try {
				String reportCreateDate = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.ORGANISATION_REPORT_HEADER)).get(ConstantValues.REPORT_CREATE_DATE)).get(ConstantValues.NODE_VALUE);
				if(reportCreateDate == null){
					throw new CommonException(ConstantValues.DATE_NOT_DEFINED);
				}
				partyObj.Report_Created_Date__c = Date.newInstance(Integer.valueOf(reportCreateDate.substring(0,4)),
				Integer.valueOf(reportCreateDate.substring(5,7)),
				Integer.valueOf(reportCreateDate.substring(8,10)));	
	  		} catch (Exception ex) {}
		
			//Number of credit enquiries
			// try {
			// 	Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), 'Credit_Enquiries');
			// 	if(tempSummaryEntry == null){
			// 		throw new CommonException(ConstantValues.NULL_VALUE);
			// 	}
			// 	partyObj.Number_Of_Credit_Events__c  = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			// } catch(Exception ex) {
			// 	GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
			// 	// return ConstantValues.GENERAL_ERROR;
			// }
	  
	  	 	//Amount of credit enquiries value  
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.CREDIT_ENQUIRIES_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_of_Credit_Enquiry__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
			
			//to insert number of credit enquiry for last 12 months
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Number_of_Credit_Enquiries_in_Last_12_Mo__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch (Exception ex) {}
		
			//to insert amount of credit enquiry for last 12 months
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.CREDIT_ENQUIRIES_LESS_THAN_12_MONTHS_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_of_Credit_Enquiries_in_last_12_mo__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to insert number of credit enquiry for more than 12 months
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.CREDIT_ENQUIRIES_MORE_THAN_12_MONTHS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.No_of_Credit_Enquiries_in_more_than_12_M__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
	  		} catch(Exception ex) {}
  
		    //to insert amount of credit enquiry for more 12 months value
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.CREDIT_ENQUIRIES_MORE_THAN_12_MONTHS_VALUE); 
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_of_Credit_Enquiries_in_more_than__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to find no of external admin
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.EXTERNAL_ADMIN);  
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.External_Administrators__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			}
			catch (Exception ex) {}
		
		 	//payment default count
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Payment_Defaults__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
				} catch(Exception ex) {}
		
				//payment default amount
				try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_of_Payment_Defaults__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
				} catch(Exception ex) {}
		
				//to insert number of payment defaults for last 12 months
				try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS_LESS_THAN_12);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Number_Payment_Defaults_in_last_12_Month__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
				//to insert amount of payment defaults for last 12 months
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS_LESS_THAN_12_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_Payment_Defaults_in_last_12_Month__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
		  //to insert number of payment defaults for more than 12 months
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS_MORE_THAN_12);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Number_Payment_Defaults_in_more_than_12__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to insert amount of payment defaults for more 12 months value
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DEFAULTS_MORE_THAN_12_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Amount_Payment_Defaults_in_more_than_12__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
			
			//for asic extract date
			try {
				// String str1 = helperObject.Envelope.Body.response.companyEnquiryReport.organisationReportHeader.extractDate.asicExtractDate.nodeValue;
				String str1 = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.ORGANISATION_REPORT_HEADER)).get(ConstantValues.EXTRACT_DATE)).get(ConstantValues.ASIC_EXTRACT_DATE)).get(ConstantValues.NODE_VALUE);
				if(str1 == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.ASIC_Extract_Date__c = Date.newInstance(Integer.valueOf(str1.substring(0,4)), Integer.valueOf(str1.substring(5,7)), Integer.valueOf(str1.substring(8,10)));
			} catch (Exception ex) {}
		
			//for incorporation date
			try {
				String strIncorDate = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.COMPANY_IDENTITY)).get(ConstantValues.INCORPORATION)).get(ConstantValues.INCORPORATION_DATE)).get(ConstantValues.NODE_VALUE);
				if(strIncorDate == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Incorporation_Date__c = Date.newInstance(Integer.valueOf(strIncorDate.substring(0,4)), Integer.valueOf(strIncorDate.substring(5,7)), Integer.valueOf(strIncorDate.substring(8,10)));
			} catch (Exception ex) {}
		
			try {
				partyObj.Organization_Status__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.COMPANY_IDENTITY)).get(ConstantValues.ORGANISATION_STATUS)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
			} catch (Exception ex) {}
			
			// for registered office
			try {
				partyObj.Registered_Office__c = processAddressLines(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.COMPANY_IDENTITY)).get(ConstantValues.REGISTERED_OFFICE)).get(ConstantValues.ADDRESS_LINES)));
			} catch (Exception ex) {}
		
				//  to find file create date
			try {
				String fileCreateDate = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.COMPANY_IDENTITY)).get(ConstantValues.BUREAU_INFO)).get(ConstantValues.FILE_CREATION_DATE)).get(ConstantValues.NODE_VALUE);
				if(fileCreateDate == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.File_Create_Date__c = Date.newInstance(Integer.valueOf(fileCreateDate.substring(0,4)), Integer.valueOf(fileCreateDate.substring(5,7)), Integer.valueOf(fileCreateDate.substring(8,10)));
			} catch (Exception ex) {}
		
			//to find court writs
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.WRITS_AND_SUMMONS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Court_Writs__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
				//to find court writs amount
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.WRITS_AND_SUMMONS_VALUE);

				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Court_Writ_Amount__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
				//to find court actions
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.JUDGEMENTS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Court_Actions__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to find court action amount
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.JUDGEMENTS_VALUE);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Court_Action_Amount__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to find petitions count
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.PETITIONS);
				if(tempSummaryEntry == null){
					throw new CommonException(ConstantValues.NULL_VALUE);
				}
				partyObj.Petitions__c = Integer.valueOf((String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE));
			} catch(Exception ex) {}
		
			//to find company director adverse
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DIRECTORS_ADVERSE);
				partyObj.Company_Director_s_Adverse__c = (String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE);
			} catch(Exception ex) {}
		
		  //to find company director related entity adverse
			try {
				Map<String, Object> tempSummaryEntry = findInSummaryData(((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.SUMMARY_DATA)).get(ConstantValues.SUMMARY_ENTRY)), ConstantValues.DIRECTORS_RELATED_ENTITY_ADVERSE);
				partyObj.Company_Director_s_Related_Entity_Advers__c = (String)((Map<String, Object>)tempSummaryEntry.get(ConstantValues.SUMMARY_VALUE)).get(ConstantValues.NODE_VALUE);
			} catch(Exception ex) {}
		
			List<Director__c> entityList =  [SELECT Id,party__c FROM Director__c where party__c = :partyObj.Id]; 
			delete entityList;
			entityList =  new List<Director__c>();
			try {
				if((String.valueOf(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.DIRECTORS_LIST)))).contains(ConstantValues.DIRECTORS_ARRAY)){
					List<Object> refDirectors = ((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.DIRECTORS_LIST)).get(ConstantValues.DIRECTORS));
					for(Object each : refDirectors){
						Director__c dirObj = new Director__c();
						dirObj.Party__c = partyObj.Id;
						dirObj.Entity_Type__c = ConstantValues.DIRECTOR;
						try {
							dirObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)).get(ConstantValues.NODE_VALUE) + ' ' + (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_DIRECTOR)).get(ConstantValues.NODE_VALUE); 
						} catch(Exception ex) {}
				
						try {
							dirObj.Address__c = processAddress(((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ADDRESS)));
						} catch (Exception ex) {}
				
						try {
							dirObj.File_Number__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.BUREAU_REFERENCE)).get(ConstantValues.NODE_VALUE);
						} catch (Exception ex) {}
				
						try {
							String dirDOB = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.DATE_OF_BIRTH)).get(ConstantValues.NODE_VALUE);
							if(dirDOB == null){
								throw new CommonException(ConstantValues.NULL_VALUE);
							}
							dirObj.Date_of_birth__c = Date.newInstance(Integer.valueOf(dirDOB.substring(0,4)), Integer.valueOf(dirDOB.substring(5,7)), Integer.valueOf(dirDOB.substring(8,10)));
						} catch (Exception ex) {}
				
						try {
							dirObj.Gender__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.GENDER)).get(ConstantValues.NODE_VALUE);
						} catch (Exception ex) {}
	
						try {
							dirObj.Resident_Overseas__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.RESIDENCY_OVERSEAS)).get(ConstantValues.NODE_VALUE);
						} catch(Exception ex) {}
				
						entityList.add(dirObj);
					}
				} else {
					Object refDirectors = ((Object)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.DIRECTORS_LIST)).get(ConstantValues.DIRECTORS));
					Director__c dirObj = new Director__c();
						dirObj.Party__c = partyObj.Id;
						dirObj.Entity_Type__c = ConstantValues.DIRECTOR;
						try {
							dirObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)).get(ConstantValues.NODE_VALUE) + ' ' + (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_DIRECTOR)).get(ConstantValues.NODE_VALUE); 
						} catch(Exception ex) {}
				
						try {
							dirObj.Address__c = processAddress(((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.ADDRESS)));
						} catch (Exception ex) {}
				
						try {
							dirObj.File_Number__c = (String)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.BUREAU_REFERENCE)).get(ConstantValues.NODE_VALUE);
						} catch (Exception ex) {}
				
						try {
							String dirDOB = (String)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.DATE_OF_BIRTH)).get(ConstantValues.NODE_VALUE);
							if(dirDOB == null){
								throw new CommonException(ConstantValues.NULL_VALUE);
							}
							dirObj.Date_of_birth__c = Date.newInstance(Integer.valueOf(dirDOB.substring(0,4)), Integer.valueOf(dirDOB.substring(5,7)), Integer.valueOf(dirDOB.substring(8,10)));
						} catch (Exception ex) {}
				
						try {
							dirObj.Gender__c = (String)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.GENDER)).get(ConstantValues.NODE_VALUE);
						} catch (Exception ex) {}
	
						try {
							dirObj.Resident_Overseas__c = (String)((Map<String, Object>)((Map<String, Object>)refDirectors).get(ConstantValues.RESIDENCY_OVERSEAS)).get(ConstantValues.NODE_VALUE);
						} catch(Exception ex) {}
			
						entityList.add(dirObj);
						
					

				}
				
			} catch (Exception ex) {
				GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
				returnValue += ConstantValues.NO_DIRECTORS_FOUND;
			}
					
			try {
				if((String.valueOf(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.SHARE_HOLDER_LIST)))).contains(ConstantValues.SHARE_HOLDER_ARRAY)){
				List<Object> refShareholders = ((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.SHARE_HOLDER_LIST)).get(ConstantValues.SHARE_HOLDER));
				System.debug(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.SHARE_HOLDER_LIST)));
				for(Object each : refShareholders){
					Director__c shareholderObj = new Director__c();
					shareholderObj.Party__c = partyObj.Id;
					shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
					try {
						try {
							shareholderObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)).get(ConstantValues.NODE_VALUE) + ' ' + (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_SHAREHOLDER)).get(ConstantValues.NODE_VALUE); 
						} catch(Exception ex) {
						}
	
						try {
							shareholderObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ORGANISATION_SHARE_HOLDER)).get(ConstantValues.ORGANISATION_NAME)).get(ConstantValues.NODE_VALUE);
						} catch (Exception Ex) {}
					} catch (Exception ex) {}
					
					try {
						shareholderObj.Address__c = processAddressLines(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.ADDRESS_LINES)));
					} catch (Exception ex) {}
			
					try {
						shareholderObj.Beneficially_Held__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.BENEFICIAL_OWNERSHIP)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}

					try {
						shareholderObj.Class_of_shares__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SHARE_CLASS_CODE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}

					try {
						shareholderObj.Number_of_shares_issued__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SHARES_HELD)).get(ConstantValues.NODE_VALUE));
					} catch (Exception ex) {}
			
		  			entityList.add(shareholderObj);
				}

				} else {
					Object refShareholders = ((Object)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.SHARE_HOLDER_LIST)).get(ConstantValues.SHARE_HOLDER));
					System.debug(((Object)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.OWNERSHIP_OFFICERS)).get(ConstantValues.SHARE_HOLDER_LIST)).get(ConstantValues.SHARE_HOLDER)));
					Director__c shareholderObj = new Director__c();
					shareholderObj.Party__c = partyObj.Id;
					shareholderObj.Entity_Type__c = ConstantValues.SHAREHOLDER;
					try {
						try {
							shareholderObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FIRST_GIVEN_NAME)).get(ConstantValues.NODE_VALUE) + ' ' + (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.INDIVIDUAL_NAME)).get(ConstantValues.FAMILY_NAME_SHAREHOLDER)).get(ConstantValues.NODE_VALUE); 
						} catch(Exception ex) {
						}

						try {
							shareholderObj.Entity_Name__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.ORGANISATION_SHARE_HOLDER)).get(ConstantValues.ORGANISATION_NAME)).get(ConstantValues.NODE_VALUE);
						} catch (Exception Ex) {}
					} catch (Exception ex) {}
					
					try {
						shareholderObj.Address__c = processAddressLines(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.INDIVIDUAL_SHARE_HOLDER)).get(ConstantValues.ADDRESS_LINES)));
					} catch (Exception ex) {}
			
					try {
						shareholderObj.Beneficially_Held__c = (String)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.BENEFICIAL_OWNERSHIP)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}

					try {
						shareholderObj.Class_of_shares__c = (String)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.SHARE_CLASS_CODE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}

					try {
						shareholderObj.Number_of_shares_issued__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)refShareholders).get(ConstantValues.SHARES_HELD)).get(ConstantValues.NODE_VALUE));
					} catch (Exception ex) {}
					entityList.add(shareholderObj);
				}

				
	  		} catch (Exception ex) {
				GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
				returnValue += ConstantValues.NO_SHAREHOLDERS_FOUND;  
			}
			

			try {
				List<Object> refRegistrationList = ((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_LIST)).get(ConstantValues.REGISTRATION_DETAIL));
				System.debug(((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_LIST)));
				for(Object each : refRegistrationList){
					Director__c registrationListObj = new Director__c();
					registrationListObj.Party__c = partyObj.Id;
					registrationListObj.Entity_Type__c = ConstantValues.REGISTRATIONS;
					try {
						registrationListObj.Registration_Number__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.REGISTRATION_NUMBER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {
						GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
					}

					try {
						String startDate = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.REGISTRATION_START_DATE)).get(ConstantValues.NODE_VALUE);
						if(startDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						registrationListObj.Start_Date__c = Date.newInstance(Integer.valueOf(startDate.substring(0,4)), Integer.valueOf(startDate.substring(5,7)), Integer.valueOf(startDate.substring(8,10)));
					} catch (Exception ex) {
						GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
					}
		
					try {
						registrationListObj.Migration__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.MIGRATED_FLAG)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
		
					try {
						registrationListObj.Collateral__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.COLLATERAL_CLASS)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
		
					try {
						registrationListObj.Pmsi__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.PMSI_FLAG)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {
						GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
					}
		
					try {
						registrationListObj.Secured_Parties__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SECURED_PARTIES)).get(ConstantValues.SECURED_PARTY)).get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NAME)).get(ConstantValues.NODE_VALUE) +','
						+(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SECURED_PARTIES)).get(ConstantValues.SECURED_PARTY)).get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NUMBER_TYPE)).get(ConstantValues.NODE_VALUE) +','
						+(String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.SECURED_PARTIES)).get(ConstantValues.SECURED_PARTY)).get(ConstantValues.ORGANISATION)).get(ConstantValues.ORGANISATION_NUMBER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {
						GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
					}
					entityList.add(registrationListObj);
				}
			} catch (Exception ex) {
				GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
				returnValue += ConstantValues.NO_REGISTRATION_LIST_FOUND;
			}
			


	  		List<Credit_Enquiry__c> finalCreditEnquiryList;
	  		finalCreditEnquiryList = [SELECT Id, party__c FROM Credit_Enquiry__c where party__c = :partyObj.Id]; 
	  		delete finalCreditEnquiryList;
	  		try{
				finalCreditEnquiryList = new List<Credit_Enquiry__c>();
				List<Object> refCreditEnquiry = ((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.ORGANISATION_CREDIT_HISTORY)).get(ConstantValues.ALL_CREDIT_ENQUIRY_LIST)).get(ConstantValues.CREDIT_ENQUIRY_LIST)).get(ConstantValues.CREDIT_ENQUIRY));
				for(Object each: refCreditEnquiry){
		  			Credit_Enquiry__c creditEnquiryObj = new Credit_Enquiry__c();
					creditEnquiryObj.Party__c = partyObj.Id;
					try{
						creditEnquiryObj.Account_Type__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {
					}
					try {
						creditEnquiryObj.Credit_Enquirer__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ENQUIRER)).get(ConstantValues.NODE_VALUE);
					} catch(Exception ex) {}

					try {
						String strEnqAmount = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.AMOUNT)).get(ConstantValues.NODE_VALUE);
						if(strEnqAmount == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditEnquiryObj.Enquiry_amount__c = Decimal.valueOf(strEnqAmount);
					} catch (Exception ex) {}
					try {
						String strEnqDat = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ENQUIRY_DATE)).get(ConstantValues.NODE_VALUE);
						if(strEnqDat == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditEnquiryObj.Enquiry_Date__c = Date.newInstance(Integer.valueOf(strEnqDat.substring(0,4)),
						Integer.valueOf(strEnqDat.substring(5,7)), Integer.valueOf(strEnqDat.substring(8,10)));
					} catch (Exception ex) {}
					try {
						creditEnquiryObj.Reference_No__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.REF_NUMBER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditEnquiryObj.Role_in_Enquiry__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ROLE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
		
					finalCreditEnquiryList.add(creditEnquiryObj);
				}
			} catch (Exception ex) {
				GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
				returnValue += ConstantValues.NO_CREDIT_ENQUIRIES_FOUND;
			}
				  
	  		PPSR_Registration__c ppsrRegistrationData;
	  		List<PPSR_Registration__c> ppsrRegistrationList = [SELECT Party__c,Id FROM PPSR_Registration__c where Party__c =:partyObj.id];
			if(ppsrRegistrationList.isEmpty()){
				ppsrRegistrationData = new PPSR_Registration__c();
				ppsrRegistrationData.Party__c = partyObj.Id;
				insert ppsrRegistrationData;
		    } else{
				ppsrRegistrationData = ppsrRegistrationList[0];
				ppsrRegistrationData.Organisation_number__c = null;
				ppsrRegistrationData.Search_Date__c = null;
				ppsrRegistrationData.Search_Number__c = null;
				ppsrRegistrationData.Search_Type__c = null;
				ppsrRegistrationData.Total_PMSI_Registrations__c = null;
				ppsrRegistrationData.Total_Registrations__c = null;
				ppsrRegistrationData.Total_Registrations_Designated_Secured_P__c = null;
				ppsrRegistrationData.Total_Registrations_Other_Financier_Secu__c = null;
			}
	  		try {
				try {
		  			ppsrRegistrationData.Organisation_number__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REPORT_INFORMATION)).get(ConstantValues.GRANTOR_SEARCH_CRITERIA)).get(ConstantValues.ORGANISATION_NUMBER)).get(ConstantValues.NODE_VALUE);
				} catch (Exception ex){}

				try {
					String searchDatePPSR = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REPORT_INFORMATION)).get(ConstantValues.SEARCH_DATE)).get(ConstantValues.NODE_VALUE);
					if(searchDatePPSR == null){
						throw new CommonException(ConstantValues.NULL_VALUE);
					}
					ppsrRegistrationData.Search_Date__c = Date.newInstance(Integer.valueOf(searchDatePPSR.substring(0,4)),
					Integer.valueOf(searchDatePPSR.substring(5,7)),
					Integer.valueOf(searchDatePPSR.substring(8,10)));
					} catch (Exception ex){}
				try {
				ppsrRegistrationData.Search_Number__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REPORT_INFORMATION)).get(ConstantValues.SEARCH_NUMBER)).get(ConstantValues.NODE_VALUE);
				} catch (Exception ex){}
				try {
				ppsrRegistrationData.Search_Type__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REPORT_INFORMATION)).get(ConstantValues.SEARCH_TYPE)).get(ConstantValues.NODE_VALUE);
				} catch (Exception ex){}
				try {
				ppsrRegistrationData.Total_PMSI_Registrations__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_SUMMARY)).get(ConstantValues.TOTAL_PMSI_REGISTRATIONS)).get(ConstantValues.NODE_VALUE));
				} catch (Exception ex){}
				try {
				ppsrRegistrationData.Total_Registrations__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_SUMMARY)).get(ConstantValues.TOTAL_REGISTRATIONS)).get(ConstantValues.NODE_VALUE));
				} catch (Exception ex){}
				try {
				ppsrRegistrationData.Total_Registrations_Designated_Secured_P__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_SUMMARY)).get(ConstantValues.TOTAL_REGISTRATIONS_DESIGNATED_SECURED_PARTIES)).get(ConstantValues.NODE_VALUE));
				} catch (Exception ex){}
				try {
				ppsrRegistrationData.Total_Registrations_Other_Financier_Secu__c = Decimal.valueOf((String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.PPSR_REGISTRATIONS)).get(ConstantValues.REGISTRATION_SUMMARY)).get(ConstantValues.TOTAL_REGISTRATIONS_OTHER_FINANCIER_SECURED_PARTIES)).get(ConstantValues.NODE_VALUE));
				} catch (Exception ex){}

			} catch (Exception Ex) {
				GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
			  	return ConstantValues.NO_PPSR_REGISTRATIONS_FOUND;
			}

	  		List<Credit_Account__c> creditAccountList= [SELECT Party__c, Id FROM Credit_Account__c WHERE Party__c = :partyObj.Id];
			delete creditAccountList;
			creditAccountList = new List<Credit_Account__c>();
	  		try {
				if(String.valueOf((((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.ORGANISATION_CREDIT_HISTORY)).get(ConstantValues.PAYMENT_DEFAULT_LIST)))).contains(ConstantValues.PAYMENT_DEFAULT_ARRAY)){
					List<Object> refCreditAccount = ((List<Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.ORGANISATION_CREDIT_HISTORY)).get(ConstantValues.PAYMENT_DEFAULT_LIST)).get(ConstantValues.PAYMENT_DEFAULTS));

				for(Object each : refCreditAccount){
					Credit_Account__c creditAccountObj = new Credit_Account__c();
					creditAccountObj.Party__c = partyObj.id;
					try {
						creditAccountObj.Account_Type__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Role__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ROLE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Account_Number__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ACCOUNT_NUMBER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Latest_Credit_Provider__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.PROVIDER)).get(ConstantValues.NODE_VALUE);
					} catch(Exception ex) {}
					try {
						creditAccountObj.Original_Credit_Provider__c = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ORIGINAL_PROVIDER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try{
						String strCurrDefAmt = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.AMOUNT)).get(ConstantValues.NODE_VALUE);
						if(strCurrDefAmt == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(strCurrDefAmt);
					} catch (Exception ex) {}

					try {
						String strDefDate = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.DEFAULT_DATE)).get(ConstantValues.NODE_VALUE);
						if(strDefDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Default_Date__c = Date.newInstance(Integer.valueOf(strDefDate.substring(0,4)),
						Integer.valueOf(strDefDate.substring(5,7)),
						Integer.valueOf(strDefDate.substring(8,10)));
					} catch (Exception ex) {}

					try {
						creditAccountObj.Report_Reason__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.REPORT_REASON)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						String orgDefDate = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ORIGINAL_DEFAULT_DATE)).get(ConstantValues.NODE_VALUE);
						if(orgDefDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Original_Default_Date__c = Date.newInstance(Integer.valueOf(orgDefDate.substring(0,4)),
						Integer.valueOf(orgDefDate.substring(5,7)),
						Integer.valueOf(orgDefDate.substring(8,10)));
					} catch (Exception ex) {}
					try {
						String strDefaultAmount = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ORIGINAL_AMOUNT)).get(ConstantValues.NODE_VALUE);
						if(strDefaultAmount == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Original_Default_Amount__c = Decimal.valueOf(strDefaultAmount);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Original_Report_Reason__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.ORIGINAL_REPORT_REASON)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Status__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.PAYMENT_STATUS)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						String statDate = (String)((Map<String, Object>)((Map<String, Object>)each).get(ConstantValues.STATUS_DATE)).get(ConstantValues.NODE_VALUE);
						if(statDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Status_Date__c = Date.newInstance(Integer.valueOf(statDate.substring(0,4)),
						Integer.valueOf(statDate.substring(5,7)),
						Integer.valueOf(statDate.substring(8,10)));
					} catch (Exception ex) {}
		  			creditAccountList.add(creditAccountObj);
				}	
				} else {
					Object refCreditAccount = ((Object)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)response.get(ConstantValues.ENVELOPE_KEY)).get(ConstantValues.BODY_KEY)).get(ConstantValues.RESPONSE_KEY)).get(ConstantValues.COMPANY_ENQUIRY_REPORT)).get(ConstantValues.COMPANY_RESPONSE)).get(ConstantValues.ORGANISATION_CREDIT_HISTORY)).get(ConstantValues.PAYMENT_DEFAULT_LIST)).get(ConstantValues.PAYMENT_DEFAULTS));
					Credit_Account__c creditAccountObj = new Credit_Account__c();
					creditAccountObj.Party__c = partyObj.id;
					try {
						creditAccountObj.Account_Type__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ACCOUNT_TYPE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Role__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ROLE)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Account_Number__c = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ACCOUNT_NUMBER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Latest_Credit_Provider__c = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.PROVIDER)).get(ConstantValues.NODE_VALUE);
					} catch(Exception ex) {}
					try {
						creditAccountObj.Original_Credit_Provider__c = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ORIGINAL_PROVIDER)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try{
						String strCurrDefAmt = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.AMOUNT)).get(ConstantValues.NODE_VALUE);
						if(strCurrDefAmt == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Current_Default_Amount__c = Decimal.valueOf(strCurrDefAmt);
					} catch (Exception ex) {}

					try {
						String strDefDate = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.DEFAULT_DATE)).get(ConstantValues.NODE_VALUE);
						if(strDefDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Default_Date__c = Date.newInstance(Integer.valueOf(strDefDate.substring(0,4)),
						Integer.valueOf(strDefDate.substring(5,7)),
						Integer.valueOf(strDefDate.substring(8,10)));
					} catch (Exception ex) {}

					try {
						creditAccountObj.Report_Reason__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.REPORT_REASON)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						String orgDefDate = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ORIGINAL_DEFAULT_DATE)).get(ConstantValues.NODE_VALUE);
						if(orgDefDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Original_Default_Date__c = Date.newInstance(Integer.valueOf(orgDefDate.substring(0,4)),
						Integer.valueOf(orgDefDate.substring(5,7)),
						Integer.valueOf(orgDefDate.substring(8,10)));
					} catch (Exception ex) {}
					try {
						String strDefaultAmount = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ORIGINAL_AMOUNT)).get(ConstantValues.NODE_VALUE);
						if(strDefaultAmount == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Original_Default_Amount__c = Decimal.valueOf(strDefaultAmount);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Original_Report_Reason__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.ORIGINAL_REPORT_REASON)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						creditAccountObj.Status__c = (String)((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.PAYMENT_STATUS)).get(ConstantValues.TYPE)).get(ConstantValues.NODE_VALUE);
					} catch (Exception ex) {}
					try {
						String statDate = (String)((Map<String, Object>)((Map<String, Object>)refCreditAccount).get(ConstantValues.STATUS_DATE)).get(ConstantValues.NODE_VALUE);
						if(statDate == null){
							throw new CommonException(ConstantValues.NULL_VALUE);
						}
						creditAccountObj.Status_Date__c = Date.newInstance(Integer.valueOf(statDate.substring(0,4)),
						Integer.valueOf(statDate.substring(5,7)),
						Integer.valueOf(statDate.substring(8,10)));
					} catch (Exception ex) {}

					creditAccountList.add(creditAccountObj);
					
				}
			} catch (Exception ex) {
				returnValue += ConstantValues.NO_PAYMENT_DEFAULTS_FOUND;
	  		}
	 	 	update partyObj;
			update ppsrRegistrationData;
			insert entityList;
			insert finalCreditEnquiryList;
			insert creditAccountList;
		  	return returnValue;
		} catch(Exception ex){
			  GenericUtility.insertLog(ConstantValues.EQUIFAX_COMPANY_ENQUIRY_RESPONSE_HELPER, ex);
			  return ConstantValues.GENERAL_ERROR;
	  		}
	}
	private static void clearPartyObjectData(clcommon__Party__c partyObj){
		partyObj.Request_Id__c = null;
		partyObj.Report_Created_Date__c = null;
		partyObj.File_Number__c = null;
		partyObj.External_Administrators__c = null;
		partyObj.Number_Of_Credit_Events__c = null;
		partyObj.Amount_of_Credit_Enquiry__c = null;
		partyObj.Number_of_Credit_Enquiries_in_Last_12_Mo__c = null;
		partyObj.Amount_of_Credit_Enquiries_in_last_12_mo__c = null;
		partyObj.No_of_Credit_Enquiries_in_more_than_12_M__c = null;
		partyObj.Amount_of_Credit_Enquiries_in_more_than__c = null;
		partyObj.Payment_Defaults__c = null;
		partyObj.Amount_of_Payment_Defaults__c = null;
		partyObj.Number_Payment_Defaults_in_last_12_Month__c = null;
		partyObj.Amount_Payment_Defaults_in_last_12_Month__c = null;
		partyObj.Number_Payment_Defaults_in_more_than_12__c = null;
		partyObj.Amount_Payment_Defaults_in_more_than_12__c = null;
		partyObj.ASIC_Extract_Date__c = null;
		partyObj.Incorporation_Date__c = null;
		partyObj.Organization_Status__c = null;
		partyObj.Registered_Office__c = null;
		partyObj.File_Create_Date__c = null;
		partyObj.Court_Writs__c = null;
		partyObj.Court_Writ_Amount__c = null;
		partyObj.Court_Actions__c = null;
		partyObj.Court_Action_Amount__c = null;
		partyObj.Petitions__c = null;
		partyObj.Company_Director_s_Adverse__c = null;
		partyObj.Company_Director_s_Related_Entity_Advers__c = null;
		update partyObj;
	}
}
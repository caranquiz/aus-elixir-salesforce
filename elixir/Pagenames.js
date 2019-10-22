var _ = require('underscore');
var pd = require('pretty-data').pd;

exports.init = function(grunt){
	var exports = {};

	/**
	 * Helper method for setting up the org credentials
	 * @param  {[type]} options [description]
	 * @return {[type]}         [description]
	 */
	exports.getPageNames = function(options){
		return [
			'CustomCreditAssessment',
			'CustomCreditAssessPage',
			'CustomFinancialDetails',
			'CustomPricingDetails',
			'CustomSolicitorDetails',
			'Documents',
			'AdditionalAssetsDetail',
			'EditPartyRelationshipDetails',
			'CollateralDetails',
			'PartyRelationshipDetails',
			'NGLoanDashBoard',
			'PledgeCollaterals',
			'RelationshipDashboard',
			'showCollaterals',
			'BorrowingStructure',
			'GenericHeader',
			'CreateNewApplication',
			'ApplicationForm',
			'ApplicationView',
			'CollateralDetailView',
			'AnyLoanProductApplicationForm',
			'NewApplicationDocumentCategoryDetails'
		];
	};
	return exports;
};
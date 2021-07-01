/****************************************************************************************************
Company: Cloudkaptan Consultancy Services Pvt. Ltd.
Author: Rameswari Barman
Description : This class returns query for the LoanDepositPaymentCreationDynamicJob which looks 
                and created Internal Transfers only for LAIs where on the current date no internal tranfers have been made
Development Date : 29/06/2021
Last Modified Date : 29/06/2021
****************************************************************************************************/
global class DepositPaymentCreationCustomQuery implements clcommon.IBatchJobQuery { 
    public static String getCustomQuery(String jobName) {
        String customQuery;
        if(jobName == 'loan.LoanDepositPaymentCreationDynamicJob') {
            String currentDate = ((DateTime) (!Test.isRunningTest()?(new loan.GlobalLoanUtilFacade()).getCurrentSystemDate(): Date.Today())).format('yyyy-MM-dd');
            customQuery  = 'select id, name, loan__account__c, loan__application_date__c, loan__account__r.name, loan__accrual_amount_accounted_for__c, loan__accrual_start_date__c,'+
                            'loan__accrual_start_days__c, loan__accrual_stop_indicator__c, loan__ach_debit_day__c, loan__ach_end_date__c, loan__ach_frequency__c,'+ 
                            'loan__ach_frequency_cycle__c, loan__ach_next_debit_date__c, loan__ach_on__c, loan__actual_interest_only_payments__c, loan__adjust_deposit_amount_in_payoff__c,'+
                            'loan__add_fee_amount_to_bill__c, loan__additional_interest_collected_in_advance__c, loan__amortization_schedule_generated__c, loan__amortization_term__c,'+
                            'loan__amount_to_current__c, loan__amount_due_till_current__c, loan__apr__c, loan__balloon_payment__c, loan__bill_follow_schedules__c, loan__branch__c,'+
                            'loan__capitalization_frequency__c, loan__capitalized_fee__c, loan__capitalized_interest__c, loan__change_recurring_ach_terms__c, loan__cleared_disbursal_txn_count__c,'+
                            'loan__client__c, loan__closed_date__c, loan__contact__c, loan__contact__r.name, loan__contingency_status_code__c, loan__contractual_due_day__c, '+
                            'loan__contractual_interest_rate__c, loan__credit_limit__c, loan__credit_limit_current__c, loan__delinquency_aging_interval__c, loan__delinquency_basis__c,'+
                            'loan__delinquency_grace_days__c, loan__delinquent_amount__c, loan__deposit_interest_accrued__c, loan__deposit_interest_posted__c, loan__deposit_interest_remaining__c,'+
                            'loan__deposit_payment_offset_days__c, loan__disbursal_amount__c, loan__disbursal_date__c, loan__disbursal_status__c, loan__disbursed_amount__c, loan__draw_billing_method__c,'+
                            'loan__draw_period_end_date__c, loan__draw_period_interest_calculation__c, loan__draw_term__c, loan__draw_term_payment_percent__c, loan__due_day__c,'+
                            'loan__early_pre_payment_penalty_indicator__c, loan__enable_fee_capitalization_for_io__c, loan__enable_interest_capitalization_for_io__c,'+
                            'loan__enable_interest_posting_for_io__c, loan__excess__c, loan__expected_disbursal_date__c, loan__expected_repayment_start_date__c, loan__fee_set__c,'+
                            'loan__fees_billed__c, loan__fee_threshold__c, loan__fee_threshold_type__c, loan__fees_paid__c, loan__fees_remaining__c, loan__first_installment_date__c,'+
                            'loan__flexible_rate__c, loan__floating_rate_index__c, loan__floating_rate_revision_date__c, loan__floating_rate_revision_frequency__c, loan__frequency_of_loan_payment__c,'+
                            'loan__funding_in_tranches__c, loan__funding_stop_basis__c, loan__grace_period_for_repayments__c, loan__group__c, loan__ignore_waiver_for_rebate__c, loan__index_rate__c,'+
                            'loan__interest_accrued_not_due__c, loan__interest_calculation_method__c, loan__interest_collected_in_advance__c, loan__interest_estimated__c, loan__interest_only_payment_amt__c,'+
                            'loan__interest_only_period__c, loan__interest_paid__c, loan__interest_period_calculation__c, loan__interest_posted__c, loan__interest_posting_day__c, '+
                            'loan__interest_posting_frequency__c, loan__interest_rate__c, loan__interest_rate_change_method__c, loan__interest_rate_last__c, loan__interest_remaining__c,'+
                            'loan__interest_rounding_error__c, loan__interest_type__c, loan__interest_waived__c, loan__fees_waived__c, loan__ioa_waived__c, loan__invalid_data__c,'+
                            'loan__investment_product_loan__c, loan__ioa_generation_status__c, loan__is_capitalization_enabled__c, loan__is_interest_posting_enabled__c, loan__is_rescheduled__c,'+
                            'loan__la_delinquency_flag__c, loan__la_next_amortization_date__c, loan__last_accrual_date__c, loan__last_billed_amount__c, loan__last_disbursal_amount__c, '+
                            'loan__last_disbursal_date__c, loan__last_installment_date__c, loan__last_interest_posting_date__c, loan__last_payment_amount__c, loan__last_payment_date__c, '+
                            'loan__last_transaction_id__c, loan__last_transaction_timestamp__c, loan__last_transaction_type__c, loan__loan_amount__c, loan__loan_account_external_id__c, '+
                            'loan__loan_balance__c, loan__loan_product_name__c, loan__loan_product_name__r.name, loan__loan_product_name__r.loan__enable_adjustment_entry__c, '+
                            'loan__loan_product_name__r.loan__create_summaries__c, loan__loan_product_name__r.loan__accrual_entry_frequency__c, loan__loan_product_name__r.loan__accrual_start_basis__c,'+
                            'loan__loan_product_name__r.loan__allow_payoff_with_uncleared_payments__c, loan__loan_product_name__r.loan__business_hours__c, '+
                            'loan__loan_product_name__r.loan__delinquency_aging_set__c, loan__loan_product_name__r.loan__compounding_interest__c, loan__loan_product_name__r.loan__digits_after_decimals__c,'+
                            'loan__loan_product_name__r.loan__floating_rate_change_action__c, loan__loan_product_name__r.loan__general_rounding_mode__c, loan__loan_product_name__r.loan__grace_period_duration__c,'+
                            'loan__loan_product_name__r.loan__holiday_shift__c, loan__loan_product_name__r.loan__holiday_treatment_setup__c, loan__loan_product_name__r.loan__max_loan_amount__c, '+
                            'loan__loan_product_name__r.loan__max_interest_rate__c, loan__loan_product_name__r.loan__min_interest_rate__c, loan__loan_product_name__r.loan__payment_application_order__c, '+
                            'loan__loan_product_name__r.loan__payment_tolerance_rate__c, loan__loan_product_name__r.loan__payment_tolerance_fixed_amount__c, loan__loan_product_name__r.loan__payment_tolerance_type__c,'+
                            'loan__loan_product_name__r.loan__sliding_billing_setup__c, loan__loan_status__c, loan__margin_rate__c, loan__maturity_date_current__c, loan__maximum_draw_amount__c,'+
                            'loan__maximum_interest_rate__c, loan__metro2_account_highest_bal_amount__c, loan__metro2_first_delinquency_date__c, loan__metro2_account_status_code__c, loan__migration_date__c, '+
                            'loan__minimum_draw_amount__c, loan__minimum_due_amount_on_billing__c, loan__minimum_interest_rate__c, loan__move_across_months__c, loan__next_accrual_entry_date__c, '+
                            'loan__next_capitalization_date__c, loan__next_commission_payment_date__c, loan__next_deposit_payment_date__c, loan__next_due_generation_date__c, loan__next_installment_date__c,'+
                            'loan__next_interest_posting_date__c, loan__next_repayment_amount_as_of_today__c, loan__number_of_days_overdue__c, loan__number_of_installments__c, loan__number_of_past_installments__c,'+
                            'loan__oldest_due_date__c, loan__ot_ach_debit_date__c, loan__ot_ach_fee_amount__c, loan__ot_ach_payment_amount__c, loan__overdue_amount_as_of_today__c, loan__overdue_interest__c, '+
                            'loan__payment_mode__c, loan__payment_amount__c, loan__payment_application_mode__c, loan__payment_application_order__c, loan__payment_due_days__c, loan__payment_frequency_cycle__c, '+
                            'loan__payment_tolerance_start_date__c, loan__payment_tolerance_end_date__c, loan__payment_tolerance_rate__c, loan__payment_tolerance_fixed_amount__c, '+
                            'loan__pay_off_amount_as_of_today__c, loan__payoff_fee_indicator__c, loan__periodic_fee__c, loan__pmt_amt_cur__c, loan__prepayment_method__c, loan__prepayment_penalty_indicator__c,'+
                            'loan__prepayment_penalty_periods__c, loan__prepayment_value__c, loan__pre_bill_days__c, loan__pre_paid_interest_amount__c, loan__pre_paid_interest_paid_till_date__c,'+
                            'loan__previous_installment_date__c, loan__principal_adjustment__c, loan__principal_adjustment_subtract__c, loan__principal_adjustment_reschedule_option__c, '+
                            'loan__principal_interest_emi_generated_on_req__c, loan__principal_paid__c, loan__principal_posted__c, loan__principal_remaining__c, loan__product_type__c,'+
                            'loan__protect_enabled__c, loan__protect_fee_amount__c, loan__protect_fee_percent__c, loan__rate_change_dt_last__c, loan__rate_change_dt_next__c, '+
                            'loan__recalculate_interest_flag__c, recordtypeid, loan__remaining_loan_amount__c, loan__repayment_billing_method__c, loan__repayment_period_interest_calculation__c,'+
                            'loan__repayment_procedure__c, loan__repayment_start_basis__c, loan__repayment_term_payment_percent__c, loan__repayments_count__c, loan__repayment_schedule_count__c,'+
                            'loan__reschedule_option_on_excess_payment__c, loan__reschedule_status__c, loan__reserve_amount_for_next_due__c, loan__revolving__c, loan__second_due_day__c, '+
                            'loan__second_installment_date__c, loan__schedule_adjustment_method__c, loan__scheduled_fee_amount_in_payoff__c, loan__scheduled_fee_posted__c, loan__stepup_option__c, '+
                            'loan__term_cur__c, loan__time_counting_method__c, loan__total_amount_disbursed__c, loan__total_amount_overdue__c, loan__total_amount_paid__c, loan__total_due_charges__c, '+
                            'loan__total_overdue_fees__c, loan__total_pre_paid_fees__c, loan__total_scheduled_fee__c, loan__total_refinance_amount_actual__c, loan__tds_type__c, loan__ltv__c, '+
                            'loan__cltv__c, loan__tds_percentage__c, loan__uncleared_repayment_amount__c, loan__unpaid_bills__c, loan__write_off_tolerance_amount__c, loan__loan_parameters__c, '+
                            'loan__loan_parameters__r.loan__advance_interest__c, loan__loan_parameters__r.loan__collect_advance_interest_on_disbursal__c, loan__loan_parameters__r.loan__minimum_interest_option__c,'+
                            'loan__loan_parameters__r.loan__minimum_interest_amount__c, loan__loan_parameters__r.loan__minimum_interest_period__c, loan__loan_parameters__r.loan__minimum_interest_period_date__c,'+
                            'loan__loan_parameters__r.loan__enable_forecasting__c, loan__loan_parameters__r.loan__auto_change_deposit_rate__c '+
                            'FROM loan__loan_account__c WHERE loan__payment_application_mode__c = \'Deposit\' and loan__deposit_payment_offset_days__c != null '+
                            'and loan__next_deposit_payment_date__c <= '+currentDate+' and loan__loan_status__c in (\'active - good standing\',\'active - bad standing\') '+
                            'and loan__invalid_data__c = false and loan__product_type__c = \'Loan\' and Uncleared_Internal_Transfer__c = 0';
        }
        return customQuery;
    } 
}
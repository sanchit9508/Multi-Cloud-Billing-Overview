view: gcp_focus_base.view.lkml {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.@{GCP_TABLE_NAME}` ;;
  dimension: billing_account_id {
    group_label: "Hierarchy"
    type: string
    sql: ${TABLE}.BillingAccountId ;;
  }

  dimension: project_name {
    group_label: "Hierarchy"
    type: string
    sql: ${TABLE}.ResourceName ;; # FOCUS maps Project Name here for GCP
  }

  dimension: usage_unit {
    group_label: "Usage"
    type: string
    sql: ${TABLE}.UsageUnit ;;
  }

  measure: total_effective_cost {
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
  }

  measure: credit_amount {
    type: sum
    sql: ${TABLE}.ContractedDiscount + ${TABLE}.NegotiatedDiscount ;;
    value_format_name: usd
    description: "Total amount of discounts applied to the list cost."
  }

  measure: effective_unit_price {
    type: number
    sql: SAFE_DIVIDE(${total_effective_cost}, NULLIF(${total_usage}, 0)) ;;
    value_format_name: usd_6
  }

  measure: total_usage {
    type: sum
    sql: ${TABLE}.UsageQuantity ;;
  }
}
  


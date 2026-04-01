view: azure_focus_base.view.lkml {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.@{AZURE_TABLE_NAME}` ;;

  dimension: charge_id {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.ChargeId, ${TABLE}.ResourceId, ${TABLE}.ChargePeriodStart) ;;
  }

  dimension: billing_account_name {
    group_label: "Identity"
    type: string
    sql: ${TABLE}.BillingAccountName ;;
  }

  dimension: resource_id {
    group_label: "Identity"
    type: string
    sql: ${TABLE}.ResourceId ;;
  }

  dimension: service_category {
    group_label: "Classification"
    type: string
    sql: ${TABLE}.ServiceCategory ;;
    description: "Standardized category (e.g., Compute, Storage)"
  }

  dimension: charge_class {
    group_label: "Classification"
    type: string
    sql: ${TABLE}.ChargeClass ;;
    description: "Usage, Purchase, or Refund"
  }

  dimension: pricing_category {
    group_label: "Pricing"
    type: string
    sql: ${TABLE}.PricingCategory ;; 
    description: "On-Demand vs. Commitment"
  }

  dimension_group: charge_period {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ChargePeriodStart ;;
  }

  measure: total_billed_cost {
    type: sum
    sql: ${TABLE}.BilledCost ;;
    value_format_name: usd
    drill_fields: [service_category, resource_id, total_billed_cost]
  }

  measure: total_effective_cost {
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
    description: "Includes amortization of reservations and savings plans."
  }

  measure: unit_price_avg {
    type: average
    sql: ${TABLE}.UnitPrice ;;
    value_format_name: usd_6
  }
}
  
}

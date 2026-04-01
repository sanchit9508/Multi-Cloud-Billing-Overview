view: collected_billing_focus {
  derived_table: {
    sql:
      SELECT 
        'Azure' as cloud_provider,
        BillingAccountId,
        ChargePeriodStart,
        ServiceCategory,
        ChargeDescription,
        ResourceId,
        EffectiveCost,
        BilledCost,
        ListCost,
        UsageQuantity,
        UsageUnit,
        Tags
      FROM ${azure_billing_focus_detailed.SQL_TABLE_NAME}
      
      UNION ALL
      
      SELECT 
        'AWS' as cloud_provider,
        BillingAccountId,
        UsageDate as ChargePeriodStart, -- Mapping AWS usage date to common field
        ServiceCategory,
        SkuDescription as ChargeDescription,
        ResourceId,
        NetCost as EffectiveCost,
        BilledCost,
        ListCost,
        UsageQuantity,
        UsageUnit,
        Tags
      FROM ${aws_billing_focus_detailed.SQL_TABLE_NAME}
      
      UNION ALL
      
      SELECT 
        'GCP' as cloud_provider,
        BillingAccountId,
        BillingPeriodStart as ChargePeriodStart,
        ServiceCategory,
        ChargeDescription,
        ResourceId,
        EffectiveCost,
        BilledCost,
        ListCost,
        UsageQuantity,
        UsageUnit,
        Tags
      FROM ${gcp_billing_focus_detailed.SQL_TABLE_NAME}
    ;;
  }


  dimension: cloud_provider {
    type: string
    description: "AWS, Azure, or GCP"
    suggestions: ["AWS", "Azure", "GCP"]
  }

  dimension: billing_account_id {
    type: string
    sql: ${TABLE}.BillingAccountId ;;
  }

  dimension_group: charge_period {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.ChargePeriodStart ;;
  }

  dimension: service_category {
    type: string
    sql: ${TABLE}.ServiceCategory ;;
    description: "Common categories like Compute, Storage, Networking"
  }

  dimension: resource_id {
    type: string
    sql: ${TABLE}.ResourceId ;;
  }


  measure: total_effective_cost {
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
    drill_fields: [cloud_provider, service_category, total_effective_cost]
  }

  measure: total_list_cost {
    type: sum
    sql: ${TABLE}.ListCost ;;
    value_format_name: usd
  }

  measure: savings_amount {
    type: number
    sql: ${total_list_cost} - ${total_effective_cost} ;;
    value_format_name: usd
    description: "Difference between List Price and what you actually paid."
  }

  measure: savings_percentage {
    type: number
    sql: 1 - SAFE_DIVIDE(${total_effective_cost}, NULLIF(${total_list_cost}, 0)) ;;
    value_format_name: percent_1
  }
}

view: aws_focus_base.view.lkml {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.@{AWS_TABLE_NAME}`

  dimension: region {
    group_label: "Location"
    type: string
    sql: ${TABLE}.RegionId ;;
  }

  dimension: availability_zone {
    group_label: "Location"
    type: string
    sql: ${TABLE}.AvailabilityZone ;;
  }

  dimension: sku_id {
    group_label: "Product"
    type: string
    sql: ${TABLE}.SkuId ;;
  }

  dimension: sku_description {
    group_label: "Product"
    type: string
    sql: ${TABLE}.SkuDescription ;;
  }

  dimension: tags_raw {
    hidden: yes
    sql: ${TABLE}.Tags ;;
  }

  dimension: cost_center {
    type: string
    sql: JSON_VALUE(${TABLE}.Tags, '$.cost-center') ;;
  }

  measure: total_net_cost {
    type: sum
    sql: ${TABLE}.NetCost ;;
    value_format_name: usd
    description: "Cost after all discounts and credits applied."
  }

  measure: usage_quantity {
    type: sum
    sql: ${TABLE}.UsageQuantity ;;
    description: "The amount of usage (e.g., GB-hours, vCPU-hours)."
  }

  measure: savings_percentage {
    type: number
    sql: 1 - SAFE_DIVIDE(${total_net_cost}, NULLIF(${total_list_cost}, 0)) ;;
    value_format_name: percent_1
  }

  measure: total_list_cost {
    type: sum
    sql: ${TABLE}.ListCost ;;
    value_format_name: usd
  }
  
}

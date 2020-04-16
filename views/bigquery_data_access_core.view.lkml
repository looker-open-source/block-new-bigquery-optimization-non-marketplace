include: "//@{CONFIG_PROJECT_NAME}/bigquery_data_access.view.lkml"


view: bigquery_data_access {
  extends: [bigquery_data_access_config]
}


view: bigquery_data_access_resource {
  extends: [bigquery_data_access_resource_config]
}


view: bigquery_data_access_resource_labels {
  extends: [bigquery_data_access_resource_labels_config]
}


view: bigquery_data_access_http_request {
  extends: [bigquery_data_access_http_request_config]
}


view: bigquery_data_access_source_location {
  extends: [bigquery_data_access_source_location_config]
}


view: bigquery_data_access_request_metadata {
  extends: [bigquery_data_access_request_metadata_config]
}


view: bigquery_data_access_authentication_info {
  extends: [bigquery_data_access_authentication_info_config]
}


view: bigquery_data_authorization_info {
  extends: [bigquery_data_authorization_info_config]
}


view: bigquery_data_access_payload {
  extends: [bigquery_data_access_payload_config]
}


view: bigquery_data_access_metadata_json {
  extends: [bigquery_data_access_metadata_json_config]
}


view: bigquery_data_access_job_insertion {
  extends: [bigquery_data_access_job_insertion_config]
}


view: bigquery_data_access_job {
  extends: [bigquery_data_access_job_config]
}


view: bigquery_data_access_job_configuration {
  extends: [bigquery_data_access_job_configuration_config]
}


view: bigquery_data_access_job_statistics {
  extends: [bigquery_data_access_job_statistics_config]
}


view: bigquery_data_access_job_status {
  extends: [bigquery_data_access_job_status_config]
}


view: bigquery_data_access_job_status_error {
  extends: [bigquery_data_access_job_status_error_config]
}


view: bigquery_data_access_query {
  extends: [bigquery_data_access_query_config]
}


view: bigquery_data_access_query_destination_table {
  extends: [bigquery_data_access_query_destination_table_config]
}


view: bigquery_data_access_operation {
  extends: [bigquery_data_access_operation_config]
}

###################################################

        view: bigquery_data_access_core {
  derived_table: {
    sql: SELECT
        *
      FROM
        `@{SCHEMA_NAME}.@{AUDIT_LOG_EXPORT_TABLE_NAME}`
      WHERE
        {% condition date_filter %} timestamp {% endcondition %} ;;
  }

  filter: date_filter {
    type: date
  }

  dimension: http_request {
    hidden: yes
    sql: ${TABLE}.httpRequest ;;
  }

  dimension: insert_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.insertId ;;
  }

  dimension: log_name {
    type: string
    sql: ${TABLE}.logName ;;
  }

  dimension: operation {
    hidden: yes
    sql: ${TABLE}.operation ;;
  }

  dimension: protopayload_auditlog {
    hidden: yes
    sql: ${TABLE}.protopayload_auditlog ;;
  }

  dimension: resource {
    hidden: yes
    sql: ${TABLE}.resource ;;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.severity ;;
  }

  dimension: source_location {
    hidden: yes
    sql: ${TABLE}.sourceLocation ;;
  }

  dimension: trace {
    type: string
    sql: ${TABLE}.trace ;;
  }

  dimension_group: receive_timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.receiveTimestamp ;;
  }

  dimension_group: timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  measure: number_of_queries {
    view_label: "BigQuery Data Access: Query Statistics"
    type: count

    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: number_of_expensive_queries {
    view_label: "BigQuery Data Access: Query Statistics"
    description: "Number of queries with over 30 billed gigabytes"
    type: count

    filters: {
      field: bigquery_data_access_job_statistics.billed_gigabytes
      value: ">30"
    }
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }
}

view: bigquery_data_access_resource_core {
  dimension: labels {
    hidden: yes
    sql: ${TABLE}.labels ;;
  }

  dimension: type {
    hidden: yes
    type: string
    sql: ${TABLE}.type ;;
  }
}

view: bigquery_data_access_resource_labels_core {
  dimension: project_id {
    view_label: "BigQuery Data Access"
    type: string
    sql: ${TABLE}.project_id ;;
  }
}

view: bigquery_data_access_http_request_core {
  dimension: cache_fill_bytes {
    type: number
    sql: ${TABLE}.cacheFillBytes ;;
  }

  dimension: cache_hit {
    type: yesno
    sql: ${TABLE}.cacheHit ;;
  }

  dimension: cache_lookup {
    type: yesno
    sql: ${TABLE}.cacheLookup ;;
  }

  dimension: cache_validated_with_origin_server {
    type: yesno
    sql: ${TABLE}.cacheValidatedWithOriginServer ;;
  }

  dimension: protocol {
    type: string
    sql: ${TABLE}.protocol ;;
  }

  dimension: referer {
    type: string
    sql: ${TABLE}.referer ;;
  }

  dimension: remote_ip {
    type: string
    sql: ${TABLE}.remoteIp ;;
  }

  dimension: request_method {
    type: string
    sql: ${TABLE}.requestMethod ;;
  }

  dimension: request_size {
    type: number
    sql: ${TABLE}.requestSize ;;
  }

  dimension: request_url {
    type: string
    sql: ${TABLE}.requestUrl ;;
  }

  dimension: response_size {
    type: number
    sql: ${TABLE}.responseSize ;;
  }

  dimension: server_ip {
    type: string
    sql: ${TABLE}.serverIp ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: user_agent {
    type: string
    sql: ${TABLE}.userAgent ;;
  }
}

view: bigquery_data_access_source_location_core {
  dimension: file {
    type: string
    sql: ${TABLE}.file ;;
  }

  dimension: function {
    type: string
    sql: ${TABLE}.function ;;
  }

  dimension: line {
    type: number
    sql: ${TABLE}.line ;;
  }
}

view: bigquery_data_access_request_metadata_core {
  dimension: caller_ip {
    type: string
    sql: ${TABLE}.callerIp ;;
  }

  dimension: caller_supplied_user_agent {
    type: string
    sql: ${TABLE}.callerSuppliedUserAgent ;;
  }
}

view: bigquery_data_access_authentication_info_core {
  dimension: authority_selector {
    hidden: yes
    type: string
    sql: ${TABLE}.authoritySelector ;;
  }

  dimension: user_id {
    label: "User ID"
    type: string
    sql: ${TABLE}.principalEmail ;;
  }

  dimension: is_service_account {
    type: yesno
    sql: (${user_id} LIKE '%gserviceaccount%') ;;
  }

  measure: number_of_active_users {
    description: "Excludes Service Accounts"
    type: count_distinct
    sql: ${user_id} ;;

    filters: {
      field: is_service_account
      value: "no"
    }
    drill_fields: [user_id]
  }
}

view: bigquery_data_authorization_info_core {
  dimension: granted {
    type: yesno
    sql: ${TABLE}.granted ;;
  }

  dimension: permission {
    type: string
    sql: ${TABLE}.permission ;;
  }

  dimension: resource {
    type: string
    sql: ${TABLE}.resource ;;
  }
}

view: bigquery_data_access_payload_core {
  dimension: authentication_info {
    hidden: yes
    sql: ${TABLE}.authenticationInfo ;;
  }

  dimension: authorization_info {
    hidden: yes
    sql: ${TABLE}.authorizationInfo ;;
  }

  dimension: metadata_json {
    hidden: yes
    type: string
    sql: ${TABLE}.metadataJson ;;
  }

  dimension: method_name {
    type: string
    sql: ${TABLE}.methodName ;;
  }

  dimension: num_response_items {
    type: number
    sql: ${TABLE}.numResponseItems ;;
  }

  dimension: request_json {
    hidden: yes
    type: string
    sql: ${TABLE}.requestJson ;;
  }

  dimension: request_metadata {
    hidden: yes
    sql: ${TABLE}.requestMetadata ;;
  }

  dimension: resource_location {
    hidden: yes
    sql: ${TABLE}.resourceLocation ;;
  }

  dimension: resource_name {
    type: string
    sql: ${TABLE}.resourceName ;;
  }

  dimension: service_name {
    type: string
    sql: ${TABLE}.serviceName ;;
  }

  dimension: status {
    hidden: yes
    sql: ${TABLE}.status ;;
  }
}

view: bigquery_data_access_metadata_json_core {
  dimension: jobInsertion {
    hidden: yes
    type: string
    sql: JSON_EXTRACT(${TABLE}, '$.jobInsertion') ;;
  }

  dimension: job_completed_event {
    hidden: yes
    sql: ${TABLE}.jobCompletedEvent ;;
  }

  dimension: job_get_query_results_request {
    hidden: yes
    sql: ${TABLE}.jobGetQueryResultsRequest ;;
  }

  dimension: job_get_query_results_response {
    hidden: yes
    sql: ${TABLE}.jobGetQueryResultsResponse ;;
  }

  dimension: job_insert_request {
    hidden: yes
    sql: ${TABLE}.jobInsertRequest ;;
  }

  dimension: job_insert_response {
    hidden: yes
    sql: ${TABLE}.jobInsertResponse ;;
  }

  dimension: job_query_request {
    hidden: yes
    sql: ${TABLE}.jobQueryRequest ;;
  }

  dimension: job_query_response {
    hidden: yes
    sql: ${TABLE}.jobQueryResponse ;;
  }

  dimension: table_data_list_request {
    hidden: yes
    sql: ${TABLE}.tableDataListRequest ;;
  }
}

view: bigquery_data_access_job_insertion_core {
  dimension: job {
    hidden: yes
    type: string
    sql: JSON_EXTRACT(${TABLE}, '$.job') ;;
  }

  dimension: reason {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.reason') ;;
  }
}

view: bigquery_data_access_job_core {
  dimension: job_config {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.jobConfig') ;;
  }

  dimension: job_name {
    type: string
    hidden: yes
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.jobName') ;;
  }

  dimension: job_stats {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.jobStats') ;;
  }

  dimension: job_status {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.jobStatus') ;;
  }
}

view: bigquery_data_access_job_configuration_core {
  dimension: query {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.queryConfig') ;;
  }
}

view: bigquery_data_access_job_statistics_core {
  dimension: billing_tier {
    type: number
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.queryStats.billingTier') ;;
  }

  dimension: billed_bytes {
    type: number
    sql: CAST(JSON_EXTRACT_SCALAR(${TABLE}, '$.queryStats.totalBilledBytes') AS INT64) ;;
  }

  dimension: processed_bytes {
    type: number
    sql: CAST(JSON_EXTRACT_SCALAR(${TABLE}, '$.queryStats.totalProcessedBytes') AS INT64) ;;
  }

  dimension: billed_gigabytes {
    type: number
    sql: 1.0*${billed_bytes}/1000000000 ;;
  }

  dimension: billed_terabytes {
    type: number
    sql: 1.0*${billed_bytes}/1000000000000 ;;
  }

  dimension: query_cost {
    type: number
    sql: 5.0*${billed_bytes}/1000000000000 ;;
    value_format_name: usd
  }

  dimension: query_runtime {
    type: number
    sql: 1.0*TIMESTAMP_DIFF(${end_raw}, ${start_raw}, MILLISECOND)/1000 ;;
    value_format_name: decimal_1
  }

  dimension_group: create {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(JSON_EXTRACT_SCALAR(${TABLE}, '$.createTime') AS TIMESTAMP) ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(JSON_EXTRACT_SCALAR(${TABLE}, '$.endTime') AS TIMESTAMP) ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(JSON_EXTRACT_SCALAR(${TABLE}, '$.startTime') AS TIMESTAMP) ;;
  }

  measure: total_billed_gigabytes {
    type: sum
    view_label: "BigQuery Data Access: Query Statistics"
    sql: ${billed_gigabytes} ;;
    value_format_name: decimal_2
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: total_billed_terabytes {
    type: sum
    view_label: "BigQuery Data Access: Query Statistics"
    sql: ${billed_terabytes} ;;
    value_format_name: decimal_2
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: average_billed_gigabytes {
    type: average
    view_label: "BigQuery Data Access: Query Statistics"
    sql: ${billed_gigabytes} ;;
    value_format_name: decimal_2
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: average_billed_terabytes {
    type: average
    view_label: "BigQuery Data Access: Query Statistics"
    sql: ${billed_terabytes} ;;
    value_format_name: decimal_2
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: total_query_cost {
    type: sum
    sql: ${query_cost} ;;
    value_format_name: usd
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: average_query_cost {
    type: average
    sql: ${query_cost} ;;
    value_format_name: usd
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }

  measure: average_query_runtime {
    type: average
    sql: ${query_runtime} ;;
    value_format_name: decimal_1
    drill_fields: [
      bigquery_data_access_authentication_info.user_id,
      bigquery_data_access_job_statistics.start_time,
      bigquery_data_access_resource_labels.project_id,
      bigquery_data_access_query.query,
      bigquery_data_access_job_statistics.billed_gigabytes,
      bigquery_data_access_job_statistics.query_runtime,
      bigquery_data_access_job_statistics.query_cost,
      bigquery_data_access_job_status_error.code,
      bigquery_data_access_job_status_error.message
    ]
  }
}

view: bigquery_data_access_job_status_core {
  dimension: error {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.errorResult') ;;
  }

  dimension: state {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.jobState') ;;
  }

  dimension: query_failed {
    type: yesno
    sql: ${error} IS NOT NULL ;;
  }
}

view: bigquery_data_access_job_status_error_core {
  dimension: code {
    type: number
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.code') ;;
  }

  dimension: message {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.message') ;;
  }
}

view: bigquery_data_access_query_core {

  filter: query_text_filter {
    type: string
  }

  dimension: query_text_selector {
    type: string

    case: {
      when: {
        sql: {% condition query_text_filter %} ${query} {% endcondition %} ;;
        label: "Queries with Specified Pattern"
      }
      else: "All Other Queries"
    }
  }

  dimension: create_disposition {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.createDisposition') ;;
  }

  dimension: default_dataset {
    hidden: yes
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.defaultDataset') ;;
  }

  dimension: query {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.query') ;;
  }

  dimension: table_definitions {
    hidden: yes
    sql: JSON_EXTRACT(${TABLE}, '$.tableDefinitions') ;;
  }

  dimension: write_disposition {
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$.writeDisposition') ;;
  }
}

view: bigquery_data_access_query_destination_table_core {
  dimension: destination_table {
    hidden: yes
    sql: JSON_EXTRACT_SCALAR(${TABLE}, '$') ;;
  }

  dimension: project_id {
    sql: SPLIT(${destination_table}, "/")[OFFSET(1)] ;;
  }

  dimension: dataset_id {
    sql: SPLIT(${destination_table}, "/")[OFFSET(3)] ;;
  }

  dimension: table_id {
    sql: SPLIT(${destination_table}, "/")[OFFSET(5)] ;;
  }
}

view: bigquery_data_access_operation_core {
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: first {
    type: yesno
    sql: ${TABLE}.first ;;
  }

  dimension: last {
    type: yesno
    sql: ${TABLE}.last ;;
  }

  dimension: producer {
    type: string
    sql: ${TABLE}.producer ;;
  }
}

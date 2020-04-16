explore: bigquery_data_access_core {
  extension: required 
  view_label: "BigQuery Data Access"
label: "BigQuery Data Access Logs"
sql_always_where: ${bigquery_data_access_metadata_json.jobInsertion} IS NOT NULL ;;

always_filter: {
  filters: {
    field: bigquery_data_access_payload.service_name
    value: "bigquery.googleapis.com"
  }
}

join: bigquery_data_access_payload {
  view_label: "BigQuery Data Access"
  sql: LEFT JOIN UNNEST([${bigquery_data_access.protopayload_auditlog}]) as bigquery_data_access_payload ;;
  relationship: one_to_one
}

join: bigquery_data_access_resource {
  view_label: "BigQuery Data Access: Resource"
  sql: LEFT JOIN UNNEST([${bigquery_data_access.resource}]) as bigquery_data_access_resource ;;
  relationship: one_to_one
}

join: bigquery_data_access_resource_labels {
  view_label: "BigQuery Data Access: Resource Labels"
  sql: LEFT JOIN UNNEST([${bigquery_data_access_resource.labels}]) as bigquery_data_access_resource_labels ;;
  relationship: one_to_one
}

join: bigquery_data_access_metadata_json {
  view_label: "BigQuery Data Access: Service Data"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$')]) as bigquery_data_access_metadata_json ;;
  relationship: one_to_one
}

join: bigquery_data_access_job_insertion {
  view_label: "BigQuery Data Access: Query Data"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion')]) as bigquery_data_access_job_insertion ;;
  relationship: one_to_one
}

join: bigquery_data_access_job {
  view_label: "BigQuery Data Access: Query Data"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job')]) AS bigquery_data_access_job ;;
  relationship: one_to_one
}

join: bigquery_data_access_job_statistics {
  view_label: "BigQuery Data Access: Query Statistics"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobStats')]) AS bigquery_data_access_job_statistics ;;
  relationship: one_to_one
}

join: bigquery_data_access_job_configuration {
  view_label: "BigQuery Data Access: Config"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobConfig')]) AS bigquery_data_access_job_configuration ;;
  relationship: one_to_one
}

join: bigquery_data_access_query {
  view_label: "BigQuery Data Access: Query"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobConfig.queryConfig')]) AS bigquery_data_access_query ;;
  relationship: one_to_one
}

join: bigquery_data_access_query_destination_table {
  view_label: "BigQuery Data Access: Query"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobConfig.queryConfig.destinationTable')]) AS bigquery_data_access_query_destination_table ;;
  relationship: one_to_one
}

join: bigquery_data_access_job_status {
  view_label: "BigQuery Data Access: Status"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobStatus')]) AS bigquery_data_access_job_status ;;
  relationship: one_to_one
}

join: bigquery_data_access_job_status_error {
  view_label: "BigQuery Data Access: Status"
  sql: LEFT JOIN UNNEST([JSON_EXTRACT(${bigquery_data_access_payload.metadata_json}, '$.jobInsertion.job.jobStatus.errorResult')]) AS bigquery_data_access_job_status_error ;;
  relationship: one_to_one
}

join: bigquery_data_access_authentication_info {
  view_label: "BigQuery Data Access"
  sql: LEFT JOIN UNNEST([${bigquery_data_access_payload.authentication_info}]) as bigquery_data_access_authentication_info ;;
  relationship: one_to_one
}

join: bigquery_data_access_http_request {
  view_label: "BigQuery Data Access: Request"
  sql: LEFT JOIN UNNEST([${bigquery_data_access.http_request}]) as bigquery_data_access_http_request ;;
  relationship: one_to_one
}
 
}
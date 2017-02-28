view: results {

  sql_table_name: bcbr.results ;;

  dimension:  arkys_primary_key {
    type: string
    sql: CONCAT(${year}, "|", ${race}, "|", ${stage}, "|", ${plate}) ;;
    primary_key: yes
  }

  dimension: category {

    type: string
    sql: ${TABLE}.category ;;
    hidden: yes

  }
  dimension: plate {

    type: string
    sql: ${TABLE}.plate ;;
    hidden: yes

  }

  dimension: category_position {
    type: string
    sql: ${TABLE}.category_position ;;
  }

  dimension: plate_gender {
    type: string
    sql: ${TABLE}.plate_gender ;;
    hidden: yes
  }

  dimension: position {
    type: number
    sql: ${TABLE}.position ;;
  }

  dimension: race {
    type: string
    sql: ${TABLE}.race ;;
  }

  dimension: speed {
    type: number
    sql: ${TABLE}.speed ;;
  }

  dimension: stage {
    type: number
    sql: ${TABLE}.stage ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  measure: time_string {
    hidden: yes
    type: string
    sql: ${TABLE}.time ;;
  }

  measure:  time_seconds {
    hidden: yes
    type:  number
    sql: TIME_TO_SEC(${time_string}) ;;
  }

  measure: time {
    type:  string
    sql: CAST(SEC_TO_TIME(${time_seconds}) AS CHAR) ;;
  }

  measure: count {
    type: count
    drill_fields: [race]
  }

  measure:  time_hours {
    type: number
    sql: TIME_TO_SEC(${TABLE}.time) / 86400.0;;
    value_format: "h:mm:ss"
  }

  measure:  time_hours_total {
    type: sum
    sql:  TIME_TO_SEC(${TABLE}.time) / 86400.0 ;;
    value_format: "h:mm:ss"

  }

  measure: total_time_seconds {
    type: sum
    sql: TIME_TO_SEC(${TABLE}.time) ;;
    # value_format: "h:mm:ss"
    # value_format: 21
  }

  # measure: total_time_string {
  #   type: string
  #   sql:  CAST(SEC_TO_TIME(${total_time_seconds} AS VARCHAR) ;;
  # }

}

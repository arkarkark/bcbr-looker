view: stages {
  sql_table_name: bcbr.stages ;;
  dimension: climbing {
    type: number
    sql: ${TABLE}.climbing ;;
  }
  
  dimension: length {
    type: number
    sql: ${TABLE}.length ;;
  }
  
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  
  dimension: race {
    type: string
    sql: ${TABLE}.race ;;
  }
  
  dimension: rider_count {
    type: number
    sql: ${TABLE}.rider_count ;;
  }
  
  dimension: stage {
    type: number
    sql: ${TABLE}.stage ;;
  }
  
  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }
  
  measure: count {
    type: count
    drill_fields: [name]
  }
  
}


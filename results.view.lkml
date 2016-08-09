view: results {
  sql_table_name: bcbr.results ;;
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }
  
  dimension: category_position {
    type: string
    sql: ${TABLE}.category_position ;;
  }
  
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  
  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }
  
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  
  dimension: plate {
    type: string
    sql: ${TABLE}.plate ;;
  }
  
  dimension: plate_gender {
    type: string
    sql: ${TABLE}.plate_gender ;;
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
  
  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
  }
  
  dimension: team2 {
    type: string
    sql: ${TABLE}.team2 ;;
  }
  
  dimension: time {
    type: string
    sql: ${TABLE}.time ;;
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


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

# comments are teh best
# this comment is also goo


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

  # measure: time {
  #   type:  string
  #   sql: CAST(SEC_TO_TIME(${time_seconds}) AS CHAR) ;;
  # }

  measure: count {
    type: count
    drill_fields: [race]
  }

  # measure:  time_hours {
  #   type: number
  #   sql: TIME_TO_SEC(${TABLE}.time) / 86400.0;;
  #   value_format: "h:mm:ss"
  # }

  measure:  time_hours_total {
    type: sum
    sql:  TIME_TO_SEC(${TABLE}.time) / 86400.0 ;;
    value_format: "h:mm:ss" # we should worry about days here too...
  }

  measure:  race_position_number {
    type: number
    sql: (
      SELECT count(*)
      FROM (
        SELECT all_results.race, all_results.year, all_results.plate, SUM(TIME_TO_SEC(all_results.time) / 86400.0) as time_hours_total
        from results as all_results
        group by 1,2,3

      ) as flimflap
      WHERE ${time_hours_total} > flimflap.time_hours_total
      and ${race} = flimflap.race
      and ${year} = flimflap.year
    );;
  }

  measure:  category_position_number {
    type: number
    sql: (
      SELECT count(*)
      FROM (
        SELECT all_results.race, all_results.year, all_results.category, all_results.plate, SUM(TIME_TO_SEC(all_results.time) / 86400.0) as time_hours_total
        from results as all_results
        group by 1,2,3,4

      ) as flimflap
      WHERE ${time_hours_total} > flimflap.time_hours_total
      and ${race} = flimflap.race
      and ${year} = flimflap.year
      and ${category} = flimflap.category
    );;
  }

  measure:  category_position_percent {
    type: number
    sql:  ${category_position_number} * 100.0 / ${racers.category_size};;

  }

  measure:  race_position_percent {
    type: number
    sql:  ${race_position_number} * 100.0 / ${racers.race_size};;

  }

  # measure: total_time_seconds {
  #   type: sum
  #   sql: TIME_TO_SEC(${TABLE}.time) ;;
  #   # value_format: "h:mm:ss"
  #   # value_format: 21
  # }

  # measure: total_time_string {
  #   type: string
  #   sql:  CAST(SEC_TO_TIME(${total_time_seconds} AS VARCHAR) ;;
  # }

}

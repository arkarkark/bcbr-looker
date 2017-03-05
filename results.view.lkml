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

  measure:average_time_hours_total {
    type:  average
    sql:  TIME_TO_SEC(${TABLE}.time) / 86400.0 ;;
    value_format: "h:mm:ss"
  }


  measure:  stage_time_hours_cumulative {
    type: sum
    sql:  (select SUM(stage_time_hours_cumulative) from (
    select  race, year, stage, plate, TIME_TO_SEC(time) / 86400.0 as stage_time_hours_cumulative
    from results as aa
    group by 1,2,3,4
    ) as zz
      where ${race} = zz.race
      and ${stage} >= zz.stage
      and ${year} = zz.year
      and ${plate} = zz.plate
   );;

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
  measure:  stage_race_position_number {
    type: number
    sql:   CASE WHEN ${time_hours_total} = 0 THEN null
      ELSE (
      SELECT count(*)
      FROM (
        SELECT all_results.race, all_results.year, all_results.stage, all_results.plate, SUM(TIME_TO_SEC(all_results.time) / 86400.0) as time_hours_total
        from results as all_results
        group by 1,2,3,4

      ) as flimflap
      WHERE ${time_hours_total} > flimflap.time_hours_total
      and ${race} = flimflap.race
      and ${stage} = flimflap.stage
      and ${year} = flimflap.year
    ) END;;
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

  measure:  stage_category_position_number {
    type: number
    sql:
      CASE WHEN ${time_hours_total} = 0 THEN null
      ELSE
        (
      SELECT count(*)
      FROM (
        SELECT all_results.race, all_results.year, all_results.stage, all_results.category, all_results.plate, SUM(TIME_TO_SEC(all_results.time) / 86400.0) as time_hours_total
        from results as all_results
        group by 1,2,3,4,5

      ) as flimflap
      WHERE ${time_hours_total} > flimflap.time_hours_total
      and ${race} = flimflap.race
      and ${year} = flimflap.year
      and ${stage} = flimflap.stage
      and ${category} = flimflap.category
    ) END;;
  }

  measure:  category_position_percent {
    type: number
    sql:  ${category_position_number} * 100.0 / ${racers.category_size};;

  }

  measure:  stage_category_position_percent {
    type: number
    sql:
      CASE WHEN ${stage_category_position_number} = null then null
      else ${stage_category_position_number} * 100.0 / ${racers.category_size}
      end
      ;;
  }

  measure:  race_position_percent {
    type: number
    sql:  ${race_position_number} * 100.0 / ${racers.race_size};;

  }

  measure:  stage_race_position_percent {
    type: number
    sql:  CASE WHEN ${stage_race_position_number} = null then null
          else ${stage_race_position_number} * 100.0 / ${racers.race_size}
          end;;
  }


  measure:  cumulative_stage_category_position_number {
    type: number
    sql:
              CASE WHEN ${stage_time_hours_cumulative} = 0 THEN null
              ELSE
                (
              SELECT count(*)
              FROM (
                SELECT all_results.race, all_results.year, all_results.stage, all_results.category, all_results.plate, (
                  SELECT SUM(TIME_TO_SEC(pp.time) / 86400.0)
                  from results as pp
                  where all_results.race = pp.race
                  and all_results.year = pp.year
                  and all_results.stage >= pp.stage
                  and all_results.plate = pp.plate
                ) as time_hours_total
                from results as all_results
                group by 1,2,3,4,5

              ) as flimflap
              WHERE ${stage_time_hours_cumulative} > flimflap.time_hours_total
              and ${race} = flimflap.race
              and ${year} = flimflap.year
              and ${stage} = flimflap.stage
              and ${category} = flimflap.category
            ) END;;
  }
  measure:  cumulative_stage_category_position_percent {
    type: number
    sql:  CASE WHEN ${cumulative_stage_category_position_number} = null then null
          else ${cumulative_stage_category_position_number} * 100.0 / ${racers.category_size}
          end;;
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

view: racers {
  sql_table_name: bcbr.racers ;;

  dimension: id {
    hidden: yes
    type: string
    primary_key: yes
    sql: CONCAT(${race}, ${year}, ${plate_gender}) ;;

  }
  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    action: {
      label: "Edit"
      url: "https://retina:9317/"
      form_param: {
        name: "city"
        type: string
      }
    }
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
    action: {
      label: "Edit"
      url: "https://localhost:2006/edit"
      param: {
        name: "table"
        value: "racers"
      }
      param: {
        name: "column"
        value: "country"
      }
      form_param: {
        name: "New Value"
        default: "{{ value }}"
        required: yes
      }
    }
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

  dimension: race {
    type: string
    sql: ${TABLE}.race ;;
  }

  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: team2 {
    type: string
    sql: ${TABLE}.team2 ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }

  measure:  category_size  {
    type:  number


    sql:
       (select COUNT(DISTINCT plate) as size

       from racers as ally
       WHERE ${category} =  ally.category
       and ${race} = ally.race
       and ${year} = ally.year
      );;
  }

  measure:  race_size  {
    type:  number


    sql:
         (select COUNT(DISTINCT plate) as size

         from racers as ally
         where ${race} = ally.race
         and ${year} = ally.year
        );;
  }


}

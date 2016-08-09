view: categories {
  view_label: ""
  sql_table_name: bcbr.categories ;;
  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, category_name]
  }
    dimension: race {
      type: string
      sql: ${TABLE}.race ;;
    }

    dimension: year {
      type: number
      sql: ${TABLE}.year ;;
    }

}

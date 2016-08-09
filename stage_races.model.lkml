connection: "bcbr"
include: "*.view.lkml"
include: "*.dashboard.lkml"

explore: racers {
  join: results {
    type: left_outer
    relationship: one_to_many
    sql_on: ${racers.race} = ${results.race} and ${racers.year} = ${results.year} and ${racers.plate_gender} = ${results.plate_gender};;
  }

  always_filter: {
    racers.race: "BCBR"
    racers.year: "2016"
  }
}
explore: results {
  join: racers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${racers.race} = ${results.race} and ${racers.year} = ${results.year} and ${racers.plate_gender} = ${results.plate_gender};;
  }

}
explore: stages {}

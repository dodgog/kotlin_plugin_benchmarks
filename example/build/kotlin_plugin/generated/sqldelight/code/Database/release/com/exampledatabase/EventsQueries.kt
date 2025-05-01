package com.exampledatabase

import app.cash.sqldelight.Query
import app.cash.sqldelight.TransacterImpl
import app.cash.sqldelight.db.QueryResult
import app.cash.sqldelight.db.SqlCursor
import app.cash.sqldelight.db.SqlDriver
import kotlin.Any
import kotlin.String

public class EventsQueries(
  driver: SqlDriver,
) : TransacterImpl(driver) {
  public fun <T : Any> getEvents(mapper: (
    id: String,
    entity_id: String,
    attribute: String,
    value_: String,
    timestamp: String,
  ) -> T): Query<T> = Query(1_870_673_030, arrayOf("events"), driver, "Events.sq", "getEvents",
      "SELECT * FROM events") { cursor ->
    mapper(
      cursor.getString(0)!!,
      cursor.getString(1)!!,
      cursor.getString(2)!!,
      cursor.getString(3)!!,
      cursor.getString(4)!!
    )
  }

  public fun getEvents(): Query<Events> = getEvents { id, entity_id, attribute, value_, timestamp ->
    Events(
      id,
      entity_id,
      attribute,
      value_,
      timestamp
    )
  }

  public fun <T : Any> getEventByEntityId(entity_id: String, mapper: (
    id: String,
    entity_id: String,
    attribute: String,
    value_: String,
    timestamp: String,
  ) -> T): Query<T> = GetEventByEntityIdQuery(entity_id) { cursor ->
    mapper(
      cursor.getString(0)!!,
      cursor.getString(1)!!,
      cursor.getString(2)!!,
      cursor.getString(3)!!,
      cursor.getString(4)!!
    )
  }

  public fun getEventByEntityId(entity_id: String): Query<Events> = getEventByEntityId(entity_id) {
      id, entity_id_, attribute, value_, timestamp ->
    Events(
      id,
      entity_id_,
      attribute,
      value_,
      timestamp
    )
  }

  public fun insertEvent(
    id: String,
    entity_id: String,
    attribute: String,
    value_: String,
    timestamp: String,
  ) {
    driver.execute(-62_686_696, """
        |INSERT INTO events (
        |    id,
        |    entity_id,
        |    attribute,
        |    value,
        |    timestamp
        |)
        |VALUES (
        |    ?,
        |    ?,
        |    ?,
        |    ?,
        |    ?
        |)
        """.trimMargin(), 5) {
          bindString(0, id)
          bindString(1, entity_id)
          bindString(2, attribute)
          bindString(3, value_)
          bindString(4, timestamp)
        }
    notifyQueries(-62_686_696) { emit ->
      emit("events")
    }
  }

  public fun resetDatabase() {
    driver.execute(-1_971_261_215, """DELETE FROM events""", 0)
    notifyQueries(-1_971_261_215) { emit ->
      emit("events")
    }
  }

  private inner class GetEventByEntityIdQuery<out T : Any>(
    public val entity_id: String,
    mapper: (SqlCursor) -> T,
  ) : Query<T>(mapper) {
    override fun addListener(listener: Query.Listener) {
      driver.addListener("events", listener = listener)
    }

    override fun removeListener(listener: Query.Listener) {
      driver.removeListener("events", listener = listener)
    }

    override fun <R> execute(mapper: (SqlCursor) -> QueryResult<R>): QueryResult<R> =
        driver.executeQuery(-1_564_199_102, """SELECT * FROM events WHERE entity_id = ?""", mapper,
        1) {
      bindString(0, entity_id)
    }

    override fun toString(): String = "Events.sq:getEventByEntityId"
  }
}

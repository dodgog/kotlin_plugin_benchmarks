package com.example.database

import app.cash.sqldelight.Transacter
import app.cash.sqldelight.db.QueryResult
import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.db.SqlSchema
import com.example.database.kotlinplugin.newInstance
import com.example.database.kotlinplugin.schema
import com.exampledatabase.EventsQueries
import kotlin.Unit

public interface Database : Transacter {
  public val eventsQueries: EventsQueries

  public companion object {
    public val Schema: SqlSchema<QueryResult.Value<Unit>>
      get() = Database::class.schema

    public operator fun invoke(driver: SqlDriver): Database = Database::class.newInstance(driver)
  }
}

package com.example.database

import app.cash.sqldelight.db.SqlDriver
import com.example.database.Database

interface DatabaseDriverFactory {
  fun createDriver(): SqlDriver
}

fun createDatabase(driverFactory: DatabaseDriverFactory): Database {
  val driver = driverFactory.createDriver()
  val database = Database(driver)
  
  return database
}

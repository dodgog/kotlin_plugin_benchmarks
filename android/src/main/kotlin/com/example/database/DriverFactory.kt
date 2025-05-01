package com.example.database

import android.content.Context
import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.android.AndroidSqliteDriver
import com.example.database.Database

class DriverFactory(private val context: Context) : DatabaseDriverFactory {
  override fun createDriver(): SqlDriver {
    return AndroidSqliteDriver(Database.Schema, context, "test.db")
  }
}

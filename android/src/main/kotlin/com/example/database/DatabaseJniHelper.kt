package com.example.database

import android.content.Context
import androidx.annotation.Keep
import app.cash.sqldelight.db.SqlDriver
import com.example.database.Database
import java.util.UUID
import kotlin.random.Random
import app.cash.sqldelight.Query
import com.exampledatabase.Events


@Keep
class DatabaseJniHelper(private val context: Context) {
    private val driverFactory: DriverFactory = DriverFactory(context)
    private val driver: SqlDriver = driverFactory.createDriver()
    private val database: Database = Database(driver)
    val eventsQueries = database.eventsQueries
//
    fun execQuery(query: Query<Events>): List<Events> {
        return query.executeAsList()
    }

    /**
     * Benchmarks the performance of event inserts by performing 100 random inserts
     * and returning the average time in microseconds.
     */
    fun benchmarkEventInserts(): String {
        val times = mutableListOf<Long>()

        // Clear existing data
        eventsQueries.resetDatabase()

        // Perform 100 inserts and measure time
        repeat(100) {
            val startTime = System.nanoTime()

            eventsQueries.insertEvent(
                id = UUID.randomUUID().toString(),
                entity_id = "abc1",
                attribute = "woo",
                value_ = "hoo",
                timestamp = System.currentTimeMillis().toString()
            )

            val endTime = System.nanoTime()
            times.add(endTime - startTime)
        }

        val averageTimeMicros =
            times.average() / 1000.0 // Convert nanoseconds to microseconds
        return "Average insert time: %.2f microseconds".format(averageTimeMicros)
    }

    /**
     * Benchmarks the performance of event selects by:
     * 1. Inserting 1000 events with ~200 different entity_ids
     * 2. Performing select queries for each unique entity_id
     * 3. Returning the average select time in microseconds
     */
    fun benchmarkEventSelects(): String {
        // Clear existing data
        eventsQueries.resetDatabase()

        // Generate 200 unique entity_ids
        val entityIds = List(200) { "entity_$it" }

        // Insert 1000 events with random entity_ids
        repeat(1000) {
            eventsQueries.insertEvent(
                id = UUID.randomUUID().toString(),
                entity_id = entityIds.random(),
                attribute = "test_attr",
                value_ = "test_value",
                timestamp = System.currentTimeMillis().toString()
            )
        }

        // Measure select performance
        val times = mutableListOf<Long>()

        // Query each entity_id once
        entityIds.forEach { entityId ->
            val startTime = System.nanoTime()
            eventsQueries.getEventByEntityId(entityId).executeAsList()
            val endTime = System.nanoTime()
            times.add(endTime - startTime)
        }

        val averageTimeMicros =
            times.average() / 1000.0 // Convert nanoseconds to microseconds
        return "Average select time: %.2f microseconds".format(averageTimeMicros)
    }

    /**
     * Benchmarks both event inserts and selects in a single function:
     * 1. Clears database
     * 2. Pre-populates with initial events
     * 3. Performs timed inserts
     * 4. Performs timed selects
     * @param countOfEntities number of initial events to insert (default 100)
     */
    fun benchmarkEventInsertsAndSelects(countOfEntities: Int = 100): String {
        val eventsPerEntity = 5
        val trials = 100

        // Clear existing data
        eventsQueries.resetDatabase()

        // Generate entity_ids
        val entityIds =
            List((countOfEntities + trials / eventsPerEntity).toInt()) { index ->
                "entity_$index"
            }

        // First insert countOfEntities events without timing
        repeat(countOfEntities) {
            eventsQueries.insertEvent(
                id = UUID.randomUUID().toString(),
                entity_id = entityIds[Random.nextInt(entityIds.size)],
                attribute = "test_attr",
                value_ = "test_value",
                timestamp = System.currentTimeMillis().toString()
            )
        }

        // Now perform trials number of timed inserts
        val insertTimes = mutableListOf<Long>()
        repeat(trials) {
            val startTime = System.nanoTime()
            eventsQueries.insertEvent(
                id = UUID.randomUUID().toString(),
                entity_id = entityIds[Random.nextInt(entityIds.size)],
                attribute = "test_attr",
                value_ = "test_value",
                timestamp = System.currentTimeMillis().toString()
            )
            val endTime = System.nanoTime()
            insertTimes.add((endTime - startTime) / 1000) // Convert to microseconds
        }

        // Measure select performance
        val selectTimes = mutableListOf<Long>()

        // Perform trials number of select queries
        repeat(trials) {
            val entityId = entityIds[Random.nextInt(entityIds.size)]
            val startTime = System.nanoTime()
            eventsQueries.getEventByEntityId(entityId).executeAsList()
            val endTime = System.nanoTime()
            selectTimes.add((endTime - startTime) / 1000) // Convert to microseconds
        }

        val avgInsertTime = insertTimes.average()
        val avgSelectTime = selectTimes.average()

        return ("Average insert time (timer): %.2f microseconds\n Average " +
                "select time (timer): %.2f microseconds").format(
            avgInsertTime,
            avgSelectTime
        )
    }

    /**
     * Clean up resources when the instance is no longer needed
     */
    fun close() {
        driver.close()
    }
}

-keep class kotlin.coroutines.** { *; }
# Keep SQLDelight classes
-keep class com.example.database.** { *; }
-keep class com.exampledatabase.** { *; }
-keep class app.cash.sqldelight.** { *; }

# Specifically keep the getEventsQueries method
-keepclassmembers class com.example.database.DatabaseJniHelper {
    public com.exampledatabase.EventsQueries getEventsQueries();
}
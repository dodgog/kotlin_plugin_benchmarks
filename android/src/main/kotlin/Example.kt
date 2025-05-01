import androidx.annotation.Keep
import kotlinx.coroutines.*
import java.io.File
import android.app.Application
import java.util.Date
import io.flutter.embedding.engine.plugins.FlutterPlugin
import android.os.Environment
import android.content.Context
import app.cash.sqldelight.db.SqlDriver
import com.example.database.Database

@Keep
class EventStuff {
    suspend fun insertStuff(): String {
        return "alo"
    }
}

@Keep
class Example {
    companion object {
        const val ERROR_MESSAGE = "This is a static error message"
    }

    suspend fun thinkBeforeAnswering(): String {
        delay(1000L)
        return "42"
    }

    fun aloha(word: String): List<Int> {
        return word.map { it.code }
    }

    fun throwError(): String {
        throw RuntimeException(ERROR_MESSAGE)
    }

}

@Keep
class Document(private val context: Context, private val fileName: String) {
    private var fileSize: Long = 0
    private var lastModified: Date = Date()
    private var mimeType: String = "text/plain"
    private var filePath: String = ""

    init {
        createExampleDocument()
    }

    private fun createExampleDocument() {
        try {
            // Create the file in the app's internal storage
            val file = File(context.filesDir, fileName)
            filePath = file.absolutePath

            // Write some example content
            val content =
                "This is an example document created by the Kotlin plugin.\n" +
                        "You can modify this content as needed."

            file.writeText(content)
            fileSize = file.length()
            lastModified = Date(file.lastModified())
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun getMetadata(): Map<String, Any> {
        return mapOf(
            "filePath" to filePath,
            "fileName" to fileName,
            "fileSize" to fileSize,
            "lastModified" to lastModified.time,
            "mimeType" to mimeType
        )
    }

    fun getContent(): String {
        return try {
            File(filePath).readText()
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }
}

package com.example.dailyquest.widget

import android.graphics.Color
import org.json.JSONObject
import java.time.LocalDateTime
import java.time.format.DateTimeParseException

/** Colors of one brightness, as written by the Dart `WidgetSnapshot`. */
data class WidgetPalette(
    val background: Int,
    val label: Int,
    val secondary: Int,
    val fill: Int,
    val accent: Int,
    val accentTint: Int,
    val onAccent: Int,
    val ring: Int,
    val success: Int,
) {
    companion object {
        fun from(json: JSONObject) = WidgetPalette(
            background = color(json, "background"),
            label = color(json, "label"),
            secondary = color(json, "secondary"),
            fill = color(json, "fill"),
            accent = color(json, "accent"),
            accentTint = color(json, "accentTint"),
            onAccent = color(json, "onAccent"),
            ring = color(json, "ring"),
            success = color(json, "success"),
        )

        val defaultLight = WidgetPalette(
            Color.WHITE, 0xFF1C1C1E.toInt(), 0xFF6E6E73.toInt(), 0xFFE5E5EA.toInt(),
            0xFF0062CC.toInt(), 0xFFE0EDFA.toInt(), Color.WHITE, 0xFF007AFF.toInt(),
            0xFF248A3D.toInt(),
        )
        val defaultDark = WidgetPalette(
            0xFF1C1C1E.toInt(), Color.WHITE, 0xFF98989D.toInt(), 0xFF3A3A3C.toInt(),
            0xFF5AA9FF.toInt(), 0xFF27374A.toInt(), Color.BLACK, 0xFF0A84FF.toInt(),
            0xFF30D158.toInt(),
        )
    }
}

data class WidgetTask(
    val id: Int,
    val name: String,
    val glyph: String,
    val colorLight: Int,
    val colorDark: Int,
    val onColorLight: Int,
    val onColorDark: Int,
    val progress: Int,
    val target: Int,
    val step: Int,
    val unit: String,
    val done: Boolean,
) {
    val fraction: Float get() = if (target <= 0) 0f else (progress.toFloat() / target).coerceIn(0f, 1f)
}

/** Parsed `dq_snapshot`. Unknown versions or bad JSON yield `null`. */
data class WidgetSnapshot(
    val date: String,
    val done: Int,
    val total: Int,
    val streak: Int,
    val mode: String,
    val title: String,
    val emptyText: String,
    val staleText: String,
    val nextDayAt: LocalDateTime?,
    val light: WidgetPalette,
    val dark: WidgetPalette,
    val tasks: List<WidgetTask>,
) {
    val ratio: Float get() = if (total == 0) 0f else done.toFloat() / total

    /** True once the logical day the snapshot describes has ended. */
    fun isStale(now: LocalDateTime = LocalDateTime.now()): Boolean =
        nextDayAt != null && !now.isBefore(nextDayAt)

    companion object {
        const val VERSION = 1

        fun parse(raw: String?): WidgetSnapshot? {
            if (raw.isNullOrEmpty()) return null
            return try {
                val json = JSONObject(raw)
                if (json.optInt("v") != VERSION) return null
                val colors = json.getJSONObject("colors")
                val tasks = json.getJSONArray("tasks")
                WidgetSnapshot(
                    date = json.getString("date"),
                    done = json.getInt("done"),
                    total = json.getInt("total"),
                    streak = json.optInt("streak"),
                    mode = json.optString("mode", "system"),
                    title = json.optString("title"),
                    emptyText = json.optString("emptyText"),
                    staleText = json.optString("staleText"),
                    nextDayAt = parseTime(json.optString("nextDayAt")),
                    light = WidgetPalette.from(colors.getJSONObject("light")),
                    dark = WidgetPalette.from(colors.getJSONObject("dark")),
                    tasks = (0 until tasks.length()).map { i ->
                        val t = tasks.getJSONObject(i)
                        val c = t.getJSONObject("color")
                        val on = t.getJSONObject("onColor")
                        WidgetTask(
                            id = t.getInt("id"),
                            name = t.getString("name"),
                            glyph = t.optString("glyph", "•"),
                            colorLight = parseColor(c.getString("light")),
                            colorDark = parseColor(c.getString("dark")),
                            onColorLight = parseColor(on.getString("light")),
                            onColorDark = parseColor(on.getString("dark")),
                            progress = t.getInt("progress"),
                            target = t.getInt("target"),
                            step = t.getInt("step"),
                            unit = t.optString("unit"),
                            done = t.optBoolean("done"),
                        )
                    },
                )
            } catch (e: Exception) {
                null
            }
        }

        private fun parseTime(value: String?): LocalDateTime? = try {
            if (value.isNullOrEmpty()) null else LocalDateTime.parse(value)
        } catch (e: DateTimeParseException) {
            null
        }
    }
}

private fun color(json: JSONObject, key: String) = parseColor(json.getString(key))

private fun parseColor(hex: String): Int = Color.parseColor(hex)

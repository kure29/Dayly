package com.example.dailyquest.widget

import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.net.Uri
import android.os.Build
import android.util.TypedValue
import android.view.View
import android.widget.RemoteViews
import com.example.dailyquest.MainActivity
import com.example.dailyquest.R
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent

/**
 * Shared drawing helpers. Colors are applied as tints on white masks so that
 * on Android 12+ every color has a light and a dark value and the launcher
 * switches them with the system theme without re-rendering.
 */
class WidgetRenderer(private val context: Context, val snapshot: WidgetSnapshot?) {

    private val mode = snapshot?.mode ?: "system"
    private val light = snapshot?.light ?: WidgetPalette.defaultLight
    private val dark = snapshot?.dark ?: WidgetPalette.defaultDark

    private val nightNow: Boolean
        get() = (context.resources.configuration.uiMode and
            Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES

    val isStale: Boolean get() = snapshot?.isStale() ?: true

    /** Applies a day/night color pair to [method] (e.g. setTextColor). */
    fun color(views: RemoteViews, id: Int, method: String, lightColor: Int, darkColor: Int) {
        when {
            mode == "light" -> views.setInt(id, method, lightColor)
            mode == "dark" -> views.setInt(id, method, darkColor)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ->
                views.setColorInt(id, method, lightColor, darkColor)
            else -> views.setInt(id, method, if (nightNow) darkColor else lightColor)
        }
    }

    fun color(views: RemoteViews, id: Int, method: String, pick: (WidgetPalette) -> Int) =
        color(views, id, method, pick(light), pick(dark))

    fun text(views: RemoteViews, id: Int, pick: (WidgetPalette) -> Int) =
        color(views, id, "setTextColor", pick)

    fun tint(views: RemoteViews, id: Int, pick: (WidgetPalette) -> Int) =
        color(views, id, "setColorFilter", pick)

    fun applyBackground(views: RemoteViews) {
        tint(views, R.id.widget_bg) { it.background }
        views.setOnClickPendingIntent(
            R.id.widget_root,
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse("dailyquest://open"),
            ),
        )
    }

    /** Ring: track + progress masks and the percentage label. */
    fun applyRing(views: RemoteViews, sizeDp: Float, strokeDp: Float) {
        val s = snapshot
        val ratio = if (s == null || isStale) 0f else s.ratio
        val size = px(sizeDp).toInt()
        val stroke = px(strokeDp)
        views.setImageViewBitmap(R.id.ring_track, ringMask(size, stroke, 1f))
        views.setImageViewBitmap(R.id.ring_progress, ringMask(size, stroke, ratio))
        tint(views, R.id.ring_track) { it.fill }
        val complete = s != null && !isStale && s.total > 0 && s.done == s.total
        tint(views, R.id.ring_progress) { if (complete) it.success else it.ring }
        views.setTextViewText(R.id.ring_label, "${(ratio * 100).toInt()}%")
        text(views, R.id.ring_label) { it.label }
    }

    fun applySummary(views: RemoteViews) {
        val s = snapshot
        views.setTextViewText(
            R.id.summary_done,
            if (s == null || isStale) "–" else "${s.done}/${s.total}",
        )
        views.setTextViewText(R.id.summary_title, s?.title ?: "")
        text(views, R.id.summary_done) { it.label }
        text(views, R.id.summary_title) { it.secondary }
    }

    /** A task row (nested RemoteViews) for [task]. */
    fun taskRow(task: WidgetTask, withButton: Boolean, withBar: Boolean): RemoteViews {
        val row = RemoteViews(context.packageName, R.layout.widget_task_row)
        row.setTextViewText(R.id.row_glyph, task.glyph)
        color(row, R.id.row_glyph_bg, "setColorFilter", task.colorLight, task.colorDark)
        color(row, R.id.row_glyph, "setTextColor", task.onColorLight, task.onColorDark)
        row.setTextViewText(R.id.row_name, task.name)
        text(row, R.id.row_name) { if (task.done) it.secondary else it.label }
        row.setTextViewText(R.id.row_progress, "${task.progress}/${task.target} ${task.unit}")
        text(row, R.id.row_progress) { it.secondary }

        if (withBar) {
            row.setViewVisibility(R.id.row_bar, View.VISIBLE)
            row.setImageViewBitmap(R.id.row_bar_progress, barMask(task.fraction))
            tint(row, R.id.row_bar_track) { it.fill }
            if (task.done) {
                tint(row, R.id.row_bar_progress) { it.success }
            } else {
                color(row, R.id.row_bar_progress, "setColorFilter", task.colorLight, task.colorDark)
            }
        } else {
            row.setViewVisibility(R.id.row_bar, View.GONE)
        }

        val showButton = withButton && !task.done && !isStale
        row.setViewVisibility(R.id.row_plus, if (showButton) View.VISIBLE else View.GONE)
        row.setViewVisibility(R.id.row_check, if (task.done) View.VISIBLE else View.GONE)
        if (task.done) text(row, R.id.row_check) { it.success }
        if (showButton) {
            tint(row, R.id.row_plus_bg) { it.accentTint }
            text(row, R.id.row_plus_label) { it.accent }
            row.setOnClickPendingIntent(
                R.id.row_plus,
                HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("dailyquest://checkin?task=${task.id}&date=${snapshot!!.date}"),
                ),
            )
        }
        return row
    }

    /** Fills [containerId] with up to [max] rows, or shows the empty text. */
    fun applyRows(
        views: RemoteViews,
        containerId: Int,
        emptyId: Int,
        max: Int,
        withButton: Boolean,
        withBar: Boolean,
    ) {
        views.removeAllViews(containerId)
        val s = snapshot
        val message = when {
            s == null -> ""
            isStale -> s.staleText
            s.tasks.isEmpty() -> s.emptyText
            else -> null
        }
        if (message != null) {
            views.setViewVisibility(emptyId, View.VISIBLE)
            views.setTextViewText(emptyId, message)
            text(views, emptyId) { it.secondary }
            return
        }
        views.setViewVisibility(emptyId, View.GONE)
        // Unfinished tasks first so the buttons that matter are visible.
        val ordered = s!!.tasks.sortedBy { it.done }
        ordered.take(max).forEach { views.addView(containerId, taskRow(it, withButton, withBar)) }
    }

    private fun px(dp: Float) =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.resources.displayMetrics)

    private fun ringMask(size: Int, stroke: Float, fraction: Float): Bitmap {
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ALPHA_8)
        if (fraction <= 0f) return bmp
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            style = Paint.Style.STROKE
            strokeWidth = stroke
            strokeCap = Paint.Cap.ROUND
            color = android.graphics.Color.WHITE
        }
        val inset = stroke / 2
        val rect = RectF(inset, inset, size - inset, size - inset)
        Canvas(bmp).drawArc(rect, -90f, 360f * fraction.coerceAtMost(1f), false, paint)
        return bmp
    }

    private fun barMask(fraction: Float): Bitmap {
        val w = px(240f).toInt()
        val h = px(4f).toInt().coerceAtLeast(2)
        val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ALPHA_8)
        if (fraction <= 0f) return bmp
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { color = android.graphics.Color.WHITE }
        Canvas(bmp).drawRoundRect(RectF(0f, 0f, w * fraction, h.toFloat()), h / 2f, h / 2f, paint)
        return bmp
    }
}

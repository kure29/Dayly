package com.example.dailyquest.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.dailyquest.R
import es.antonborri.home_widget.HomeWidgetProvider

private const val SNAPSHOT_KEY = "dq_snapshot"

/** Common update loop: parse the snapshot once, render every instance. */
abstract class BaseTaskWidget : HomeWidgetProvider() {
    abstract val layout: Int

    abstract fun render(renderer: WidgetRenderer, views: RemoteViews)

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val snapshot = WidgetSnapshot.parse(widgetData.getString(SNAPSHOT_KEY, null))
        val renderer = WidgetRenderer(context, snapshot)
        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, layout)
            renderer.applyBackground(views)
            render(renderer, views)
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}

/** 2×2: progress ring + completed count. */
class SmallTaskWidget : BaseTaskWidget() {
    override val layout = R.layout.widget_small

    override fun render(renderer: WidgetRenderer, views: RemoteViews) {
        renderer.applyRing(views, sizeDp = 76f, strokeDp = 9f)
        renderer.applySummary(views)
    }
}

/** 4×2: ring + four rows with a "+" button for checking in on the home screen. */
class MediumTaskWidget : BaseTaskWidget() {
    override val layout = R.layout.widget_medium

    override fun render(renderer: WidgetRenderer, views: RemoteViews) {
        renderer.applyRing(views, sizeDp = 64f, strokeDp = 8f)
        renderer.applySummary(views)
        renderer.applyRows(
            views, R.id.rows, R.id.rows_empty, max = 4, withButton = true, withBar = false,
        )
    }
}

/** 4×4: ring + progress bars for all of today's tasks. */
class LargeTaskWidget : BaseTaskWidget() {
    override val layout = R.layout.widget_large

    override fun render(renderer: WidgetRenderer, views: RemoteViews) {
        renderer.applyRing(views, sizeDp = 64f, strokeDp = 8f)
        renderer.applySummary(views)
        renderer.applyRows(
            views, R.id.rows, R.id.rows_empty, max = 8, withButton = false, withBar = true,
        )
    }
}

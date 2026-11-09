package com.turskyi.investtrack

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import androidx.core.graphics.toColorInt
import es.antonborri.home_widget.HomeWidgetPlugin

class InvestTrackWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetData: SharedPreferences = HomeWidgetPlugin.getData(context)
    val portfolioValue =
        widgetData.getString(
            "total_portfolio_value",
            "$0.00",
        ) ?: "$0.00"
    val gainOrLoss =
        widgetData.getString(
            "total_gain_or_loss",
            "+$0.00",
        ) ?: "+$0.00"
    val gainLossPct =
        widgetData.getString(
            "total_gain_or_loss_percentage",
            "(+0.00%)",
        )
            ?: "(+0.00%)"
    val isPositive = widgetData.getBoolean("is_positive", true)
    val invested = widgetData.getString(
        "total_invested",
        "$0.00",
    ) ?: "$0.00"
    val lastUpdated =
        widgetData.getString(
            "last_updated",
            "Just now",
        ) ?: "Just now"
    val appTheme = widgetData.getString(
        "app_theme",
        "vibrant",
    ) ?: "vibrant"
    val portfolioValueLabel = widgetData.getString(
        "total_portfolio_value_label",
        "Total Portfolio Value"
    ) ?: "Total Portfolio Value"
    val investedLabel =
        widgetData.getString(
            "invested_label",
            "Invested",
        ) ?: "Invested"

    val views =
        RemoteViews(
            context.packageName,
            R.layout.invest_track_widget,
        ).apply {
            setTextViewText(
                R.id.tv_portfolio_value_label,
                portfolioValueLabel,
            )
            setTextViewText(
                R.id.tv_portfolio_value,
                portfolioValue,
            )
            setTextViewText(
                R.id.tv_gain_loss,
                "$gainOrLoss ($gainLossPct)",
            )
            setTextViewText(
                R.id.tv_invested,
                "$investedLabel: $invested",
            )
            setTextViewText(R.id.tv_last_updated, lastUpdated)

            val textColor =
                if (isPositive)
                    "#81C784".toColorInt()
                else "#E57373".toColorInt()
            setInt(
                R.id.tv_gain_loss,
                "setTextColor",
                textColor,
            )

            val backgroundRes = if (appTheme == "stealth") {
                R.drawable.widget_background_stealth
            } else {
                R.drawable.widget_background
            }
            setInt(
                R.id.widget_background_container,
                "setBackgroundResource",
                backgroundRes
            )

            val intent = Intent(
                context,
                MainActivity::class.java,
            ).apply {
                action = "es.antonborri.home_widget.action.LAUNCH"
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT
                        or PendingIntent.FLAG_IMMUTABLE,
            )
            setOnClickPendingIntent(
                R.id.widget_background_container,
                pendingIntent
            )
        }

    appWidgetManager.updateAppWidget(appWidgetId, views)
}

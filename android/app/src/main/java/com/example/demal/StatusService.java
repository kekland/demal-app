package com.example.demal;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.AudioManager;
import android.os.Build;
import android.os.IBinder;
import android.preference.PreferenceManager;
import android.speech.tts.Voice;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.widget.RemoteViews;

import java.util.HashMap;
import java.util.Map;

import static android.support.v4.app.NotificationCompat.DEFAULT_SOUND;
import static android.support.v4.app.NotificationCompat.DEFAULT_VIBRATE;
import static android.support.v4.app.NotificationCompat.PRIORITY_LOW;

/**
 * Created by kkerz on 30-May-18.
 */

public class StatusService extends Service {
    StatusThread thread;
    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("DeviceService", "Received intent");
        if (intent.getAction().equals(Constants.ACTION.STARTFOREGROUND_ACTION)) {
            Log.i("DeviceService", "Received Start Foreground Intent");
            showNotification();
            String mac = intent.getExtras().getString("mac");
            final Context context = this;
            thread = new StatusThread(this, mac, new StatusThread.AirDeviceCallback() {
                @Override
                public void onData(double gasNormalized, double gasQuality, double humidityNormalized, double humidityQuality, double overallQuality, int temperature) {NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                    String overallQualityString = AirQualityMath.getOverallAirQualityString(overallQuality);
                    String gasesQualityString = AirQualityMath.getGasesQualityString(gasQuality);

                    if(MainActivity.eventSinkAvailable) {
                        Map<String, Object> values = new HashMap<String, Object>();

                        values.put("gasNormalized", gasNormalized);
                        values.put("gasQuality", gasQuality);
                        values.put("humidityNormalized", humidityNormalized);
                        values.put("humidityQuality", humidityQuality);
                        values.put("overallQuality", overallQuality);
                        values.put("temperature", temperature);
                        values.put("overallQualityString", overallQualityString);
                        values.put("gasQualityString", gasesQualityString);

                        MainActivity.dataEventSink.success(values);
                    }
                    mNotificationManager.notify(Constants.NOTIFICATION_ID.FOREGROUND_SERVICE, getNotification(
                            gasesQualityString,
                            (int)Math.round(humidityNormalized * 100.0),
                            "No data",
                            (int)Math.round(overallQuality * 100.0)));
                }
            });
            thread.run();
            //Do stuff
        }
        else if (intent.getAction().equals(Constants.ACTION.STOPFOREGROUND_ACTION)) {
            Log.i("DeviceService", "Received Stop Foreground Intent");
            thread.cancel();
            stopSelf();
            stopForeground(true);
        }
        return START_STICKY;
    }

    void showNotification() {
        createNotificationChannel();

        startForeground(Constants.NOTIFICATION_ID.FOREGROUND_SERVICE,
                getNotification("Loading", 0, "Not available", 0));
    }

    Notification getNotification(String airQuality, int humidity, String dustParticles, int overall) {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        notificationIntent.setAction(Constants.ACTION.MAIN_ACTION);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0);

        RemoteViews views = new RemoteViews(this.getPackageName(),R.layout.notification_main);

        views.setTextViewText(R.id.airQualityDataText, airQuality);
        views.setTextViewText(R.id.humidityDataText, Integer.toString(humidity) + "%");
        views.setTextViewText(R.id.dustDataText, dustParticles);
        views.setTextViewText(R.id.airQualityDataPercent, overall + "");

        Notification notification = new NotificationCompat.Builder(this, "dem_al_main")
                .setSmallIcon(R.drawable.ic_cloud_white_24dp)
                .setContent(views)
                .setContentIntent(pendingIntent)
                .setOngoing(true).build();

        removeSoundAndVibration(notification);

        return notification;
    }
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Air quality data";

            int importance = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel channel = new NotificationChannel("dem_al_main", name, importance);
            channel.enableVibration(false);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
    private void removeSoundAndVibration(Notification notification) {
        notification.sound = null;
        notification.vibrate = null;
        notification.defaults &= ~DEFAULT_SOUND;
        notification.defaults &= ~DEFAULT_VIBRATE;
    }

        @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i("VoiceService", "In onDestroy");
    }

    @Override
    public IBinder onBind(Intent intent) {
        // Used only in case of bound services.
        return null;
    }
}
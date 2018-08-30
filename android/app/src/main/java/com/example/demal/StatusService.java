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
        if (intent.getAction().equals(Constants.ACTION.STARTFOREGROUND_ACTION)) {
            Log.i("VoiceService", "Received Start Foreground Intent");
            showNotification();
            String mac = intent.getExtras().getString("mac");
            thread = new StatusThread(this, mac, new StatusThread.AirDeviceCallback() {
                @Override
                public void onData(float airQuality, int humidity, int temperature) {
                    NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                    mNotificationManager.notify(Constants.NOTIFICATION_ID.FOREGROUND_SERVICE, getNotification(airQuality, humidity, temperature));
                }
            });
            thread.run();
            //Do stuff
        }
        else if (intent.getAction().equals(Constants.ACTION.STOPFOREGROUND_ACTION)) {
            Log.i("VoiceService", "Received Stop Foreground Intent");
            stopForeground(true);
            thread.interrupt();
            stopSelf();
        }
        return START_STICKY;
    }

    void showNotification() {



        createNotificationChannel();

        startForeground(Constants.NOTIFICATION_ID.FOREGROUND_SERVICE,
                getNotification(0, 0, 0));
    }

    Notification getNotification(float airQuality, int humidity, int temperature) {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        notificationIntent.setAction(Constants.ACTION.MAIN_ACTION);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
                | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0);

        RemoteViews views = new RemoteViews(this.getPackageName(),R.layout.notification_main);
        String airQualityString = "Good";
        if(airQuality > 0.25f) {
            airQualityString = "Mediocre";
        }
        else if(airQuality > 0.5f) {
            airQualityString = "Bad";
        }
        float airQualityScore = 1f - airQuality;
        float humidityScore = 1f - (Math.abs(50 - humidity) / 50f);
        int totalAirScore = Math.round(airQualityScore * 50 + humidityScore  * 50);
        views.setTextViewText(R.id.airQualityDataText, airQualityString);
        views.setTextViewText(R.id.humidityDataText, Integer.toString(humidity) + "%");
        views.setTextViewText(R.id.dustDataText, "Not available");
        views.setTextViewText(R.id.airQualityDataPercent, totalAirScore + "");

        Notification notification = new NotificationCompat.Builder(this, "dem_al_main")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContent(views)
                .setContentIntent(pendingIntent)
                .setOngoing(true).build();

        return notification;
    }
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Air quality data";

            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel("dem_al_main", name, importance);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
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
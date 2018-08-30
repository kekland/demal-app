package com.example.demal;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kekland.demal/device";
  public static MethodChannel channel;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    channel = new MethodChannel(getFlutterView(), CHANNEL);

    channel.setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                    if(methodCall.method.equals("launchService")) {
                        String mac = methodCall.argument("deviceId");
                        if(!isServiceRunning(StatusService.class)) {
                            launchService(mac);
                            result.success(null);
                        }
                        else {
                            result.error("CANNOT_LAUNCH", "Cannot launch service: Service already launched.", null);
                        }
                    }
                    else if(methodCall.method.equals("stopService")) {
                        if(!isServiceRunning(StatusService.class)) {
                            stopService();
                            result.success(null);
                        }
                        else {
                            result.error("CANNOT_STOP", "Cannot stop service: Service already stopped.", null);
                        }
                    }
                    else {
                        result.notImplemented();
                    }
                }
            }
    );
  }

    void launchService(String mac) {
      Intent startIntent = new Intent(MainActivity.this, StatusService.class);
      startIntent.setAction(Constants.ACTION.STARTFOREGROUND_ACTION);
      Bundle extras = new Bundle();
      extras.putString("mac", mac);
      startIntent.putExtras(extras);
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          startForegroundService(startIntent);
      } else {
          startService(startIntent);
      }
  }

  void stopService() {
      Intent startIntent = new Intent(MainActivity.this, StatusService.class);
      startIntent.setAction(Constants.ACTION.STOPFOREGROUND_ACTION);
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          startForegroundService(startIntent);
      } else {
          startService(startIntent);
      }
  }
    private boolean isServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }
}

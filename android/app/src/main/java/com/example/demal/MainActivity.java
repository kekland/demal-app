package com.example.demal;

import android.app.ActivityManager;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import me.aflak.bluetooth.Bluetooth;
import me.aflak.bluetooth.DiscoveryCallback;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kekland.demal/device";
  private static final String STREAM = "com.kekland.demal/deviceStream";
  public static MethodChannel channel;

  public static EventChannel.EventSink dataEventSink;
  public static boolean eventSinkAvailable;
  public static boolean isScanning = false;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    final Bluetooth bluetooth = new Bluetooth(this);

    channel = new MethodChannel(getFlutterView(), CHANNEL);

    new EventChannel(getFlutterView(), STREAM).setStreamHandler(new EventChannel.StreamHandler() {
        @Override
        public void onListen(Object o, EventChannel.EventSink eventSink) {
            dataEventSink = eventSink;
            eventSinkAvailable = true;
        }

        @Override
        public void onCancel(Object o) {
            eventSinkAvailable = false;
        }
    });
    channel.setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall methodCall, final MethodChannel.Result result) {
                    if(methodCall.method.equals("launchService")) {
                        bluetooth.onStop();
                        String mac = methodCall.argument("deviceId");
                        if(!isServiceRunning(StatusService.class)) {
                            launchService(mac);
                            Log.i("Service", "Launching service");
                            result.success(null);
                        }
                        else {
                            result.error("CANNOT_LAUNCH", "Cannot launch service: Service already launched.", null);
                        }
                    }
                    else if(methodCall.method.equals("stopService")) {
                        if(isServiceRunning(StatusService.class)) {
                            stopService();
                            Log.i("Service", "Stopping service");
                            result.success(null);
                        }
                        else {
                            result.error("CANNOT_STOP", "Cannot stop service: Service already stopped.", null);
                        }
                    }
                    else if(methodCall.method.equals("eventSinkAvailable")) {
                        eventSinkAvailable = true;
                        result.success(null);
                    }
                    else if(methodCall.method.equals("listenForDevice")) {
                        bluetooth.onStart();
                        bluetooth.enable();
                        isScanning = true;
                        Log.i("bt_listen", "started");
                        bluetooth.setDiscoveryCallback(new DiscoveryCallback() {
                            @Override
                            public void onDiscoveryStarted() {
                                Log.i("bt_listen", "started_discovery");
                            }

                            @Override
                            public void onDiscoveryFinished() {
                                Log.i("bt_listen", "finished_discovery");
                            }

                            @Override
                            public void onDeviceFound(BluetoothDevice device) {
                                Log.i("bt_listen", device.getName());
                                if(device.getName() != null && device.getName().equals("DemAl")) {
                                    result.success(device.getAddress());
                                    bluetooth.stopScanning();
                                    bluetooth.removeDiscoveryCallback();
                                    isScanning = false;
                                }
                            }

                            @Override
                            public void onDevicePaired(BluetoothDevice device) {

                            }

                            @Override
                            public void onDeviceUnpaired(BluetoothDevice device) {

                            }

                            @Override
                            public void onError(String message) {
                                Log.i("bt_listen", "error: " + message);
                            }
                        });

                        bluetooth.startScanning();
                    }
                    else if(methodCall.method.equals("stopListeningForDevice")) {
                        if(isScanning) {
                            bluetooth.stopScanning();
                            bluetooth.removeDiscoveryCallback();
                            bluetooth.disable();
                            bluetooth.onStop();
                            isScanning = false;
                        }
                    }
                    else {
                        result.notImplemented();
                    }
                }
            }
    );
  }

  void listenForDevice() {

  }

    @Override
    protected void onPause() {
      eventSinkAvailable = false;
      super.onPause();
    }

    @Override
    protected void onStop() {
      eventSinkAvailable = false;
      super.onStop();
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
    public static boolean isActivityRunning(Context context) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo service : manager.getRunningAppProcesses()) {
            if (MainActivity.class.getName().equals(service.processName)) {
                return true;
            }
        }
        return false;
    }
}

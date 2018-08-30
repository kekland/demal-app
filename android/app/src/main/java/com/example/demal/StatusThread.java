package com.example.demal;

import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.os.Handler;
import android.os.SystemClock;
import android.util.Log;

import me.aflak.bluetooth.Bluetooth;
import me.aflak.bluetooth.DeviceCallback;

public class StatusThread extends Thread {
    public interface AirDeviceCallback {
        void onData(float airQuality, int humidity, int temperature);
    }

    AirDeviceCallback callback;
    Bluetooth bluetooth;
    String deviceAddress;
    StatusThread(Context _context, String _device, AirDeviceCallback _callback) {
        bluetooth = new Bluetooth(_context);
        deviceAddress = _device;
        callback = _callback;
        bluetooth.onStart();
        bluetooth.enable();
    }
    public void run() {
        /*bluetooth.connectToAddress(deviceAddress);
        bluetooth.setDeviceCallback(new DeviceCallback() {
            @Override public void onDeviceConnected(BluetoothDevice device) {
                Log.i("THREAD_DEVICE_CONNECT", device.getName());
            }
            @Override public void onDeviceDisconnected(BluetoothDevice device, String message) {}
            @Override public void onMessage(String message) {
                String[] indices = message.split(",");
                int airQuality = Integer.parseInt(indices[0]);
                int temperature = Integer.parseInt(indices[1]);
                int humidity = Integer.parseInt(indices[2]);

                float airQualityNormalized = airQuality / 1024f;
                callback.onData(airQualityNormalized, humidity, temperature);
            }
            @Override public void onError(String message) {}
            @Override public void onConnectError(BluetoothDevice device, String message) {}
        });*/


        //noinspection InfiniteLoopStatement
        getData();
    }

    int iter = 0;

    void getData() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if(cancelled) {
                    return;
                }
                callback.onData(0.125f, (iter) % 100, 25);
                iter++;
                getData();
            }
        }, 500);
    }
    public boolean cancelled = false;

    public void cancel() {
        cancelled = true;
        bluetooth.disable();
        bluetooth.onStop();
    }
}

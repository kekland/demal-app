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
        void onData(double gasNormalized, double gasQuality, double humidityNormalized, double humidityQuality, double overallQuality, int temperature);
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

        bluetooth.connectToAddress(deviceAddress);
        bluetooth.setDeviceCallback(new DeviceCallback() {
            @Override
            public void onDeviceConnected(BluetoothDevice device) {
                if(cancelled) {
                    return;
                }
                Log.i("DEMAL_DEVICE", "Connected");
            }

            @Override
            public void onDeviceDisconnected(BluetoothDevice device, String message) {
                if(cancelled) {
                    return;
                }
                tryConnect();
            }

            @Override
            public void onMessage(String message) {
                if(cancelled) {
                    return;
                }
                try {
                    String[] indices = message.split(",");
                    int gas = Integer.parseInt(indices[0]);
                    int humidity = Integer.parseInt(indices[1]);
                    int temperature = Integer.parseInt(indices[2]);

                    double gasNormalized = gas / 1024.0;
                    double humNormalized = humidity / 100.0;

                    double gasQuality = AirQualityMath.mapToCustom(gasNormalized, 0.2, 0.2, 0.1);
                    double humidityQuality = AirQualityMath.mapToCustom(humNormalized, 0.3, 0.1, 0.3);

                    double airQuality = AirQualityMath.getOverallAirQuality(gasQuality, humidityQuality, temperature);

                    callback.onData(gasNormalized, gasQuality, humNormalized, humidityQuality, airQuality, temperature);
                }
                catch(Exception e) {
                    Log.w("onMessage.Exception", e.toString());
                    //continue
                }
            }

            @Override
            public void onError(String message) {
                if(cancelled) {
                    return;
                }
                tryConnect();
            }

            @Override
            public void onConnectError(BluetoothDevice device, String message) {
                if(cancelled) {
                    return;
                }
                tryConnect();
            }
        });


        //noinspection InfiniteLoopStatement
        //getData();
    }

    void tryConnect() {
        bluetooth.connectToAddress(deviceAddress);
    }
    public boolean cancelled = false;

    public void cancel() {
        cancelled = true;
        bluetooth.disable();
        bluetooth.onStop();
    }
}

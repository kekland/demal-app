package com.example.demal;

public class AirQualityMath {
    public static double clamp(double val, double min, double max) {
        if(val < min) {
            return min;
        }
        else if(val > max) {
            return max;
        }
        return val;
    }
    public static double mapToCustom(double xPass, double p, double t, double d) {
        double m = p - t;
        double n = p + t;
        double u = 1.0 - d;
        double x = clamp(xPass, 0.0, 1.0);
        double y;
        if(x <= m) {
            y = Math.pow(x / m, 1.0 / 3.0) * u;
        }
        else if(x <= p) {
            y = Math.pow((x - m) / (p - m), 2.0) * d + u;
        }
        else if(x <= n) {
            y = Math.pow((-x + p) / (n - p) + 1, 2.0) * d + u;
        }
        else {
            y = Math.pow(1.0 - ((x - n) / (1 - n)), 1.0 / 3.0) * u;
        }
        return y;
    }
}

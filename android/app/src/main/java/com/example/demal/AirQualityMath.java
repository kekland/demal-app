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
        if(x >= m && x <= p) {
            y = Math.pow((x - m) / (p - m), 2.0) * d + u;
        }
        else if(x >= p && x <= n) {
            y = Math.pow((-x + p) / (n - p) + 1, 2.0) * d + u;
        }
        else if(x <= m) {
            y = Math.pow(x / m, 1.0 / 3.0) * u;
        }
        else {
            y = Math.pow(1.0 - ((x - n) / (1 - n)), 1.0 / 3.0) * u;
        }
        return y;
    }

    public static double getOverallAirQuality(double gasQuality, double humQuality, int temperature) {
        double quality = 0.0;
        if(gasQuality < 0.5 || humQuality < 0.5) {
            quality = Math.min(gasQuality, humQuality);
        }
        else {
            quality = gasQuality + humQuality;
            quality /= 2.0;
        }
        if(temperature > 40) {
            quality /= 2.0;
        }
        return quality;
    }

    public static String getOverallAirQualityString(double overallQuality) {
        if(overallQuality >= 0.75) {
            return "Healthy";
        }
        else if(overallQuality >= 0.5) {
            return "Fine";
        }
        else if(overallQuality >= 0.2) {
            return "Bad";
        }
        else {
            return "Dangerous";
        }
    }

    public static String getGasesQualityString(double gasQuality) {
        if (gasQuality < 0.25) {
            return "Good";
        } else if (gasQuality < 0.5) {
            return "Mediocre";
        } else {
            return "Bad";
        }
    }
}

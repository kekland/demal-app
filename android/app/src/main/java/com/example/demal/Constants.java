package com.example.demal;

public class Constants {
    public interface ACTION {
        public static String MAIN_ACTION = "com.kekland.demal.action.main";
        public static String PREV_ACTION = "com.kekland.demal.action.prev";
        public static String PLAY_ACTION = "com.kekland.demal.action.play";
        public static String NEXT_ACTION = "com.kekland.demal.action.next";
        public static String STARTFOREGROUND_ACTION = "com.kekland.demal.action.startforeground";
        public static String STOPFOREGROUND_ACTION = "com.kekland.demal.action.stopforeground";
    }

    public interface NOTIFICATION_ID {
        public static int FOREGROUND_SERVICE = 101;
    }
}
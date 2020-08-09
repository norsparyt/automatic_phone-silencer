package com.example.native_test;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Parcelable;
import android.provider.Settings;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL= "com.audio";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Context context = getApplicationContext();
//        final Map<String,Object> args=call.arguments();//data receive
        final List<Map<String,Object>> receivedData=call.arguments();
        int numberOfTasks=receivedData.size();
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !notificationManager.isNotificationPolicyAccessGranted()) {
          Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
          startActivity(intent);
        }//asking for DND permissions
        createNotificationChannel();//called notification method
        if(call.method.equals("getMessage")){
          //This is executed on method Call
        if(numberOfTasks!=0){
         //intent created using broadcast class only once and will be called for multiple pending intents
          Intent intent=new Intent(MainActivity.this,ReminderBroadcast.class);
//          PendingIntent pendingIntentFrom=PendingIntent.getBroadcast(MainActivity.this,0,intent,0);
//          PendingIntent pendingIntentTo=PendingIntent.getBroadcast(MainActivity.this,1,intent,0);
          //initialised alarm service
          AlarmManager alarmManager=(AlarmManager) getSystemService(ALARM_SERVICE);
//          creating alarms and notifications from pending intents
          for(int i=0;i<numberOfTasks;i++){
            intent.putExtra("tasks", (Serializable) receivedData.get(i));
            //putting data for this particular task into intent for use by broadcast class
            PendingIntent pendingIntentStart=PendingIntent.getBroadcast(MainActivity.this,i,intent,0);
            PendingIntent pendingIntentEnd=PendingIntent.getBroadcast(MainActivity.this,(i+1000),intent,0);
//            Long startTime =  Long.parseLong((String) receivedData.get(i).get("startTime"));
//            Long endTime =  Long.parseLong((String) receivedData.get(i).get("endTime"));
            Long startTime= Long.parseLong(receivedData.get(i).get("startTime").toString());
            Long endTime =  Long.parseLong(receivedData.get(i).get("endTime").toString());
            //setting alarms for start and end
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, startTime, pendingIntentStart);
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, endTime, pendingIntentEnd);
            //clearing the data for this task
            intent.putExtra("tasks", (Parcelable[]) null);
          }
          //all tasks set toast
          Toast.makeText(context, "Silencer Set for "+numberOfTasks+" tasks", Toast.LENGTH_SHORT).show();
        }
        else
          Toast.makeText(context, "No Tasks Found!", Toast.LENGTH_SHORT).show();//no tasks present toast
//          result.error("Task List Empty","No tasks found","");
        }
        result.success("The method call finished with (probably) no errors");
      }
    });
  }
  public void createNotificationChannel()
  {
    if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
      CharSequence name="ReminderChannel";
      String description="Channel for Reminder";
      int importance= NotificationManager.IMPORTANCE_DEFAULT;
      NotificationChannel channel=new NotificationChannel("notify",name,importance);
      channel.setDescription(description);
      NotificationManager notificationManager=getSystemService(NotificationManager.class);
      notificationManager.createNotificationChannel(channel);
    }
  }

}

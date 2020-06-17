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
import android.widget.Toast;

import androidx.annotation.NonNull;
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
        final Map<String,Object> args=call.arguments();//data received

        createNotificationChannel();//called notification method
        if(call.method.equals("getMessage")){
          //This is executed on method Call

          Context context = getApplicationContext();
          Toast.makeText(context, "Silencer Set!", Toast.LENGTH_SHORT).show();//made a toast

          Intent intent=new Intent(MainActivity.this,ReminderBroadcast.class);
          PendingIntent pendingIntent=PendingIntent.getBroadcast(MainActivity.this,0,intent,0);

          AlarmManager alarmManager=(AlarmManager) getSystemService(ALARM_SERVICE);
          long timeAtButtonClick=System.currentTimeMillis();
          long time= (long)((int)args.get("from"))*1000;

          alarmManager.set(AlarmManager.RTC_WAKEUP,timeAtButtonClick+time,pendingIntent);

          result.success("Current time is "+timeAtButtonClick);
        }
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

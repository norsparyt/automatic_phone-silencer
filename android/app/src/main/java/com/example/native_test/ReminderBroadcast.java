package com.example.native_test;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Build;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import java.util.Map;

public class ReminderBroadcast extends BroadcastReceiver {
    private AudioManager myAudioManager;
    @Override
    public void onReceive(Context context, Intent intent) {
        Map<String, Object> tasks = (Map<String, Object>) intent.getSerializableExtra("tasks");
        Context c = context;
        String prefs = (String) tasks.get("toggle");
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "notify").setSmallIcon(R.drawable.launch_background).setPriority(NotificationCompat.PRIORITY_DEFAULT);
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);

        myAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int currentMode = myAudioManager.getRingerMode();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if (!myAudioManager.isVolumeFixed()) {
                if (currentMode == 2) {
                    //checking alarm preference
                    if (prefs.charAt(0) == 'F')
                        myAudioManager.setStreamVolume(AudioManager.STREAM_ALARM, 0, 0);
                    //checking vibration preference and silencing
                    if (prefs.charAt(1) == 'T')
                        myAudioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
                    else
                        myAudioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);
                    //checking other-media volume preference
                    if (prefs.charAt(2) == 'F')
                        myAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC, 0, 0);

                    builder.setContentTitle("Device silenced").setContentText("You can focus on your " + tasks.get("title"));
                    notificationManager.notify(200, builder.build());

                    Toast.makeText(c, "Device silenced for: " + tasks.get("title"), Toast.LENGTH_LONG).show();//made a toast
                } else {
                    myAudioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                    myAudioManager.setStreamVolume(AudioManager.STREAM_ALARM, myAudioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM), 0);
                    myAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC, myAudioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0);
                    Toast.makeText(c, tasks.get("title") + " completed:Restored Modes", Toast.LENGTH_LONG).show();//made a toast

                    builder.setContentTitle("Silent mode turned off").setContentText(tasks.get("title")+" completed. Device sounds restored to normal");
                    notificationManager.notify(200, builder.build());

                }
            } else
                Toast.makeText(c, "ERROR: VOLUME FIXED FOR THIS DEVICE", Toast.LENGTH_LONG).show();//made a toast
        } else {
            Toast.makeText(c, "ERROR: NOT SUPPORTED ON DEVICES BELOW LOLLIPOP", Toast.LENGTH_SHORT).show();
        }//made a toast

    }
}

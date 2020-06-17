package com.example.native_test;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class ReminderBroadcast extends BroadcastReceiver {
    private AudioManager myAudioManager;
    @Override
    public void onReceive(Context context, Intent intent) {
        Context c=context;
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "notify").setSmallIcon(R.drawable.launch_background).setContentTitle("Reminder").setContentText("This is a reminder").setPriority(NotificationCompat.PRIORITY_DEFAULT);
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(200, builder.build());

        myAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int currentMode = myAudioManager.getRingerMode();

        if(currentMode == AudioManager.RINGER_MODE_NORMAL){
            myAudioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
            Toast.makeText(c, "SILENCED!", Toast.LENGTH_SHORT).show();//made a toast
        }
        else{
            Toast.makeText(c, "ALREADY SILENT", Toast.LENGTH_SHORT).show();}//made a toast
    }
}

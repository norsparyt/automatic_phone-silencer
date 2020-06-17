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
        System.out.print("REACHED ON RECEIVE");

        Toast.makeText(c, "SILENCED!", Toast.LENGTH_SHORT).show();//made a toast
        myAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        myAudioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
    }
}

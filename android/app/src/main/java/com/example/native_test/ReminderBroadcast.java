package com.example.native_test;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Build;
import android.widget.Toast;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import java.util.List;
import java.util.Map;

public class ReminderBroadcast extends BroadcastReceiver {
    private AudioManager myAudioManager;
    @Override
    public void onReceive(Context context, Intent intent) {
        Map<String,Object> tasks = (Map<String, Object>) intent.getSerializableExtra("tasks");
        Context c = context;

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "notify").setSmallIcon(R.drawable.launch_background).setContentTitle("Reminder").setContentText("This is a reminder").setPriority(NotificationCompat.PRIORITY_DEFAULT);
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(200, builder.build());

        myAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int currentMode = myAudioManager.getRingerMode();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if (!myAudioManager.isVolumeFixed()) {
                if (currentMode!=0) {
                    myAudioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);
//                myAudioManager.setStreamVolume(AudioManager.STREAM_ALARM,0,0);
                    Toast.makeText(c, "Alarms silenced with data:"+tasks.get("title"), Toast.LENGTH_LONG).show();//made a toast
                } else {
                    myAudioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                    Toast.makeText(c, "Restored", Toast.LENGTH_LONG).show();//made a toast
                }
            }    else
                Toast.makeText(c, "ERROR: VOLUME FIXED FOR THIS DEVICE", Toast.LENGTH_LONG).show();//made a toast
        }
        else {
            Toast.makeText(c, "Less Than Lollipop", Toast.LENGTH_SHORT).show();
        }//made a toast

    }
}

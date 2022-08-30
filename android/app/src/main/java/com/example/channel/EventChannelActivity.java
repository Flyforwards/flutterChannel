package com.example.channel;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;

import com.example.channel.utils.EventChannelPlugin;

public class EventChannelActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_event_channel);
        findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String sengMessage = "123456789";
                EventChannelPlugin.send(sengMessage);
                finish();
            }
        });
    }

}
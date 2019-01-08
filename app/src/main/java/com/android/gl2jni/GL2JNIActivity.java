/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.gl2jni;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import java.io.File;


public class GL2JNIActivity extends Activity implements View.OnClickListener {
    GL2JNIView mView;
    String[] names;
    int choice;

    @Override
    public void onClick(View v) {
        if(names == null)
            try {
                names = getAssets().list("shaders");
            } catch (Exception e) {}

        new AlertDialog.Builder(this)
                .setTitle("Shaders")
                .setSingleChoiceItems(names, choice, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        choice = which;

                        mView.queueEvent(new Runnable() {
                            @Override
                            public void run() {
                                GL2JNILib.loadShaderAsset(GL2JNIActivity.this, names[choice]);
                            }
                        });
                    }
                })
                .setNegativeButton("Close", null)
                .create()
                .show();
    }

    @Override
    protected void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        setContentView(R.layout.main);

        FrameLayout ll = findViewById(R.id.root);
        findViewById(R.id.btn).setOnClickListener(this);
        ImageView iv = findViewById(R.id.img);
        try {
            Bitmap bm = BitmapFactory.decodeStream(getAssets().open("test.png"));
            iv.setImageBitmap(bm);
        } catch (Exception e){}

        mView = new GL2JNIView(this);
//	    setContentView(mView);
	    LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);
	    ll.addView(mView, 0, p);
    }

    @Override protected void onPause() {
        super.onPause();
        mView.onPause();
    }

    @Override protected void onResume() {
        super.onResume();
        mView.onResume();
    }
}

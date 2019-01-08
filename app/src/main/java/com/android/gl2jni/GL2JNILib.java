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

// Wrapper for native library

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Xml;

import org.xmlpull.v1.XmlPullParser;

public class GL2JNILib {

     static {
         System.loadLibrary("gl2jni");
     }

     public static native void init(Bitmap bmp);
     public static native void resize(int width, int height);
     public static native void step();
     public static native void loadShader(String vs, String fs);

     public static void readAssets(Context c, String assetPath, String[] ss) {
          try {
               XmlPullParser xp = Xml.newPullParser();
               xp.setInput(c.getAssets().open(assetPath), "UTF-8");

               String vertex = null;
               String fragment = null;
               boolean done = false;

               int e = xp.getEventType();
               while (e != XmlPullParser.END_DOCUMENT && !done) {
                    String name = null;

                    switch (e) {
                         case XmlPullParser.START_TAG: {
                              name = xp.getName();
                              if(name.equalsIgnoreCase("vertex")) {
                                   vertex = xp.nextText();
                              } else if(name.equalsIgnoreCase("fragment")) {
                                   fragment = xp.nextText();
                              }

                              break;
                         }

                         case XmlPullParser.END_TAG: {
                              name = xp.getName();
                              if(name.equalsIgnoreCase("shader"))
                                   done = true;
                              break;
                         }
                    }

                    e = xp.next();
               }

               ss[0] = vertex;
               ss[1] = fragment;
          } catch (Exception e){e.printStackTrace();}
     }


     public static void loadShaderAsset(Context c, String name) {
          String[] vf = new String[2];
          readAssets(c, "shaders/" + name, vf);
          loadShader(vf[0], vf[1]);
     }
}

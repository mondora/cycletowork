package com.monodra.cycletowork

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.util.Log;
import com.google.android.gms.maps.MapsInitializer
import com.google.android.gms.maps.MapsInitializer.Renderer
import com.google.android.gms.maps.OnMapsSdkInitializedCallback

// TODO: remove this line after fixed https://github.com/flutter/flutter/issues/105965#issuecomment-1224473127
class MainActivity: FlutterActivity(), OnMapsSdkInitializedCallback{
    override 
    fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState);
        MapsInitializer.initialize(applicationContext, Renderer.LATEST, this)
    }

    override fun onMapsSdkInitialized(renderer: MapsInitializer.Renderer) {
      when (renderer) {
        Renderer.LATEST -> Log.d("NewRendererLog", "The latest version of the renderer is used.")
        Renderer.LEGACY -> Log.d("NewRendererLog","The legacy version of the renderer is used.")
      }
    }
}

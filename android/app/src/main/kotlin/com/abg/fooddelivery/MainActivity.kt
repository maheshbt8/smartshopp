package com.shopping.smartshop

//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.plugins.GeneratedPluginRegistrant
//import androidx.annotation.NonNull;
//import io.flutter.embedding.engine.FlutterEngine
//import android.os.Bundle
//
//
//class MainActivity: FlutterActivity() {
//
//}
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
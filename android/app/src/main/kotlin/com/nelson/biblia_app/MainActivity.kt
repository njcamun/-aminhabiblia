package com.nelson.biblia_app

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Ativa o modo de exibição de ponta a ponta para compatibilidade com Android 15+
        // Isso resolve o aviso de APIs descontinuadas como setStatusBarColor
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }
}

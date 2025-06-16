package com.example.apple

import android.Manifest.permission.ACCESS_FINE_LOCATION
import android.Manifest.permission.ACTIVITY_RECOGNITION
import android.content.Intent
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts.RequestMultiplePermissions
import androidx.core.content.ContextCompat
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.request.GoalsReadRequest
import com.google.android.gms.fitness.request.DataReadRequest
import java.util.Calendar
import java.util.concurrent.TimeUnit
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"
    private val CHANNEL = "com.example.longlife/googlefit"


    private var account :GoogleSignInAccount? = null
    private val receivedData = mutableMapOf<String, String>()
    private var countComplete = 0
    private val callback = PendingCallback()
    private val systemPermissions = arrayOf(ACTIVITY_RECOGNITION)


    override fun configureFlutterEngine(@NonNull flutterEngine :FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "fetch"){
                callback.set { result.success(receivedData) }
                fetchData()
            } else {
                result.notImplemented()
            }
        }
    }

    //region check
    private fun check(){
        account = GoogleSignIn.getAccountForExtension(this, fitnessOptions)
        if(!hasPermissions(systemPermissions)) {
            requestSystemPermissions()
            return
        }
        if(!hasGooglePermission()){
            requestGooglePermission()
            return
        }
        callback()
    }

    private fun hasPermissions(permissions :Array<String>) :Boolean =
        permissions.all {
            ContextCompat.checkSelfPermission(this, it) == PERMISSION_GRANTED
        }

    private val PERMISSIONS_CODE = 1
    private fun requestSystemPermissions(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(systemPermissions, PERMISSIONS_CODE)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if(requestCode == PERMISSIONS_CODE){
            if (!grantResults.all { it == PERMISSION_GRANTED }) return
            requestGooglePermission()
        }
    }

    private fun hasGooglePermission() :Boolean =
        GoogleSignIn.hasPermissions(account, fitnessOptions)

    private val GOOGLE_CODE = 0
    private fun requestGooglePermission(){
        GoogleSignIn.requestPermissions(
            this,
            GOOGLE_CODE,
            account,
            fitnessOptions
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode){
            GOOGLE_CODE -> {
                if(resultCode == RESULT_OK) callback()
            }
        }
    }


    private val fitnessOptions: FitnessOptions by lazy {
        FitnessOptions.builder()
            .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ)
            .build()
    }

    private val goalsReadRequest: GoalsReadRequest by lazy {
        GoalsReadRequest.Builder()
            .addDataType(DataType.TYPE_STEP_COUNT_DELTA)
            .build()
    }


    private fun fetchData(){
        fetchLastData {
            receivedData.putAll(it)
            showParams(receivedData)
        }
    }

    private fun showParams(params :Map<String, String>){
        countComplete++
        if(countComplete < 2) return
        callback()
        countComplete = 0
    }

    private fun fetchLastData(callback: (Map<String, String>)->Unit){
        Fitness.getGoalsClient(this, GoogleSignIn.getAccountForExtension(this, fitnessOptions))
            .readCurrentGoals(goalsReadRequest)
            .addOnSuccessListener { goals ->
                goals.firstOrNull()?.apply {
                    val rMap :HashMap<String, String> = hashMapOf()
                    val goalValue = metricObjective.value
                    rMap["Goal"] = goalValue.toString()
                    Log.i(TAG, "Goal value: $rMap")
                    callback(rMap)
                }

            }
            .addOnFailureListener { e ->
                Log.w("TAG","There was an error reading data from Google Fit", e)
            }
    }

}


class PendingCallback {
    private var callback :(() -> Unit)? = null

    fun set(callback :()->Unit){
        this.callback = callback
    }

    operator fun invoke(){
        callback?.invoke()
        callback = null
    }
}
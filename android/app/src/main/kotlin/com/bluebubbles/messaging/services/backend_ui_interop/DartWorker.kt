package com.bluebubbles.messaging.services.backend_ui_interop

import android.content.Context
import android.util.Log
import androidx.concurrent.futures.CallbackToFutureAdapter
import androidx.work.ListenableWorker
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.bluebubbles.messaging.Constants
import com.bluebubbles.messaging.MainActivity.Companion.engine
import com.google.common.util.concurrent.ListenableFuture
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.ApplicationInfoLoader
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import kotlinx.coroutines.runBlocking

class DartWorker(context: Context, workerParams: WorkerParameters): ListenableWorker(context, workerParams) {

    companion object {
        var workerEngine: FlutterEngine? = null
    }

    override fun startWork(): ListenableFuture<Result> {
        val method = inputData.getString("method")!!
       if (engine == null && workerEngine == null) {
           Log.d(Constants.logTag, "Initializing engine for worker with method $method")
           initNewEngine()
       }

        if (engine != null) {
            Log.d(Constants.logTag, "Using MainActivity engine to send to Dart")
        } else {
            Log.d(Constants.logTag, "Using DartWorker engine to send to Dart")
        }
        return CallbackToFutureAdapter.getFuture { completer ->
            runBlocking {
                Log.d(Constants.logTag, "Sending method $method to Dart")
                MethodChannel((engine ?: workerEngine)!!.dartExecutor.binaryMessenger, Constants.methodChannel).invokeMethod(method, inputData.keyValueMap, object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        Log.d(Constants.logTag, "Worker with method $method completed successfully")
                        completer.set(Result.success())
                        closeEngineIfNeeded()
                    }

                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        Log.e(Constants.logTag, "Worker with method $method failed!")
                        completer.set(Result.failure())
                        closeEngineIfNeeded()
                    }

                    override fun notImplemented() { }
                })
            }
        }
    }

    /// Code idea taken from https://github.com/flutter/flutter/wiki/Experimental:-Reuse-FlutterEngine-across-screens
    private fun initNewEngine() {
        Log.d(Constants.logTag, "Ensuring Flutter is initialized before creating engine")
        FlutterLoader().startInitialization(applicationContext)
        FlutterLoader().ensureInitializationComplete(applicationContext.applicationContext, null)

        Log.d(Constants.logTag, "Loading callback info")
        val info = ApplicationInfoLoader.load(applicationContext.applicationContext)
        workerEngine = FlutterEngine(applicationContext)
        val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(applicationContext.getSharedPreferences("FlutterSharedPreferences", 0).getLong("flutter.backgroundCallbackHandle", -1))
        val callback = DartExecutor.DartCallback(applicationContext.assets, info.flutterAssetsDir, callbackInfo)

        Log.d(Constants.logTag, "Executing Dart callback")
        workerEngine!!.dartExecutor.executeDartCallback(callback)
    }

    private fun closeEngineIfNeeded() {
        val currentWork = WorkManager.getInstance(applicationContext).getWorkInfosByTag(Constants.dartWorkerTag).get().filter { element -> !element.state.isFinished }
        Log.d(Constants.logTag, "${currentWork.size} worker(s) still queued")
        if (currentWork.size <= 1 && workerEngine != null) {
            Log.d(Constants.logTag, "Closing ${Constants.dartWorkerTag} engine")
            workerEngine?.destroy()
            workerEngine = null
        }
    }
}
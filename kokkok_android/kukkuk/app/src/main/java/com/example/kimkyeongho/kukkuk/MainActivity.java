package com.example.kimkyeongho.kukkuk;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.provider.Settings;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AlertDialog;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.CookieSyncManager;
import android.webkit.GeolocationPermissions;
import android.webkit.JavascriptInterface;
import android.webkit.JsResult;
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebChromeClient;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.LogoutResponseCallback;

import java.io.IOException;
import java.io.InputStream;
import java.net.CookieManager;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.spec.ECField;
import java.util.List;

public class MainActivity extends BaseActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private WebView mainWebview;
    //private WebViewInterface mainWebViewInterface;
    //
    private ValueCallback<Uri> filePathCallbackNormal;
    private ValueCallback<Uri[]> filePathCallbackLollipop;
    private final static int FILECHOOSER_NORMAL_REQ_CODE = 1;
    private final static int FILECHOOSER_LOLLIPOP_REQ_CODE = 2;
    //

    private ImageButton login_btn;
    private ImageButton home_btn, scrap_btn, mypage_btn, area_btn, course_btn, review_btn, around_btn;

    public static String userInfo = null;
    public String pID = null, imgUrl = null, nickname = null;
    Bitmap profileBitmap;
    private View navigationHeader;
    private CircularImageView profileImage;
    public TextView member_nickname;

    String key;

    DrawerLayout drawer;

    private boolean loginFlag = false;

    public static MainActivity mainActivity;

    ProgressDialog webviewProgress=null;
    ProgressDialog progDailog = null;

    boolean procFlag=false;

    Intent splashIntent;

    boolean webFlag=true, backFlag=true;

    String beforeUrl=null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mainActivity=this;
        splashIntent=new Intent(this, SplashActivity.class);
        startActivity(splashIntent);

        setContentView(R.layout.activity_main);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        getSupportActionBar().setElevation(0);

        drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close) {

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);

                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);

                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }
        };
        drawer.setDrawerListener(toggle);
        toggle.syncState();


        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        ///nav 헤더 부분
        navigationHeader = navigationView.inflateHeaderView(R.layout.nav_header_main);
        profileImage = (CircularImageView) navigationHeader.findViewById(R.id.profileImage);
        member_nickname = (TextView) navigationHeader.findViewById(R.id.member_nickname);
        login_btn = (ImageButton) navigationHeader.findViewById(R.id.icon_login);
        home_btn = (ImageButton) navigationHeader.findViewById(R.id.home_btn);
        scrap_btn = (ImageButton) navigationHeader.findViewById(R.id.scrap_btn);
        mypage_btn = (ImageButton) navigationHeader.findViewById(R.id.mypage_btn);
        area_btn = (ImageButton) navigationHeader.findViewById(R.id.area_btn);
        course_btn = (ImageButton) navigationHeader.findViewById(R.id.course_btn);
        review_btn = (ImageButton) navigationHeader.findViewById(R.id.review_btn);
        around_btn = (ImageButton) navigationHeader.findViewById(R.id.around_btn);

        // device 크기에 따른 navigation Drawer 높이 지정
        DisplayMetrics displayMetrics = new DisplayMetrics();
        final WindowManager windowmanager = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
        windowmanager.getDefaultDisplay().getMetrics(displayMetrics);
        int deviceWidth = displayMetrics.widthPixels;
        int deviceHeight = displayMetrics.heightPixels;

        navigationHeader.getLayoutParams().height = deviceHeight;
        // 여기까지...

        login_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String tmpUrl = mainWebview.getUrl();

                if (tmpUrl.contains("MapBig.jsp")) {
                    Toast.makeText(getApplicationContext(), "현재 페이지에서는 로그인이 불가능합니다", Toast.LENGTH_SHORT).show();
                    return;
                }

                if (loginFlag) {
                    if (tmpUrl.contains("ReviewMake") || tmpUrl.contains("CourseMain")) {
                        Toast.makeText(getApplicationContext(), "현재 페이지에서 로그아웃은 불가능합니다", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    AlertDialog.Builder alert = new AlertDialog.Builder(MainActivity.this);
                    alert.setPositiveButton("확인", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            loginFlag = false;
                            onClickLogout(mainWebview.getUrl());
                            dialog.dismiss();     //닫기
                        }
                    });
                    alert.setNegativeButton("취소", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();     //닫기
                        }
                    });
                    alert.setMessage("로그아웃 하시겠습니까?");
                    alert.show();
                } else {
                    Intent intent = new Intent(getApplicationContext(), LoginActivity.class);
                    startActivity(intent);
                }

            }
        });

        home_btn.setOnClickListener(new NaviOnClickListenr("Main.jsp"));
        scrap_btn.setOnClickListener(new NaviOnClickListenr("MyScrap.jsp"));
        mypage_btn.setOnClickListener(new NaviOnClickListenr("MyPage.jsp"));
        area_btn.setOnClickListener(new NaviOnClickListenr("SiteList.jsp"));
        course_btn.setOnClickListener(new NaviOnClickListenr("CourseMain.jsp"));
        review_btn.setOnClickListener(new NaviOnClickListenr("ReviewMain.jsp"));
        around_btn.setOnClickListener(new NaviOnClickListenr("Around.jsp"));


        mainWebview = (WebView) findViewById(R.id.mainWebview);


        // Acquire a reference to the system Location Manager
        LocationManager locationManager = (LocationManager) this.getSystemService(Context.LOCATION_SERVICE);


        // 웹뷰에서 자바스크립트실행가능
        mainWebview.getSettings().setJavaScriptEnabled(true);
        mainWebview.getSettings().setAllowFileAccessFromFileURLs(true);
        mainWebview.getSettings().setAllowUniversalAccessFromFileURLs(true);

        mainWebview.getSettings().setAllowContentAccess(true);
        mainWebview.getSettings().setAllowFileAccess(true);

        //
        mainWebview.getSettings().setDefaultTextEncodingName("utf-8");
        //
        mainWebview.getSettings().setUseWideViewPort(true);
        mainWebview.getSettings().setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN);
        mainWebview.getSettings().setLoadWithOverviewMode(true);
        //
        mainWebview.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);

        //위치
        mainWebview.getSettings().setGeolocationEnabled(true);
        mainWebview.getSettings().setGeolocationDatabasePath(getFilesDir().getPath());

        //html5 api flag=true
        mainWebview.getSettings().setDatabaseEnabled(true);
        mainWebview.getSettings().setDomStorageEnabled(true);
        mainWebview.getSettings().setAppCacheEnabled(true);
        mainWebview.addJavascriptInterface(new WebViewInterface1(), "Android");

        mainWebview.setWebChromeClient(new WebChromeClient() {
            // For Android 4.1+
            public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture) {
                Log.d("MainActivity", "4.1+");
                openFileChooser(uploadMsg, acceptType, "");
            }

            // For Android 5.0+
            public boolean onShowFileChooser(
                    WebView webView, ValueCallback<Uri[]> filePathCallback,
                    WebChromeClient.FileChooserParams fileChooserParams) {
                Log.d("MainActivity", "5.0+");
                if (filePathCallbackLollipop != null) {
                    filePathCallbackLollipop.onReceiveValue(null);
                    filePathCallbackLollipop = null;
                }
                filePathCallbackLollipop = filePathCallback;
                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
                i.addCategory(Intent.CATEGORY_OPENABLE);
                i.setType("image/*");
                startActivityForResult(Intent.createChooser(i, "File Chooser"), FILECHOOSER_LOLLIPOP_REQ_CODE);

                return true;
            }


            //위치 정보
            private static final String TAG = "MyActivity";

            @Override
            public void onGeolocationPermissionsShowPrompt(final String origin, final GeolocationPermissions.Callback callback) {
                Log.i(TAG, "onGeolocationPermissionsShowPrompt()");
                callback.invoke(origin, true, false);
            }


            @Override
            public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
                // This shows the dialog box.  This can be commented out for dev
                AlertDialog.Builder alertBldr = new AlertDialog.Builder(MainActivity.this);
                alertBldr.setTitle(message);
                alertBldr.setPositiveButton("확인", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });

                alertBldr.show();
                result.confirm();

                return true;
            }

            /**
             * 페이지를 로딩하는 현재 진행 상황을 전해줍니다.
             * newProgress  현재 페이지 로딩 진행 상황, 0과 100 사이의 정수로 표현.(0% ~ 100%)
             */
            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                Log.i("WebView", "Progress: " + String.valueOf(newProgress));

                if(webviewProgress!=null && newProgress>=90) {
                    webviewProgress.dismiss();
                    webviewProgress = null;
                    Log.d("3333333333","111111111");
                }

                super.onProgressChanged(view, newProgress);
            }

        });

        mainWebview.setWebViewClient(new WebViewClient() {

            @Override
            public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon){
                //Log.d("before",mainWebview.getUrl());
                beforeUrl=mainWebview.getUrl();

                super.onPageStarted(view,url,favicon);
                if(url.contains("Proc")) {
                    if(url.equals(macaddr+"LogoutProc.jsp"))
                        return;
                    else{
                        procFlag=true;
                        return;
                    }
                }

                procFlag=false;

                webviewProgress=new ProgressDialog(MainActivity.this);
                webviewProgress.setMessage("Loading...");
                webviewProgress.setIndeterminate(true);
                webviewProgress.setCancelable(true);
                webviewProgress.setCanceledOnTouchOutside(false);

                webFlag=false;
                if(mainActivity.isFinishing()==false) {
                    Log.d("loding","show");
                    webviewProgress.show();
                }

            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view,url);
                if(webviewProgress!=null) {
                    Log.d("loding","disshow");
                    webviewProgress.dismiss();
                    webviewProgress = null;
                }

                if(url.equals(macaddr+"Main.jsp")){
                    Log.d("히스토리","delete");
                    mainWebview.clearHistory();
                }

            }
        });


        

        // 홈페이지 지정
        //Toast.makeText(getApplicationContext(),macaddr,Toast.LENGTH_SHORT).show();
        //mainWebview.loadUrl(macaddr+"SiteList.jsp");

        //로그인 세션이 남아있으면 모두 삭제(강제종료시 이벤트 잡기 어려움)
        onClickLogout("Main.jsp");
        //mainWebview.loadUrl(macaddr + "Main.jsp");

    }

    public void showDailog(){
        if(!SplashActivity.finishFlag) {
            Log.d("......","1111111111");
            //webviewProgress.dismiss();
            AlertDialog.Builder alert = new AlertDialog.Builder(MainActivity.this);
            alert.setPositiveButton("확인", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();     //닫기
                    finish();
                }
            });
            alert.setMessage("앱 정보에서 GPS 권한을 허용해주세요");
            alert.show();

            webFlag=false;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();


        //Toast.makeText(getApplicationContext(),userInfo,Toast.LENGTH_SHORT).show();
        //drawer.closeDrawers();


        if (userInfo == null) {
            member_nickname.setText("로그인 해주세요");
            Drawable drawable = getResources().getDrawable(R.drawable.user_icon);
            profileImage.setImageDrawable(drawable);
        } else {
            if (pID == null) {
                //사용자 구별키 _ 이미지 url
                pID = userInfo.split("_")[0];
                imgUrl = userInfo.split("_")[1];
                nickname = userInfo.split("_")[2];
                Log.d("image ", imgUrl);


                if(imgUrl.contains("kakao"))
                    setProfile();

                member_nickname.setText(nickname);
                loginFlag = true;
                mainWebview.reload();
            }
        }
    }

    @Override
    public void onBackPressed() {

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            if (mainWebview.canGoBack()) {
                if(procFlag){
                    mainWebview.loadUrl(beforeUrl);
                }else{
                    mainWebview.goBack();
                }
            }else {
                finish();
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }


    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    //로그 아웃 이벤트 정확히 구현 필요!!
    private void onClickLogout(String url) {

        //이거 때문인데..
        UserManagement.requestLogout(new LogoutResponseCallback() {
            @Override
            public void onCompleteLogout() {
                //redirectLoginActivity();
            }
        });

        userInfo = null;
        pID = null;

        member_nickname.setText("로그인 해주세요");
        Drawable drawable = getResources().getDrawable(R.drawable.user_icon);
        profileImage.setImageDrawable(drawable);


        //mainWebview.clearHistory();
        //mainWebview.clearCache(true);
        //mainWebview.clearView();

        mainWebview.loadUrl(macaddr + "LogoutProc.jsp?url=" + url);
    }

    @Override
    protected void onDestroy() {
        onClickLogout(mainWebview.getUrl());
        super.onDestroy();
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == FILECHOOSER_NORMAL_REQ_CODE) {
            if (filePathCallbackNormal == null) return;
            Uri result = (data == null || resultCode != RESULT_OK) ? null : data.getData();
            filePathCallbackNormal.onReceiveValue(result);
            filePathCallbackNormal = null;
        } else if (requestCode == FILECHOOSER_LOLLIPOP_REQ_CODE) {
            if (filePathCallbackLollipop == null) return;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                filePathCallbackLollipop.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, data));
            }

            filePathCallbackLollipop = null;
        }
    }

    public void setProfile() {
        Thread mThread = new Thread() {
            public void run() {
                try {
                    URL url = new URL(imgUrl);

                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setDoInput(true);
                    conn.connect();

                    InputStream is = conn.getInputStream();
                    profileBitmap = BitmapFactory.decodeStream(is);
                } catch (Exception e) {

                }
            }
        };
        mThread.start();

        try {
            mThread.join();
            profileImage.setImageBitmap(profileBitmap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//    private void CheckEnableGPS() {
//        String provider = Settings.Secure.getString(getContentResolver(), Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
//        if (!provider.equals("")) {
//            //GPS Enabled
//            Toast.makeText(MainActivity.this, "GPS Enabled: " + provider, Toast.LENGTH_LONG).show();
//        } else {
//            Toast.makeText(MainActivity.this, "GPS Disabled: " + provider, Toast.LENGTH_LONG).show();
//
//            Intent intent = new Intent(Settings.ACTION_SECURITY_SETTINGS);
//            startActivity(intent);
//        }
//    }


    class NaviOnClickListenr implements View.OnClickListener {

        String page;

        NaviOnClickListenr(String page) {
            this.page = page;
        }

        @Override
        public void onClick(View view) {
            if (member_nickname.getText().equals("로그인 해주세요")) {
                if (page.equals("MyScrap.jsp") || page.equals("MyPage.jsp")) {
                    Toast.makeText(getApplicationContext(), "로그인 이후에 이용가능 합니다", Toast.LENGTH_SHORT).show();
                    return;
                }
            }

            if(page.equals("SiteList.jsp")){
                page+="?page=1";
            }else if(page.equals("CourseMain.jsp")){
                page+="?page1=1&page2=1";
            }else if(page.equals("Around.jsp")){
                page+="?kind=default";
            }

            mainWebview.loadUrl(macaddr + page);
            drawer.closeDrawers();
        }
    }


    FetchCordinates fetchCordinates;
    class WebViewInterface1 {

        public WebViewInterface1() {
        }

        @JavascriptInterface
        public void requestGPS() {
            fetchCordinates=new FetchCordinates();
            fetchCordinates.execute();
        }
    }

    public class FetchCordinates extends AsyncTask<String, Integer, String> {


        public double lati = 0.0;
        public double longi = 0.0;

        public boolean flag=true;

        public LocationManager mLocationManager;
        public VeggsterLocationListener mVeggsterLocationListener;


        @Override
        protected void onPreExecute() {
            mVeggsterLocationListener = new VeggsterLocationListener();
            mLocationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return;
            }
            mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000, 10, mVeggsterLocationListener);

            progDailog = new ProgressDialog(MainActivity.this);
            progDailog.setMessage("위치 잡는중...");
            progDailog.setIndeterminate(true);
            progDailog.setCancelable(true);
            progDailog.setCanceledOnTouchOutside(false);
            progDailog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                @Override
                public void onCancel(DialogInterface dialogInterface) {
                    //progDailog.dismiss();

                    flag=false;

                    //onBackPressed();
                }
            });
            webFlag=false;
            progDailog.show();
            flag=true;
        }

        @Override
        protected void onCancelled() {
            System.out.println("Cancelled by user!");
            progDailog.dismiss();
            if (ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return;
            }
            mLocationManager.removeUpdates(mVeggsterLocationListener);

        }

        @Override
        protected void onPostExecute(String result) {
            progDailog.dismiss();
            progDailog=null;
            if(!flag) {
                onBackPressed();
                return;
            }

            //Toast.makeText(MainActivity.this, "LATITUDE :" + lati + " LONGITUDE :" + longi, Toast.LENGTH_LONG).show();
            if(longi==0.0){
                Toast.makeText(MainActivity.this, "GPS 상태를 다시 확인해주세요", Toast.LENGTH_LONG).show();
                //mainWebview.loadUrl(macaddr+"Main.jsp");
                mainWebview.loadUrl("javascript:removeAJAXQue()");
                return;
            }

            String loc=lati+"&"+longi;
            Log.d("1111232232",loc);
            mainWebview.loadUrl("javascript:androidCall("+lati+","+longi+")");

        }

        @Override
        protected String doInBackground(String... params) {
            // TODO Auto-generated method stub
            int cnt=0;
            while (flag && this.lati == 0.0) {
                try {
                    Thread.sleep(1000);
                    cnt++;
                    if(cnt>5){
                        break;
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
            return null;
        }

        public class VeggsterLocationListener implements LocationListener {

            @Override
            public void onLocationChanged(Location location) {

                int lat = (int) location.getLatitude(); // * 1E6);
                int log = (int) location.getLongitude(); // * 1E6);
                int acc = (int) (location.getAccuracy());

                String info = location.getProvider();
                try {

                    // LocatorService.myLatitude=location.getLatitude();

                    // LocatorService.myLongitude=location.getLongitude();

                    lati = location.getLatitude();
                    longi = location.getLongitude();

                } catch (Exception e) {
                    // progDailog.dismiss();
                    // Toast.makeText(getApplicationContext(),"Unable to get Location"
                    // , Toast.LENGTH_LONG).show();
                }

            }

            @Override
            public void onProviderDisabled(String provider) {
                Log.i("OnProviderDisabled", "OnProviderDisabled");
            }

            @Override
            public void onProviderEnabled(String provider) {
                Log.i("onProviderEnabled", "onProviderEnabled");
            }

            @Override
            public void onStatusChanged(String provider, int status,
                                        Bundle extras) {
                Log.i("onStatusChanged", "onStatusChanged");

            }

        }

    }

    //
}

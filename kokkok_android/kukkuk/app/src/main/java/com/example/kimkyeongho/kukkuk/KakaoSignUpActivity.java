package com.example.kimkyeongho.kukkuk;

import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.kakao.auth.ErrorCode;
import com.kakao.network.ErrorResult;
import com.kakao.usermgmt.UserManagement;
import com.kakao.usermgmt.callback.MeResponseCallback;
import com.kakao.usermgmt.response.model.UserProfile;
import com.kakao.util.helper.log.Logger;

public class KakaoSignUpActivity extends BaseActivity {

    WebView webView;
    WebViewInterface1 mainWebViewInterface;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_kakao_sign_up);
        //Toast.makeText(getApplicationContext(), "88888888888888", Toast.LENGTH_SHORT).show();


        webView=(WebView)findViewById(R.id.sub_webview);
        webView.setWebViewClient(new WebViewClient(){});
        webView.setWebChromeClient(new WebChromeClient(){});

        mainWebViewInterface=new WebViewInterface1();

        webView.getSettings().setJavaScriptEnabled(true);
        webView.addJavascriptInterface(mainWebViewInterface,"Android");

        requestMe();
    }

    /**
     * 사용자의 상태를 알아 보기 위해 me API 호출을 한다.
     */
    protected void requestMe() { //유저의 정보를 받아오는 함수
        UserManagement.requestMe(new MeResponseCallback() {
            @Override
            public void onFailure(ErrorResult errorResult) {
                String message = "failed to get user info. msg=" + errorResult;
                Logger.d(message);

                ErrorCode result = ErrorCode.valueOf(errorResult.getErrorCode());
                if (result == ErrorCode.CLIENT_ERROR_CODE) {
                    Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
                    finish();
                } else {
                    redirectLoginActivity();
                }
            }

            @Override
            public void onSessionClosed(ErrorResult errorResult) {
                Log.d("3333333333",errorResult.toString());
                redirectLoginActivity();
            }

            @Override
            public void onNotSignedUp() {
                Log.d("3333333333","000000000000");
                Toast.makeText(getApplicationContext(),"카카오 회원이 아닙니다",Toast.LENGTH_SHORT).show();
                redirectLoginActivity();
            } // 카카오톡 회원이 아닐 시 showSignup(); 호출해야함

            @Override
            public void onSuccess(UserProfile userProfile) {  //성공 시 userProfile 형태로 반환
                String kakaoID = String.valueOf(userProfile.getId()); // userProfile에서 ID값을 가져옴
                //String kakaoNickname = userProfile.getNickname();     // Nickname 값을 가져옴
                String kakaoProfile=userProfile.getProfileImagePath();// 프로필 이미지 url
                //Logger.d("UserProfile : " + userProfile);
                Log.d("profile",kakaoProfile);

                //
                //MainActivity.userInfo=kakaoID+"_"+kakaoProfile;//전역 변수로 사용 중


                webView.loadUrl(macaddr+"LoginProc.jsp?pID="+kakaoID+"&profile="+kakaoProfile);


                //redirectMainActivity(); // 로그인 성공시 MainActivity로
            }
        });
    }

    private void redirectMainActivity() {
        //startActivity(new Intent(this, MainActivity.class));
        finish();
    }

    class WebViewInterface1 {

        public WebViewInterface1() {
        }

        @JavascriptInterface
        public void setUserInfo(String userInfo){
            Log.d("userinfo",userInfo);
            MainActivity.userInfo=userInfo;

            redirectMainActivity();
        }

    }
}

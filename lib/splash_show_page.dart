import 'package:amps_sdk/amps_sdk_export.dart';
import 'package:amps_sdk_demo/widgets/blurred_background.dart';
import 'package:amps_sdk_demo/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashShowPage extends StatefulWidget {
  const SplashShowPage({super.key, required this.title});

  final String title;

  @override
  State<SplashShowPage> createState() => _SplashShowPageState();
}

class _SplashShowPageState extends State<SplashShowPage> {
  AMPSSplashAd? _splashAd;
  late AdCallBack _adCallBack;
  num eCpm = 0;
  bool initSuccess = false;
  bool couldBack = true;
  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _adCallBack = AdCallBack(onRenderOk: () {
      _splashAd?.showAd();
      debugPrint("ad load onRenderOk");
    }, onLoadFailure: (code, msg) {
      debugPrint("ad load failure=$code;$msg");
    }, onAdClicked: () {
      setState(() {
        couldBack = true;
      });
      debugPrint("ad load onAdClicked");
    }, onAdExposure: () {
      setState(() {
        couldBack = false;
      });
      debugPrint("ad load onAdExposure");
    }, onAdClosed: () {
      setState(() {
        couldBack = true;
      });
      debugPrint("ad load onAdClosed");
    }, onAdReward: () {
      debugPrint("ad load onAdReward");
    }, onAdShow: () {
      debugPrint("ad load onAdShow");
    }, onAdShowError: (code, msg) {
      debugPrint("ad load onAdShowError");
    }, onRenderFailure: () {
      debugPrint("ad load onRenderFailure");
    }, onVideoPlayStart: () {
      debugPrint("ad load onVideoPlayStart");
    }, onVideoPlayError: (code, msg) {
      debugPrint("ad load onVideoPlayError");
    }, onVideoPlayEnd: () {
      debugPrint("ad load onVideoPlayEnd");
    }, onVideoSkipToEnd: (duration) {
      debugPrint("ad load onVideoSkipToEnd=$duration");
    });

    AdOptions options =
        AdOptions(spaceId: '15288',
            expressSize: [392.72, 850.90],
            splashAdBottomBuilderHeight: 0);
    _splashAd = AMPSSplashAd(config: options, mCallBack: _adCallBack);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: couldBack,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const BlurredBackground(),
                Column(
                  children: [
                    const SizedBox(height: 100, width: 0),
                    ButtonWidget(
                        buttonText: '点击加载开屏页面',
                        callBack: () {
                          // 使用命名路由跳转
                          _splashAd?.load();
                        }),
                    ButtonWidget(
                        buttonText: '获取竞价=$eCpm',
                        callBack: () async {
                          bool? isReadyAd = await _splashAd?.isReadyAd();
                          debugPrint("isReadyAd=$isReadyAd");
                          if(_splashAd != null){
                            num ecPmResult =  await _splashAd!.getECPM();
                            debugPrint("ecPm请求结果=$eCpm");
                            setState(() {
                              eCpm = ecPmResult;
                            });
                          }
                        }),
                    ButtonWidget(
                        buttonText: '上报竞胜',
                        callBack: () async {
                          _splashAd?.notifyRTBWin(11, 3);
                        }),
                    ButtonWidget(
                        buttonText: '上报竞价失败',
                        callBack: () async {
                          _splashAd?.notifyRTBLoss(11, 3,"给的价格太低");
                        }),
                  ],
                )
              ],
            )));
  }
}

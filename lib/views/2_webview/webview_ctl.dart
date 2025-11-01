import 'dart:convert';

import 'dart:io';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../Models/ActsModels/myduty.dart';

import '../../Models/VolsModels/vol.dart';

import '../../Models/VolsModels/vol_traite.dart';
import '../../Models/VolsModels/vol_traite_mois.dart';
import '../../Models/jsonModels/mystripjson/mystrip_model.dart';
import '../../Models/userModel/my_download.dart';
import '../../controllers/database_controller.dart';
import '../../helpers/fct.dart';
import '../../services/strip_processor.dart';
import '../../helpers/constants.dart';

import '../../helpers/myerrorinfo.dart';

import '../../services/encryption_service.dart';
import '../../services/secure_storage_service.dart';

class WebViewEcreenController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    getConnexion = await Fct.checkConnectivity();
    // print(getConnexion);
    if (getConnexion) {
      sEtape = 'status_downloading'.tr;
      await _initializeWebView();
    } else {
      sEtape = 'no_connection'.tr;
    }
    // await _getCredentiel();
  }

  static WebViewEcreenController instance = Get.find();
  final _secureStorage = SecureStorageService();
  final _encryptionHelper = EncryptionHelper();

  // Webview controller from the package
  late final WebViewController _webViewController;
  // Getters and setters for better encapsulation
  final _isJson = true.obs;
  final _ijson = 0.obs;
  bool get isJson => _isJson.value;

  final _sEtape = ''.obs;
  String get sEtape => _sEtape.value;
  set sEtape(String index) => _sEtape.value = index;

  int get ijson => _ijson.value;
  set ijson(int value) => _ijson.value = value;

  final _visibleWeb = true.obs;
  bool get visibleWeb => _visibleWeb.value;
  set visibleWeb(bool val) => _visibleWeb.value = val;

  final _visibleenregistre = false.obs;
  bool get visibleenregistre => _visibleenregistre.value;
  set visibleenregistre(bool val) => _visibleenregistre.value = val;

  final _jsonString = Rxn<String>();
  String? get jsonString => _jsonString.value;
  set jsonString(String? value) => _jsonString.value = value;
  // Loading state
  final _getConnexion = false.obs;
  bool get getConnexion => _getConnexion.value;
  set getConnexion(bool val) => _getConnexion.value = val;

  final RxString currentUrl = ''.obs;
  final RxString pageTitle = ''.obs;
  final RxString rxUser = ''.obs;
  final RxString rxPass = ''.obs;

  final StripProcessor _stripProcessor = StripProcessor();
  PlatformWebViewControllerCreationParams? _params;

  Future<void> _getCredentiel() async {
    final encryptedEmail = await _secureStorage.read(sEmail);
    if (encryptedEmail != null) {
      rxUser.value = await _encryptionHelper.decrypt(encryptedEmail) ?? '';
      //print('User: ${rxUser.value}');
    }
    final encryptedPass = await _secureStorage.read(sPassword);
    if (encryptedPass != null) {
      rxPass.value = await _encryptionHelper.decrypt(encryptedPass) ?? '';
    }
  }

  Future<void> _initializeWebView() async {
    // Avoid double initialization
    if (_params != null) return;

    // Initialize platform-specific parameters
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      _params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      _params = const PlatformWebViewControllerCreationParams();
    }
    _webViewController = WebViewController.fromPlatformCreationParams(_params!)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) async {
            await onUrlChange(change: change, controller: webViewController);
          },

          onPageFinished: (String url) async {
            if (!isJson && ijson < 5) return;
            await onPageFinish(url: url, controller: webViewController);

            // if (ijson == 4) {
            //   ijson = 5;
            // }
          },
        ),
      )
      ..loadRequest(Uri.parse(baseUrl));
    // Configure platform-specific settings
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  // Getter for the webview controller
  WebViewController get webViewController => _webViewController;

  /// Handle page finish events based on URL and state
  Future<void> onPageFinish({required String url, required WebViewController controller}) async {
    if (!isJson && ijson != 0) return;
    try {
      // Handle different states based on current ijson value and URL
      // print('URL: $url');
      if (url == adfsUrl && ijson == 0) {
        await _performLogin(controller: controller);
        ijson = 1;
      }
      if (ijson < 2 && url.contains('$baseUrl/access-ui/')) {
        visibleWeb = false;
        await loadUrl(url: jsonApiUrl, controller: controller);
        ijson = 2;
      }
      if (url == jsonApiUrl && ijson == 2) {
        await _fetchAndProcessJsonData(controller);
      }
      if (ijson == 3) {
        ijson = 4;
        await Future.delayed(const Duration(seconds: 1), () => loadBaseUrl(mycontroller: controller));
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'onPageFinish', content: 'onPageFinish: ${e.toString()}');
      sEtape = 'status_error_processing'.tr;
    }
  }

  Future<void> onUrlChange({required UrlChange change, required WebViewController controller}) async {
    final String? currentUrl = change.url;
    final bool isRosterPage = currentUrl != null && currentUrl.contains(baseUrl);

    if (ijson != 4 || !isRosterPage) {
      // Not in the right state or not on the roster page, so nothing to do
      return;
    }
    // Update UI state to show processing
    sEtape = 'status_processing'.tr;
    try {
      await _performLogout(controller);
      await _clearBrowserCache(controller);
      ijson = 5;
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'onUrlChange', content: 'onUrlChange: ${e.toString()}');
      // Reset state in case of error
      sEtape = 'status_error_processing'.tr;
    }
  }

  Future<void> onDeconnect({required String url, required WebViewController controller}) async {}

  /// Clear browser cache and storage
  Future<void> _clearBrowserCache(WebViewController controller) async {
    await Future.wait([controller.clearCache(), controller.clearLocalStorage()]);
  }

  /// Perform logout sequence
  Future<void> _performLogout(WebViewController controller) async {
    visibleenregistre = true;
    sEtape = 'status_processing_complete'.tr;
    Future.delayed(const Duration(seconds: 3)).then((_) => loadBaseUrl(mycontroller: controller));
    await Future.delayed(Duration(seconds: 1));

    if (boxGet.read(getDevice) != getIphone) {
      await _deconnexionIpadClick(myController: controller);
    } else {
      // Add delay here

      await _deconnexionClick(myController: controller);
    }
  }

  Future<void> _deconnexionClick({required WebViewController myController}) async {
    try {
      // Execute JavaScript and return the result
      final result = await myController.runJavaScriptReturningResult(logoutJavaScriptFunction);

      if (result.toString().contains('Menu not found!')) {
        MyErrorInfo.erreurInos(label: "Menu Detection", content: "Menu not found in logout process");
      }
    } catch (e) {
      // print(e.toString());
      MyErrorInfo.erreurInos(label: "Error executing deconnexionClick", content: " ${e.toString()}");
    }
  }

  Future<void> _deconnexionIpadClick({required WebViewController myController}) async {
    try {
      await myController.runJavaScript(logoutIpadJavaScriptFunction);
    } catch (e) {
      MyErrorInfo.erreurInos(label: "Error executing deconnexionClick", content: " ${e.toString()}");
    }
  }

  /// Perform login with stored credentials
  Future<void> _performLogin({required WebViewController controller}) async {
    // String myUser = '';
    // String myPass = '';
    // final encryptedEmail = await _secureStorage.read(sEmail);
    // if (encryptedEmail != null) {
    //   myUser = await _encryptionHelper.decrypt(encryptedEmail) ?? '';
    // }
    // final encryptedPass = await _secureStorage.read(sPassword);
    // if (encryptedPass != null) {
    //   myPass = await _encryptionHelper.decrypt(encryptedPass) ?? '';
    // }
    await _getCredentiel();
    await Future.delayed(const Duration(seconds: 1), () async {
      try {
        await controller.runJavaScript(buildLoginScript(login: rxUser.value, mdp: rxPass.value));
      } catch (e) {
        MyErrorInfo.erreurInos(label: 'UsersExist', content: 'Error auto-filling credentials: $e');
      }
    });
  }

  /// Load a URL in the WebView
  Future<void> loadUrl({required String url, required WebViewController controller}) async {
    // Check connectivity before loading URL
    bool hasConnection = getConnexion;
    if (!hasConnection) {
      getConnexion = hasConnection;
      sEtape = 'status_no_internet'.tr;
      return;
    }

    await Future.delayed(const Duration(seconds: 1), () async {
      controller.loadRequest(Uri.parse(url));
    });
  }

  /// Fetch and process JSON data from the API
  Future<void> _fetchAndProcessJsonData(WebViewController controller) async {
    // Check connectivity before fetching data
    bool hasConnection = getConnexion;
    if (!hasConnection) {
      sEtape = 'status_internet_required_fetch'.tr;
      return;
    }

    jsonString = await fetchJsonData(controller: controller);

    if (jsonString?.isNotEmpty ?? false) {
      sEtape = 'status_processing_in_progress'.tr;
      ijson = 3;
    } else {
      MyErrorInfo.erreurInos(label: 'fetchJsonData', content: 'Empty or null JSON data received');
      sEtape = 'status_error_empty_json'.tr;
    }
  }

  /// Fetch JSON data from the WebView
  Future<String> fetchJsonData({required WebViewController controller}) async {
    String myjson = '';
    dynamic data;

    try {
      await Future.delayed(const Duration(seconds: 1), () async {
        data = await controller.runJavaScriptReturningResult(getBodyHtmlJavaScript) as String;
      });

      if (data != null) {
        if (Platform.isAndroid) {
          data = data.replaceAll(r'\"', '"').replaceAll(r'\u003C', '<');
          final lastIndex = data.lastIndexOf("}");
          final firstIndex = data.indexOf("{");
          if (firstIndex >= 0 && lastIndex > firstIndex) {
            myjson = data.substring(firstIndex, lastIndex + 1);
          }
        } else {
          final firstIndex = data.indexOf("{");
          final lastIndex = data.lastIndexOf("}");
          if (firstIndex >= 0 && lastIndex > firstIndex) {
            myjson = data.substring(firstIndex, lastIndex + 1);
          }
        }
      }
    } catch (e) {
      MyErrorInfo.erreurInos(label: 'fetchJsonData', content: 'Empty or null JSON data received:$e');
    }

    return myjson;
  }

  /// Load the base URL
  Future<void> loadBaseUrl({required WebViewController mycontroller}) async {
    // Check connectivity before loading base URL
    bool hasConnection = getConnexion;
    if (!hasConnection) {
      sEtape = 'status_internet_required_base'.tr;
      return;
    }

    await mycontroller.loadRequest(Uri.parse(baseUrl));
  }

  bool enregistrerMjsonString() {
    if (jsonString != null) {
      MyDownLoad myDownLoad = MyDownLoad(jsonContent: jsonString, downloadTime: DateTime.now());
      final jsonResponse = json.decode(jsonString!);
      final myStrip = MyStrip.fromJson(jsonResponse);

      final processedDuties = _stripProcessor.processMyStripIntoDuties(myStrip);
      processedDuties.sort((a, b) => a.startTime.compareTo(b.startTime));
      List<MyDuty> consolidatedDuties = DatabaseController.instance.duties;

      consolidatedDuties.sort((a, b) => a.startTime.compareTo(b.startTime));
      consolidatedDuties.removeWhere((duty) => !duty.startTime.isBefore(processedDuties.first.startTime));
      consolidatedDuties.addAll(processedDuties);
      int userId = DatabaseController.instance.currentUser!.id;
      DatabaseController.instance.duties.assignAll(processedDuties);
      DatabaseController.instance.addDownloadToUser(userId, myDownLoad);
      DatabaseController.instance.replaceAllDuties(DatabaseController.instance.duties);

      // Générer les VolModel
      List<VolModel> allVolModels = DatabaseController.instance.getVolFromDuties(consolidatedDuties);
      DatabaseController.instance.volModels.assignAll(allVolModels);

      // Générer les VolTraiteModel à partir des VolModel
      _genererVolsTraites(allVolModels);

      return true;
    }
    return false;
  }

  void remplisVoltraites() {
    List<VolModel> allVolModels = DatabaseController.instance.volModels;
    // Générer les VolTraiteModel à partir des VolModel
    _genererVolsTraites(allVolModels);
  }

  /// Génère les VolTraiteModel et VolTraiteMoisModel à partir des VolModel
  void _genererVolsTraites(List<VolModel> allVolModels) {
    final dbController = DatabaseController.instance;

    // 1. Créer tous les VolTraiteModel
    final volsTraites = <VolTraiteModel>[];
    for (var volModel in allVolModels) {
      final volTraite = VolTraiteModel.fromVolModel(volModel, allVolModels);
      volsTraites.add(volTraite);
    }

    // 2. Grouper les vols par mois
    final volsParMois = <String, List<VolTraiteModel>>{};
    for (var volTraite in volsTraites) {
      final moisRef = volTraite.moisReference;
      if (!volsParMois.containsKey(moisRef)) {
        volsParMois[moisRef] = [];
      }
      volsParMois[moisRef]!.add(volTraite);
    }

    // 3. Créer les nouveaux VolTraiteMoisModel
    final nouveauxVolTraiteMois = <VolTraiteMoisModel>[];
    for (var entry in volsParMois.entries) {
      final moisRef = entry.key;
      final volsDuMois = entry.value;

      // Parser le moisRef "YYYY-MM"
      final parts = moisRef.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      // Créer le nouveau modèle mensuel
      final newVolTraiteMois = VolTraiteMoisModel.fromVolsTraites(year, month, volsDuMois);
      nouveauxVolTraiteMois.add(newVolTraiteMois);
    }

    // 4. Remplacer tous les VolTraiteMoisModel dans ObjectBox
    dbController.replaceAllVolTraiteMois(nouveauxVolTraiteMois);

    // print('✅ Généré ${volsTraites.length} vols traités dans ${nouveauxVolTraiteMois.length} mois');
    // print('📊 DatabaseController.volTraites.length = ${dbController.volTraites.length}');
    // print('📊 DatabaseController.volTraiteMois.length = ${dbController.volTraiteMois.length}');
  }

  /// Reset the WebView state
  Future<void> webReset({required WebViewController mycontroller}) async {
    // Check connectivity before resetting WebView
    bool hasConnection = getConnexion;
    if (!hasConnection) {
      sEtape = 'status_internet_required_reset'.tr;
      visibleWeb = false;
      return;
    }

    visibleenregistre = false;
    visibleWeb = true;
    sEtape = 'status_downloading'.tr;
    ijson = 0;
    await loadBaseUrl(mycontroller: mycontroller);
  }
}

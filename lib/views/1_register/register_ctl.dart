import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../Models/userModel/usermodel.dart';
import '../../controllers/database_controller.dart';
import '../../services/encryption_service.dart';
import '../../services/secure_storage_service.dart';
import '../../helpers/constants.dart';
import '../../helpers/myerrorinfo.dart';

class RegisterController extends GetxController {
  final _secureStorage = SecureStorageService();
  final _encryptionHelper = EncryptionHelper();
  static RegisterController instance = Get.find();

  final TextEditingController matController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final Rx<bool> _secteur = false.obs;
  bool get secteur => _secteur.value;

  String get sSecteur => (secteur == false) ? mSecteur : lSecteur;
  set secteur(bool mySecteur) {
    _secteur.value = mySecteur;
  }

  final Rx<bool> _amsram = false.obs;
  bool get amsram => _amsram.value;
  String get samsram => (_amsram.value == false) ? ram : ams;
  set amsram(bool mySecteur) {
    _amsram.value = mySecteur;
  }

  final Rx<bool> _ispnt = false.obs;
  bool get ispnt => _ispnt.value;
  String get spntpnc => (_ispnt.value == false) ? pnt : pnc;
  set ispnt(bool pn) {
    _ispnt.value = pn;
  }

  final Rx<bool> _dones = true.obs;
  bool get dones => _dones.value;
  set dones(bool val) {
    _dones.value = val;
  }

  @override
  void onInit() async {
    super.onInit();
    DatabaseController.instance.getAllUsers();

    // Auto-fill form with first user's data if users exist
    _autoFillFormIfUsersExist();
    rempliChampMoi();
  }

  void _autoFillFormIfUsersExist() async {
    final dbController = DatabaseController.instance;

    // Check if there are users in the database
    if (dbController.users.isNotEmpty) {
      final firstUser = dbController.users.first;

      // Fill the text fields with first user's data
      matController.text = firstUser.matricule.toString();
      //  emailController.text = firstUser.email ?? '';

      // Decrypt and fill password from secure storage
      try {
        final encryptedPassword = await _secureStorage.read(sPassword);
        if (encryptedPassword != null) {
          passController.text = await _encryptionHelper.decrypt(encryptedPassword) ?? '';
        }

        final encryptedEmail = await _secureStorage.read(sEmail);
        if (encryptedEmail != null) {
          String emails = await _encryptionHelper.decrypt(encryptedEmail) ?? '';
          emailController.text = emails;
        }
      } catch (e) {
        MyErrorInfo.erreurInos(label: 'UsersExist', content: 'Error auto-filling credentials: $e');
      }
    }
    // else {
    //   rempliChampMoi();
    // }
  }

  static String generateRandomEmail() {
    final random = Random();
    final String characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final int length = 8 + random.nextInt(20 - 8);
    final charList = characters.split(''); // Convert characters to a list
    final nameBuffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(charList.length); // Get a random index
      nameBuffer.write(charList[randomIndex]); // Append a random character
    }
    final String email = '${nameBuffer.toString()}@gmail.com';
    return email; // Convert the buffer to a String
  }

  void registerUser() async {
    // RegisterJsonController.instance.dones = false;
    emailController.text = emailController.text.contains('@')
        ? '${emailController.text.split('@')[0].trim()}@royalairmaroc.com'
        : '${emailController.text.trim()}@royalairmaroc.com';
    final matricule = int.tryParse(matController.text);
    if (matricule == null) {
      MyErrorInfo.erreurInos(label: 'Erreur Matricule', content: 'Le matricule doit être un nombre valide.');
      dones = true; // Re-enable the button
      return;
    }

    final existingUser = DatabaseController.instance.getUserByMatricule(matricule);
    UserModel userToSave;

    if (existingUser != null) {
      // User exists, update their data

      existingUser.isPnt = !ispnt;
      if (!ispnt) {
        // print(ispnt);
        existingUser.isRam = amsram;
        existingUser.isMoyenC = secteur;
      }
      userToSave = existingUser;
      await storeCredential();
      DatabaseController.instance.updateUser(userToSave);
    } else {
      // New user, create a new instance
      String myEmail = generateRandomEmail();
      await storeCredential();
      //print(!ispnt);
      userToSave = UserModel(
        matricule: matricule,
        email: myEmail,
        isRam: !ispnt ? amsram : null,
        isMoyenC: !ispnt ? secteur : null,
        isPnt: !ispnt,
      );
      DatabaseController.instance.addUser(userToSave);
    }
  }

  Future<void> storeCredential() async {
    // Encrypt and store the app password and email
    if (passController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        // Encrypt and store the email
        final encryptedEmail = await _encryptionHelper.encrypt(emailController.text);
        await _secureStorage.write(sEmail, encryptedEmail);

        // Encrypt and store the password
        final encryptedPassword = await _encryptionHelper.encrypt(passController.text);
        await _secureStorage.write(sPassword, encryptedPassword);

        // Clear the controllers after successful storage
        emailController.clear();
        passController.clear();
      } catch (e) {
        MyErrorInfo.erreurInos(
          label: 'Erreur Stockage',
          content: 'Erreur lors du stockage des identifiants.',
        );
      }
    }
  }

  void rempliChampMoi() {
    matController.text = myMatricule; //'1'; //
    emailController.text = myUser; //''; //
    passController.text = myPass; //''; //
    secteur = false;
    amsram = false;
  }
}

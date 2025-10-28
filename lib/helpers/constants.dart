import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

/// Constantes globales de l'application.
///
/// Centralise tous les paramètres constants utilisés dans l'application :
/// dimensions d'écran, URLs, identifiants, formats de date, etc.

// =====================================================================
// SECTION: DIMENSIONS D'ÉCRAN
// =====================================================================

const deviceHeight = 844.0;
const deviceWidth = 390.0;
const deviceHeightIpad = 834.0;
const deviceWidthIpad = 1112.0;
// =====================================================================
// SECTION: CHEMINS ET FICHIERS
// =====================================================================

const String pathAeroportJson = 'assets/jsons/jsaeroports.json';
const String pathForfaitJson = 'assets/jsons/jsforfaits.json';

// =====================================================================
// SECTION: IDENTIFIANTS PAR DÉFAUT
// =====================================================================

const String myMatricule = '8962';
const String myUser = 'Jabdelwahd';
const String myPass = 'AbdeL@5715Jam';

// =====================================================================
// SECTION: FORMATS DE DATE
// =====================================================================

final DateFormat dateFormatMMMm = DateFormat('dd EEE HH:mm');
final DateFormat dateFormatDD = DateFormat('dd-MM-yyyy');
final DateFormat dateFormatMMM = DateFormat('dd/HH:mm');
final DateFormat dateFormatHH = DateFormat('HH:mm');

// =====================================================================
// SECTION: RESSOURCES (IMAGES ET ICÔNES)
// =====================================================================

const String cheminImage = 'assets/iconsacts/';
const String urlImage2 = 'assets/images/avion2.jpg';
const String urlImage1 = 'assets/images/avion1.jpg';
const String urlSunset = 'assets/images/sunset.png';
const String urlSunrise = 'assets/images/sunrise.png';
const String urlNuitback = 'assets/images/nuitback.jpg';
const String urlDayback = 'assets/images/background.jpg';

// =====================================================================
// SECTION: CLÉS DE STOCKAGE LOCAL (GetStorage)
// =====================================================================

final boxGet = GetStorage();
const String getEtape = 'Etape';
const String getDevice = 'Devise';
const String getIphone = 'Iphone';
const String getIpad = 'Ipad';
const String getVersion = 'version';

// =====================================================================
// SECTION: TYPES DE VOL ET COMPAGNIES
// =====================================================================

const mSecteur = 'Moyen Secteur.';
const lSecteur = 'Long Secteur.';
const String ams = 'AMS';
const String ram = 'RAM';
const String pnt = 'PNT';
const String pnc = 'PNC';

// =====================================================================
// SECTION: CLÉS DE STOCKAGE DE CREDENTIALS
// =====================================================================

const String sEmail = 'user_email';
const String sPassword = 'app_password';

// =====================================================================
// SECTION: URLs ET ENDPOINTS
// =====================================================================

const String baseUrl = 'https://crewaccess.ram.jepphost.com';
const String adfsUrl = 'https://adfs.royalairmaroc.com/adfs/ls/';
const String jsonApiUrl = '$baseUrl/access/rs/crew/roster/v1';
const String rosterUrl = '$baseUrl/access-ui/roster';

// =====================================================================
// SECTION: FONCTIONS JAVASCRIPT POUR WEBVIEW
// =====================================================================

/// Fonction JavaScript pour effectuer la déconnexion (version iPhone).
const String logoutJavaScriptFunction = ''' 
  (function () {
  return new Promise(function(resolve) {
    const menuButton = document.querySelector('[class="cds-icon-button cds-icon-button_menu"]');
    if (!menuButton) {
      resolve("Menu button not found");
      return;
    }

    menuButton.click();

    setTimeout(function () {
      try {
        const menuItems = document.querySelectorAll('[class="cds-menu__item"]');
        if (menuItems.length === 0) {
          resolve("Menu items not found");
          return;
        }

        const logoutButton = menuItems[menuItems.length - 1];
        if (!logoutButton || logoutButton.innerText.trim() !== "Logout") {
          resolve("Logout button not found");
          return;
        }

        // Try different clickable elements in order of preference
        const clickableElement = 
          logoutButton.querySelector(".cds-menu__link") ||
          logoutButton.querySelector("button") ||
          logoutButton.querySelector("a") ||
          logoutButton;

        if (clickableElement) {
          // Prevent page reload if it's a link
          if (clickableElement.tagName === 'A') {
            clickableElement.addEventListener('click', function(e) {
              e.preventDefault();
              e.stopPropagation();
            });
          }
          clickableElement.click();
          resolve("Logout successful");
        } else {
          resolve("No clickable element found");
        }
      } catch (error) {
        resolve("Error: " + error.message);
      }
    }, 500);
  });
})();
      ''';

/// Fonction JavaScript pour effectuer la déconnexion (version iPad).
const String logoutIpadJavaScriptFunction = '''
  function deconnexionIpadClick() {
    // Get all menu buttons
      const menuButtons = document.querySelectorAll('[class="cds-icon-button cds-icon-button_menu"]');
    
    // Check if there are any menu buttons
      if (menuButtons.length > 0) {
        // Click the first menu button (no need to click twice)
        menuButtons[0].click();
    
        // Get the menu drawer
        const menu = document.querySelector('[class="cds-drawer__menus"]');
    
        // Check if the menu drawer exists
        if (menu) {
          // Get all menu items
          const menuItemButtons = menu.querySelectorAll('[class="cds-menu__item"]');
    
          // Find the logout button
          let logoutButton = null;
          for (let i = 0; i < menuItemButtons.length; i++) {
            const menuText = menuItemButtons[i].querySelector('[class="cds-menu__text"]');
            if (menuText && menuText.innerText === "Logout") {  // Use strict equality (===)
              console.log("Logout button text:", menuText.innerText);
              logoutButton = menuText;
              break;
            }
          }
    
          // Click the logout button if found
          if (logoutButton) {
            console.log("Logout button found:", logoutButton);
            logoutButton.click();
          } else {
            console.log("Logout button not found in the menu.");
          }
        } else {
          console.log("Menu drawer not found!");
        }
      } else {
        console.log("No menu buttons found.");
      }
    }
deconnexionIpadClick();   
''';

/// Fonction JavaScript pour récupérer le contenu HTML du body.
const String getBodyHtmlJavaScript = "document.body.innerHTML";

/// Construit un script JavaScript pour effectuer la connexion avec les identifiants fournis.
String buildLoginScript({required String login, required String mdp}) {
  return """
    document.getElementById('userNameInput').value ='$login'; 
    document.getElementById('passwordInput').value ='$mdp';
    document.getElementById('submitButton').click();         
  """;
}

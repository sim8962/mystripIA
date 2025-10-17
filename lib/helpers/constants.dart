import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

const deviceHeight = 844.0; //734.0;
const deviceWidth = 390.0; // 375.0;
const deviceHeightIpad = 834.0; //734.0;Size(834, 1112)
const deviceWidthIpad = 1112.0; // 375.0;
const String pathAeroportJson = 'assets/jsons/jsaeroports.json';
const String pathForfaitJson = 'assets/jsons/jsforfaits.json';
const String myMatricule = '8962'; //'8562'; //
const String myUser = 'Jabdelwahd'; //'kbelbachir'; //
const String myPass = 'AbdeL@5715Jam'; //'120998Kb@'; //

final DateFormat dateFormatMMMm = DateFormat('dd EEE HH:mm'); //MMM
final DateFormat dateFormatDD = DateFormat('dd-MM-yyyy');
final DateFormat dateFormatMMM = DateFormat('dd/HH:mm');
final DateFormat dateFormatHH = DateFormat('HH:mm');
const String cheminImage = 'assets/iconsacts/';
const String urlImage2 = 'assets/images/avion2.jpg';
const String urlImage1 = 'assets/images/avion1.jpg';
const String urlNuitback = 'assets/images/nuitback.jpg';
const String urlDayback = 'assets/images/background.jpg';

final boxGet = GetStorage();
const String getEtape = 'Etape';
const String getDevice = 'Devise';
const String getIphone = 'Iphone';
const String getIpad = 'Ipad';
const String getVersion = 'version';

const mSecteur = 'Moyen Secteur.';
const lSecteur = 'Long Secteur.';
const String ams = 'AMS';
const String ram = 'RAM';
const String pnt = 'PNT';
const String pnc = 'PNC';
const String sEmail = 'user_email';
const String sPassword = 'app_password';

// WebView URLs and JavaScript constants
const String baseUrl = 'https://crewaccess.ram.jepphost.com';
const String adfsUrl = 'https://adfs.royalairmaroc.com/adfs/ls/';
const String jsonApiUrl = '$baseUrl/access/rs/crew/roster/v1';
const String rosterUrl = '$baseUrl/access-ui/roster';
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

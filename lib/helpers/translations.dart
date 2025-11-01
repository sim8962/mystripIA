import 'package:get/get.dart';

/// Traductions multilingues de l'application.
///
/// Centralise toutes les chaînes de caractères traduites pour l'interface utilisateur.
/// Supporte l'anglais (en_US) et le français (fr_FR).
/// Utilise le package GetX pour la gestion des traductions.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // ========================================
      // COMMON - Buttons, Actions & Messages
      // ========================================
      'button_close': 'Close',
      'button_save': 'SAVE',
      'button_reset': 'RESET',
      'button_quit': 'Quit',
      'button_import excel': 'Import from excel',
      'button_import pdf': 'Import roster',
      'button_return': 'Return',
      'button_to_home': 'To Home',
      'button_add': 'Add',
      'button_search': 'Search',
      'button_register': 'REGISTER',
      'button_download_strip': 'DOWNLOAD',

      'error': 'Error',
      'success': 'Success',
      'info': 'Info',
      'no_connection': 'No Internet connection.',

      // ========================================
      // REGISTER SCREEN (register_screen.dart)
      // ========================================
      'register_title': 'Register',
      'matricule_label': 'CrewId',
      'matricule_error': 'Please enter your Id',
      'email_label': 'Strip Email',
      'email_error': 'Please enter your Email',
      'password_label': 'Strip Password',
      'password_error': 'Please enter your Password',
      'switch_ram_ams': 'Ram/Ams',
      'switch_pnt_pnc': 'PNT/PNC',
      'switch_secteur': 'Sector',

      // RegisterController Errors
      'error_autofill_credentials': 'Error auto-filling credentials',
      'error_matricule_title': 'Matricule Error',
      'error_matricule_invalid': 'Matricule must be a valid number.',
      'error_storage_title': 'Storage Error',
      'error_storage_credentials': 'Error storing credentials.',

      // ========================================
      // HOME SCREEN (iphone_homepage.dart)
      // ========================================
      'semantic_library_books': 'Library Books',
      'semantic_list': 'List',
      'semantic_upload': 'Upload',
      'semantic_download': 'Download',
      'semantic_file_copy': 'File Copy',
      'semantic_icon': 'Icon',

      // ========================================
      // WEBVIEW SCREEN (webview_screen.dart, webview_ctl.dart)
      // ========================================
      'dialog_download_strip': 'DOWNLOAD MY STRIP',

      // WebViewController Status Messages
      'status_downloading': 'downloading in progress',
      'status_processing': 'processing...',
      'status_processing_in_progress': 'processing in progress',
      'status_processing_complete': 'processing complete.',
      'status_error_processing': 'error during processing',
      'status_error_empty_json': 'error: empty JSON data',
      'status_no_internet': 'No Internet connection',
      'status_internet_required_load': 'Internet connection required to load page',
      'status_internet_required_fetch': 'Internet connection required to fetch data',
      'status_internet_required_reset': 'Internet connection required to reset',
      'status_internet_required_base': 'Internet connection required to load base page',

      // ========================================
      // VOL SCREEN (vol_screen.dart)
      // ========================================
      'vol_search_hint': 'Search by departure, arrival, type or flight number...',
      'vol_no_activity_found': 'No activity found',
      'vol_no_activity_available': 'No activity available',
      'vol_try_other_keywords': 'Try with other keywords',
      'button_to_calendar': 'Calendar',
      'dialog_export_calendar': 'Export to Calendar',
      'button_export': 'EXPORT',

      // ========================================
      // DOWNLOAD SCREEN (download_screen.dart)
      // ========================================
      'download_delete_title': 'Delete Download',
      'download_delete_message':
          'Are you sure you want to delete this download? This action cannot be undone.',
      'download_cancel': 'Cancel',
      'download_delete': 'Delete',
      'download_details_title': 'Download Details',
      'download_json_content': 'JSON Content:',
      'download_html_content': 'HTML Content:',
      'download_at': 'at',

      // ========================================
      // CRUD SCREENS (Airport & Forfait Management)
      // ========================================
      'crud_airport_title': 'Airport Management',
      'crud_forfait_title': 'Package Management',

      // Labels
      'label_icao': 'ICAO',
      'label_iata': 'IATA',
      'label_name': 'Name',
      'label_city': 'City',
      'label_country': 'Country',
      'label_latitude': 'Latitude',
      'label_longitude': 'Longitude',
      'label_altitude': 'Altitude',
      'label_dep': 'Dep',
      'label_arr': 'Arr',

      // Validation Messages
      'error_enter_icao': 'Please enter ICAO code',
      'error_icao_length': 'ICAO code must be 3 to 4 characters',
      'error_enter_iata': 'Please enter IATA code',
      'error_iata_length': 'IATA code must be 3 to 4 characters',
      'error_enter_name': 'Please enter airport name',
      'error_enter_altitude': 'Please enter altitude',
      'error_enter_city': 'Please enter city name',
      'error_enter_country': 'Please enter country name',
      'error_enter_latitude': 'Please enter latitude',
      'error_invalid_latitude': 'Invalid latitude value',
      'error_latitude_range': 'Latitude must be between -90 and 90',
      'error_enter_longitude': 'Please enter longitude',
      'error_invalid_longitude': 'Invalid longitude value',
      'error_longitude_range': 'Longitude must be between -180 and 180',

      // Success/Error Messages
      'success_airport_imported': 'Airports imported successfully',
      'error_import_failed': 'Import failed',
      'error_add_failed': 'Add failed',

      // ========================================
      // SETTINGS SCREEN (settings_screen.dart)
      // ========================================
      'settings_title': 'My Application Settings',
      'settings_menu_title': 'Settings',
      'settings_theme_mode': 'Theme Mode',
      'settings_language': 'Language',

      // Menu Items
      'menu_history': 'History',
      'menu_airports': 'Airports',
      'menu_forfaits': 'Forfaits',
      'menu_import_strip': 'Import Strip',

      // ========================================
      // CARDS & WIDGETS (Duty Cards, Flight Cards)
      // ========================================
      'card_hotel': 'HOTEL',
      'card_forfait_prefix': 'F',
      'card_nuit_prefix': 'N',
      'card_sun_prefix': 'Sun',
      'card_total_forfait_prefix': 'T.F',
      'card_total_nuit_prefix': 'T.N',

      // Flight Duration Labels
      'flight_duration_label': 'D',
      'flight_forfait_label': 'F',
      'flight_night_label': 'N',
      'flight_total_duration_label': 'T.D',
      'flight_total_forfait_label': 'T.F',
      'flight_total_night_label': 'T.N',
      'flight_nil': 'nil',

      // Crew Table Headers
      'crew_sen': 'Sen',
      'crew_position': 'Pos',
      'crew_name': 'Name',

      // ========================================
      // STRIP PROCESSOR & DUTY (strip_processor.dart, myduty.dart)
      // ========================================
      'duty_legs': 'Legs',
      'duty_tsv_max': 'max.',
      'duty_tsv_end': 'TSV End:',
      'duty_hotel': 'Hotel:',
      'duty_transport': 'Transport:',

      // Activity Type Labels (typ_const.dart)
      'type_rotation': 'LayOver',
      'type_vols': 'Flights',
      'type_vol': 'Flight',
      'type_tsv': 'Duty Period',
      'type_rv': 'Reserve',
      'type_mep': 'Deadhead',
      'type_cet': 'Ground Transport',
      'type_htl': 'Layover',
      'type_tax': 'Taxi',
      'type_simu': 'Simulator',
      'type_cnl': 'Cancelled',
      'type_cm': 'Sick Leave',
      'type_off': 'Day Off',
      'type_reu': 'Meeting',
      'type_conge': 'Leave',
      'type_duty': 'Duty',
      'type_for': 'Training',
      'type_abs': 'Absence',

      // ========================================
      // DATE & TIME (Weekdays, Months)
      // ========================================
      // Weekdays
      'weekday_monday': 'Monday',
      'weekday_tuesday': 'Tuesday',
      'weekday_wednesday': 'Wednesday',
      'weekday_thursday': 'Thursday',
      'weekday_friday': 'Friday',
      'weekday_saturday': 'Saturday',
      'weekday_sunday': 'Sunday',

      // Months
      'month_jan': 'Jan',
      'month_feb': 'Feb',
      'month_mar': 'Mar',
      'month_apr': 'Apr',
      'month_may': 'May',
      'month_jun': 'Jun',
      'month_jul': 'Jul',
      'month_aug': 'Aug',
      'month_sep': 'Sep',
      'month_oct': 'Oct',
      'month_nov': 'Nov',
      'month_dec': 'Dec',

      // ========================================
      // CALENDAR SCREEN (calender_screen.dart)
      // ========================================
      'calendar_create_sync': 'Create and Sync Calendar',
      'calendar_none_found': 'No calendars found',
      'date_from': 'From',
      'date_to': 'To',
      'calendar_with_hotel': 'with Hotel',
      'calendar_without_hotel': 'without Htl',
      'calendar_export_complete': 'Export Complete',

      'calendar_export_done': 'Calendar export completed successfully',
      'calendar_add_calendar': 'Add Calendar',
      'calendar_export_date': 'Export Date Range',
      'flight_vols': 'Flights',
      'calendar_flights_from': 'from',
      'calendar_and_before': 'and before',

      // Error Messages
      'error_retrieve_calendars': 'Error retrieving calendars',
      'error_add_calendar': 'Error adding calendar',
      'error_delete_calendar': 'Error deleting calendar',
      'error_add_events': 'Error adding events to calendar',
      'error_delete_events': 'Error deleting events from calendar',
      'error_calendar_permission': 'Calendar Permission Error',
      'error_calendar_permission_denied': 'Calendar access permission denied. Please enable it in settings.',
      'success_calendar_created': 'Calendar created successfully',
      'success_events_added': 'Events added to calendar successfully',
      'success_events_deleted': 'Events deleted from calendar successfully',
      'import_instructions':
          'To import your data from old files, click on the corresponding button, a dialog box will appear, indicate the path to the download folder, select the strip files, click on open',
    },
    'fr_FR': {
      // ========================================
      // COMMON - Boutons, Actions & Messages
      // ========================================
      'button_close': 'Fermer',
      'button_save': 'ENREGISTRER',
      'button_reset': 'RESET',
      'button_quit': 'Quitter',
      'button_import excel': "Importer d'excel",
      'button_import pdf': "Importer rosters",
      'button_return': 'Retour',
      'button_to_home': 'Vers Accueil',
      'button_add': 'Ajouter',
      'button_search': 'Rechercher',
      'button_register': 'ENREGISTRER',
      'button_download_strip': 'TÉLÉCHARGER',

      'error': 'Erreur',
      'success': 'Succès',
      'info': 'Info',
      'no_connection': 'Aucune connexion Internet disponible.',

      // ========================================
      // REGISTER SCREEN (register_screen.dart)
      // ========================================
      'register_title': 'Inscription',
      'matricule_label': ' Matricule',
      'matricule_error': 'Veuillez saisir votre Matricule',
      'email_label': 'Email Strip',
      'email_error': 'Veuillez saisir votre Email',
      'password_label': 'Mot de Passe Strip',
      'password_error': 'Veuillez saisir votre Mot de Passe',
      'switch_ram_ams': 'Ram/Ams',
      'switch_pnt_pnc': 'PNT/PNC',
      'switch_secteur': 'Secteur',

      // RegisterController Errors
      'error_autofill_credentials': 'Erreur lors du remplissage automatique des identifiants',
      'error_matricule_title': 'Erreur Matricule',
      'error_matricule_invalid': 'Le matricule doit être un nombre valide.',
      'error_storage_title': 'Erreur Stockage',
      'error_storage_credentials': 'Erreur lors du stockage des identifiants.',

      // ========================================
      // HOME SCREEN (iphone_homepage.dart)
      // ========================================
      'semantic_library_books': 'Bibliothèque',
      'semantic_list': 'Liste',
      'semantic_upload': 'Exporter',
      'semantic_download': 'Télécharger',
      'semantic_file_copy': 'Copier fichier',
      'semantic_icon': 'Icône',

      // ========================================
      // WEBVIEW SCREEN (webview_screen.dart, webview_ctl.dart)
      // ========================================
      'dialog_download_strip': 'TÉLÉCHARGER MON STRIP',

      // WebViewController Status Messages
      'status_downloading': 'téléchargement en cours',
      'status_processing': 'traitement...',
      'status_processing_in_progress': 'traitement en cours',
      'status_processing_complete': 'traitement terminé.',
      'status_error_processing': 'erreur pendant le traitement',
      'status_error_empty_json': 'erreur: données JSON vides',
      'status_no_internet': 'Aucune connexion Internet',
      'status_internet_required_load': 'Connexion Internet requise pour charger la page',
      'status_internet_required_fetch': 'Connexion Internet requise pour récupérer les données',
      'status_internet_required_reset': 'Connexion Internet requise pour réinitialiser',
      'status_internet_required_base': 'Connexion Internet requise pour charger la page de base',

      // ========================================
      // VOL SCREEN (vol_screen.dart)
      // ========================================
      'vol_search_hint': 'Rechercher par départ, arrivée, type ou numéro de vol...',
      'vol_no_activity_found': 'Aucune activité trouvée',
      'vol_no_activity_available': 'Aucune activité disponible',
      'vol_try_other_keywords': "Essayez avec d'autres mots-clés",
      'button_to_calendar': 'Calendrier',
      'dialog_export_calendar': 'Exporter vers Calendrier',
      'button_export': 'EXPORTER',

      // ========================================
      // DOWNLOAD SCREEN (download_screen.dart)
      // ========================================
      'download_delete_title': 'Supprimer le téléchargement',
      'download_delete_message':
          'Êtes-vous sûr de vouloir supprimer ce téléchargement ? Cette action est irréversible.',
      'download_cancel': 'Annuler',
      'download_delete': 'Supprimer',
      'download_details_title': 'Détails du téléchargement',
      'download_json_content': 'Contenu JSON :',
      'download_html_content': 'Contenu HTML :',
      'download_at': 'à',

      // ========================================
      // CRUD SCREENS (Airport & Forfait Management)
      // ========================================
      'crud_airport_title': 'Gestion des Aéroports',
      'crud_forfait_title': 'Gestion des Forfaits',

      // Labels
      'label_icao': 'ICAO',
      'label_iata': 'IATA',
      'label_name': 'Nom',
      'label_city': 'Ville',
      'label_country': 'Pays',
      'label_latitude': 'Latitude',
      'label_longitude': 'Longitude',
      'label_altitude': 'Altitude',
      'label_dep': 'Dép',
      'label_arr': 'Arr',

      // Validation Messages
      'error_enter_icao': 'Veuillez entrer le code ICAO',
      'error_icao_length': 'Le code ICAO doit comporter 3 à 4 caractères',
      'error_enter_iata': 'Veuillez entrer le code IATA',
      'error_iata_length': 'Le code IATA doit comporter 3 à 4 caractères',
      'error_enter_name': "Veuillez entrer le nom de l'aéroport",
      'error_enter_altitude': "Veuillez entrer l'altitude",
      'error_enter_city': 'Veuillez entrer le nom de la ville',
      'error_enter_country': 'Veuillez entrer le nom du pays',
      'error_enter_latitude': 'Veuillez entrer la latitude',
      'error_invalid_latitude': 'Valeur de latitude invalide',
      'error_latitude_range': 'La latitude doit être comprise entre -90 et 90',
      'error_enter_longitude': 'Veuillez entrer la longitude',
      'error_invalid_longitude': 'Valeur de longitude invalide',
      'error_longitude_range': 'La longitude doit être comprise entre -180 et 180',

      // Success/Error Messages
      'success_airport_imported': 'Aéroports importés avec succès',
      'error_import_failed': "Échec de l'importation",
      'error_add_failed': "Échec de l'ajout",

      // ========================================
      // SETTINGS SCREEN (settings_screen.dart)
      // ========================================
      'settings_title': 'Paramètres de mon application',
      'settings_menu_title': 'Paramètres',
      'settings_theme_mode': 'Mode Thème',
      'settings_language': 'Langue',

      // Menu Items
      'menu_history': 'Historique',
      'menu_airports': 'Aéroports',
      'menu_forfaits': 'Forfaits',
      'menu_import_strip': 'Import Strip',

      // ========================================
      // CARDS & WIDGETS (Duty Cards, Flight Cards)
      // ========================================
      'card_hotel': 'HÔTEL',
      'card_forfait_prefix': 'F',
      'card_nuit_prefix': 'N',
      'card_sun_prefix': 'Sun',
      'card_total_forfait_prefix': 'T.F',
      'card_total_nuit_prefix': 'T.N',

      // Flight Duration Labels
      'flight_duration_label': 'D',
      'flight_forfait_label': 'F',
      'flight_night_label': 'N',
      'flight_total_duration_label': 'T.D',
      'flight_total_forfait_label': 'T.F',
      'flight_total_night_label': 'T.N',
      'flight_nil': 'nil',

      // Crew Table Headers
      'crew_sen': 'Sen',
      'crew_position': 'Pos',
      'crew_name': 'Nom',

      // ========================================
      // STRIP PROCESSOR & DUTY (strip_processor.dart, myduty.dart)
      // ========================================
      'duty_legs': 'Etapes',
      'duty_tsv_max': 'max.',
      'duty_tsv_end': 'Fin Tsv:',
      'duty_hotel': 'Hôtel:',
      'duty_transport': 'Transport:',

      // Activity Type Labels (typ_const.dart)
      'type_rotation': 'Rotation',
      'type_vols': 'Vols',
      'type_vol': 'Vol',
      'type_tsv': 'Période de Service',
      'type_rv': 'Réserve',
      'type_mep': 'MEP',
      'type_cet': 'Transport Sol',
      'type_htl': 'Escale',
      'type_tax': 'Taxi',
      'type_simu': 'Simulateur',
      'type_cnl': 'Annulé',
      'type_cm': 'Congé Maladie',
      'type_off': 'Repos',
      'type_reu': 'Réunion',
      'type_conge': 'Congé',
      'type_duty': 'Service',
      'type_for': 'Formation',
      'type_abs': 'Absence',

      // ========================================
      // DATE & TIME (Weekdays, Months)
      // ========================================
      // Weekdays
      'weekday_monday': 'Lundi',
      'weekday_tuesday': 'Mardi',
      'weekday_wednesday': 'Mercredi',
      'weekday_thursday': 'Jeudi',
      'weekday_friday': 'Vendredi',
      'weekday_saturday': 'Samedi',
      'weekday_sunday': 'Dimanche',

      // Months
      'month_jan': 'Jan',
      'month_feb': 'Fév',
      'month_mar': 'Mar',
      'month_apr': 'Avr',
      'month_may': 'Mai',
      'month_jun': 'Juin',
      'month_jul': 'Juil',
      'month_aug': 'Août',
      'month_sep': 'Sep',
      'month_oct': 'Oct',
      'month_nov': 'Nov',
      'month_dec': 'Déc',

      // ========================================
      // CALENDAR SCREEN (calender_screen.dart)
      // ========================================
      'calendar_create_sync': 'Créer et synchroniser le calendrier',
      'calendar_none_found': 'Aucun calendrier trouvé',
      'date_from': 'Du',
      'date_to': 'Au',
      'calendar_with_hotel': 'avec htl',
      'calendar_without_hotel': 'sans htl',
      'calendar_export_complete': 'Export terminé',

      'calendar_export_done': 'Export du calendrier terminé avec succès',
      'calendar_add_calendar': 'Ajouter un calendrier',
      'calendar_export_date': 'Plage de dates d\'export',
      'flight_vols': 'Vols',
      'calendar_flights_from': 'du',
      'calendar_and_before': 'et avant',

      // Error Messages
      'error_retrieve_calendars': 'Erreur lors de la récupération des calendriers',
      'error_add_calendar': 'Erreur lors de l\'ajout du calendrier',
      'error_delete_calendar': 'Erreur lors de la suppression du calendrier',
      'error_add_events': 'Erreur lors de l\'ajout des événements au calendrier',
      'error_delete_events': 'Erreur lors de la suppression des événements du calendrier',
      'error_calendar_permission': 'Erreur de permission calendrier',
      'error_calendar_permission_denied':
          'Accès au calendrier refusé. Veuillez l\'activer dans les paramètres.',
      'success_calendar_created': 'Calendrier créé avec succès',
      'success_events_added': 'Événements ajoutés au calendrier avec succès',
      'success_events_deleted': 'Événements supprimés du calendrier avec succès',
      'import_instructions':
          'Pour importer vos données depuis des fichiers anciens, Cliquer sur le bouton correspondant, une boîte de dialogue s\'affiche, indiquer le chemin du dossier téléchargement, sélectionner les fichiers strip, cliquer sur open',
    },
  };
}

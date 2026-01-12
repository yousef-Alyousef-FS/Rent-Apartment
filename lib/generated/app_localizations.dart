import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @availableApartments.
  ///
  /// In en, this message translates to:
  /// **'Available Apartments'**
  String get availableApartments;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @noApartmentsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No apartments available.'**
  String get noApartmentsAvailable;

  /// No description provided for @loadingApartments.
  ///
  /// In en, this message translates to:
  /// **'Loading apartments...'**
  String get loadingApartments;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {errorMessage}'**
  String errorOccurred(Object errorMessage);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{0 Rooms} =1{1 Room} other{{count} Rooms}}'**
  String rooms(num count);

  /// No description provided for @sqm.
  ///
  /// In en, this message translates to:
  /// **'sqm'**
  String get sqm;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @editApartmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Apartment Details'**
  String get editApartmentDetails;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'/ night'**
  String get perNight;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{0 reviews} =1{1 review} other{{count} reviews}}'**
  String reviews(num count);

  /// No description provided for @completeYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeYourProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @dobHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get dobHint;

  /// No description provided for @personalPhoto.
  ///
  /// In en, this message translates to:
  /// **'Personal Photo'**
  String get personalPhoto;

  /// No description provided for @idCardPhoto.
  ///
  /// In en, this message translates to:
  /// **'ID Card Photo'**
  String get idCardPhoto;

  /// No description provided for @selectBothPhotos.
  ///
  /// In en, this message translates to:
  /// **'Please select both Personal and ID Card photos.'**
  String get selectBothPhotos;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get resetYourPassword;

  /// No description provided for @forgotPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number associated with your account, and we will send instructions to reset your password.'**
  String get forgotPasswordInstructions;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @sendResetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Instructions'**
  String get sendResetInstructions;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue using the app...'**
  String get loginSubtitle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @registrationPending.
  ///
  /// In en, this message translates to:
  /// **'Registration Pending'**
  String get registrationPending;

  /// No description provided for @yourAccountIsUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your Account is Under Review'**
  String get yourAccountIsUnderReview;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration has been submitted successfully. Please wait for the admin to approve your account. You will be able to log in once your account is approved.'**
  String get pendingApprovalMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeToRentalApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RentalApp'**
  String get welcomeToRentalApp;

  /// No description provided for @findYourNextHome.
  ///
  /// In en, this message translates to:
  /// **'Find your next home with ease.'**
  String get findYourNextHome;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{0 nights} =1{1 night} other{{count} nights}}'**
  String nights(num count);

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get priceDetails;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get serviceFee;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid (USD)'**
  String get totalPaid;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @areYouSureCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get areYouSureCancelBooking;

  /// No description provided for @cancellationError.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel booking.'**
  String get cancellationError;

  /// No description provided for @cancellationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully.'**
  String get cancellationSuccess;

  /// No description provided for @directionsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Could not launch maps, address is not available.'**
  String get directionsNotAvailable;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @costSummary.
  ///
  /// In en, this message translates to:
  /// **'Cost Summary'**
  String get costSummary;

  /// No description provided for @pricePerNightLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per night'**
  String get pricePerNightLabel;

  /// No description provided for @numberOfNights.
  ///
  /// In en, this message translates to:
  /// **'Number of nights'**
  String get numberOfNights;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @confirmAndPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm and Pay'**
  String get confirmAndPay;

  /// No description provided for @failedToCreateBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking.'**
  String get failedToCreateBooking;

  /// No description provided for @bookingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get bookingSuccessful;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully booked your stay. You can view the details in your bookings list.'**
  String get bookingSuccessMessage;

  /// No description provided for @viewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'View Booking Details'**
  String get viewBookingDetails;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming bookings.'**
  String get noUpcomingBookings;

  /// No description provided for @noCompletedBookings.
  ///
  /// In en, this message translates to:
  /// **'You have no completed bookings.'**
  String get noCompletedBookings;

  /// No description provided for @noCancelledBookings.
  ///
  /// In en, this message translates to:
  /// **'You have no cancelled bookings.'**
  String get noCancelledBookings;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @editBooking.
  ///
  /// In en, this message translates to:
  /// **'Edit Booking'**
  String get editBooking;

  /// No description provided for @editBookingNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This feature is not yet available.'**
  String get editBookingNotAvailable;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @selectNewDates.
  ///
  /// In en, this message translates to:
  /// **'Select new dates for your booking at'**
  String get selectNewDates;

  /// No description provided for @bookingUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking updated successfully!'**
  String get bookingUpdatedSuccess;

  /// No description provided for @failedToUpdateBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to update booking.'**
  String get failedToUpdateBooking;

  /// No description provided for @updateBooking.
  ///
  /// In en, this message translates to:
  /// **'Update Booking'**
  String get updateBooking;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @howWasYourStay.
  ///
  /// In en, this message translates to:
  /// **'How was your stay?'**
  String get howWasYourStay;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @tellUsExperience.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get tellUsExperience;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating.'**
  String get pleaseSelectRating;

  /// No description provided for @pleaseWriteComment.
  ///
  /// In en, this message translates to:
  /// **'Please write a comment.'**
  String get pleaseWriteComment;

  /// No description provided for @reviewSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully!'**
  String get reviewSubmittedSuccess;

  /// No description provided for @failedToSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit review.'**
  String get failedToSubmitReview;

  /// No description provided for @getYouStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started!'**
  String get getYouStarted;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match!'**
  String get passwordsDoNotMatch;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @unexpectedErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedErrorOccurred;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @addNewApartment.
  ///
  /// In en, this message translates to:
  /// **'Add New Apartment'**
  String get addNewApartment;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @detailedAddress.
  ///
  /// In en, this message translates to:
  /// **'Detailed Address'**
  String get detailedAddress;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @pricePerNight.
  ///
  /// In en, this message translates to:
  /// **'Price / night'**
  String get pricePerNight;

  /// No description provided for @areaSqm.
  ///
  /// In en, this message translates to:
  /// **'Area (sqm)'**
  String get areaSqm;

  /// No description provided for @numberOfRooms.
  ///
  /// In en, this message translates to:
  /// **'Number of Rooms'**
  String get numberOfRooms;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @pleaseAddOneImage.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one image.'**
  String get pleaseAddOneImage;

  /// No description provided for @apartmentAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Apartment added successfully!'**
  String get apartmentAddedSuccess;

  /// No description provided for @failedToAddApartment.
  ///
  /// In en, this message translates to:
  /// **'Failed to add apartment.'**
  String get failedToAddApartment;

  /// No description provided for @addApartment.
  ///
  /// In en, this message translates to:
  /// **'Add Apartment'**
  String get addApartment;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @editApartment.
  ///
  /// In en, this message translates to:
  /// **'Edit Apartment'**
  String get editApartment;

  /// No description provided for @changesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changesSavedSuccess;

  /// No description provided for @failedToSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes.'**
  String get failedToSaveChanges;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @manageBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'Manage Booking Request'**
  String get manageBookingRequest;

  /// No description provided for @renterInformation.
  ///
  /// In en, this message translates to:
  /// **'Renter Information'**
  String get renterInformation;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @apartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get apartment;

  /// No description provided for @totalPayout.
  ///
  /// In en, this message translates to:
  /// **'Total Payout'**
  String get totalPayout;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed, please try again.'**
  String get actionFailed;

  /// No description provided for @couldNotLoadApartments.
  ///
  /// In en, this message translates to:
  /// **'Could not load your apartments.'**
  String get couldNotLoadApartments;

  /// No description provided for @noApartmentsAdded.
  ///
  /// In en, this message translates to:
  /// **'You have not added any apartments yet.'**
  String get noApartmentsAdded;

  /// No description provided for @viewBookings.
  ///
  /// In en, this message translates to:
  /// **'View Bookings'**
  String get viewBookings;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDeleteApartment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeleteApartment;

  /// No description provided for @areYouSureDeleteApartment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this apartment? All related bookings will be cancelled. This action cannot be undone.'**
  String get areYouSureDeleteApartment;

  /// No description provided for @apartmentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Apartment deleted successfully.'**
  String get apartmentDeletedSuccess;

  /// No description provided for @failedToDeleteApartment.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete apartment.'**
  String get failedToDeleteApartment;

  /// No description provided for @bookingsFor.
  ///
  /// In en, this message translates to:
  /// **'Bookings for'**
  String get bookingsFor;

  /// No description provided for @noBookingsForApartment.
  ///
  /// In en, this message translates to:
  /// **'There are no bookings for this apartment yet.'**
  String get noBookingsForApartment;

  /// No description provided for @bookedBy.
  ///
  /// In en, this message translates to:
  /// **'Booked by'**
  String get bookedBy;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @apartmentBookings.
  ///
  /// In en, this message translates to:
  /// **'Apartment Bookings'**
  String get apartmentBookings;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get newRequests;

  /// No description provided for @noNewRequests.
  ///
  /// In en, this message translates to:
  /// **'No new booking requests.'**
  String get noNewRequests;

  /// No description provided for @ownerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Owner Dashboard'**
  String get ownerDashboard;

  /// No description provided for @welcomeOwner.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Owner!'**
  String get welcomeOwner;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @myApartments.
  ///
  /// In en, this message translates to:
  /// **'My Apartments'**
  String get myApartments;

  /// No description provided for @ownerProfile.
  ///
  /// In en, this message translates to:
  /// **'Owner Profile'**
  String get ownerProfile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @businessSettings.
  ///
  /// In en, this message translates to:
  /// **'Business Settings'**
  String get businessSettings;

  /// No description provided for @payoutMethods.
  ///
  /// In en, this message translates to:
  /// **'Payout Methods'**
  String get payoutMethods;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @featureNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This feature is not yet available.'**
  String get featureNotAvailable;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get passwordUpdatedSuccess;

  /// No description provided for @failedToUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password.'**
  String get failedToUpdatePassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get failedToUpdateProfile;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'You have not written any reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @reviewOn.
  ///
  /// In en, this message translates to:
  /// **'Review on'**
  String get reviewOn;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @viewAndEditProfile.
  ///
  /// In en, this message translates to:
  /// **'View and edit profile'**
  String get viewAndEditProfile;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a city, neighborhood, or address...'**
  String get searchHint;

  /// No description provided for @exploreAndSearch.
  ///
  /// In en, this message translates to:
  /// **'Explore & Search'**
  String get exploreAndSearch;

  /// No description provided for @noApartmentsMatch.
  ///
  /// In en, this message translates to:
  /// **'No apartments match your criteria.'**
  String get noApartmentsMatch;

  /// No description provided for @filterOptions.
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterOptions;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @minRooms.
  ///
  /// In en, this message translates to:
  /// **'Min. Rooms'**
  String get minRooms;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @areYouSureDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete the user {fullName}? This action cannot be undone.'**
  String areYouSureDeleteUser(Object fullName);

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @noPendingUsers.
  ///
  /// In en, this message translates to:
  /// **'No pending users for approval.'**
  String get noPendingUsers;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found in the system.'**
  String get noUsersFound;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navMyPlace.
  ///
  /// In en, this message translates to:
  /// **'My Place'**
  String get navMyPlace;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeScreenTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @homeScreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Explore apartments or manage your properties using the tabs below.'**
  String get homeScreenMessage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(Object name);

  /// No description provided for @exploreScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore & Search'**
  String get exploreScreenTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search places by title...'**
  String get searchPlaceholder;

  /// No description provided for @genericFetchError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Pull to refresh.'**
  String get genericFetchError;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No apartments match your criteria.'**
  String get noResults;

  /// No description provided for @filterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get filterSheetTitle;

  /// No description provided for @filterLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get filterLocation;

  /// No description provided for @filterPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get filterPriceRange;

  /// No description provided for @filterSpecifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get filterSpecifications;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get favoritesTitle;

  /// No description provided for @noFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your favorite places will appear here.'**
  String get noFavoritesMessage;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Instructions sent successfully!'**
  String get resetPasswordSuccess;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @couldNotLaunchMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not launch maps'**
  String get couldNotLaunchMaps;

  /// No description provided for @bookingDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Booking details are unavailable'**
  String get bookingDetailsUnavailable;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID: {id}'**
  String bookingId(Object id);

  /// No description provided for @bookingRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent!'**
  String get bookingRequestSent;

  /// No description provided for @bookingRequestSentMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking request has been sent to the owner. You can view its status in your bookings list.'**
  String get bookingRequestSentMessage;

  /// No description provided for @viewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get viewMyBookings;

  /// No description provided for @status_pending_approval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get status_pending_approval;

  /// No description provided for @status_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get status_confirmed;

  /// No description provided for @status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get status_rejected;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @sendBookingRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Booking Request'**
  String get sendBookingRequest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

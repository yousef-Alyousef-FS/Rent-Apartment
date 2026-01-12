// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get availableApartments => 'Available Apartments';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get areYouSureLogout => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get account => 'Account';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get noApartmentsAvailable => 'No apartments available.';

  @override
  String get loadingApartments => 'Loading apartments...';

  @override
  String errorOccurred(Object errorMessage) {
    return 'An error occurred: $errorMessage';
  }

  @override
  String get details => 'Details';

  @override
  String rooms(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rooms',
      one: '1 Room',
      zero: '0 Rooms',
    );
    return '$_temp0';
  }

  @override
  String get sqm => 'sqm';

  @override
  String get description => 'Description';

  @override
  String get editApartmentDetails => 'Edit Apartment Details';

  @override
  String get price => 'Price';

  @override
  String get perNight => '/ night';

  @override
  String get bookNow => 'Book Now';

  @override
  String reviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: '0 reviews',
    );
    return '$_temp0';
  }

  @override
  String get completeYourProfile => 'Complete Your Profile';

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter your first name';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get dateOfBirth => 'Date Of Birth';

  @override
  String get dobHint => 'YYYY-MM-DD';

  @override
  String get personalPhoto => 'Personal Photo';

  @override
  String get idCardPhoto => 'ID Card Photo';

  @override
  String get selectBothPhotos =>
      'Please select both Personal and ID Card photos.';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get resetYourPassword => 'Reset Your Password';

  @override
  String get forgotPasswordInstructions =>
      'Enter the phone number associated with your account, and we will send instructions to reset your password.';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get sendResetInstructions => 'Send Reset Instructions';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Login to continue using the app...';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get forgotYourPassword => 'Forgot your password?';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get registrationPending => 'Registration Pending';

  @override
  String get yourAccountIsUnderReview => 'Your Account is Under Review';

  @override
  String get pendingApprovalMessage =>
      'Your registration has been submitted successfully. Please wait for the admin to approve your account. You will be able to log in once your account is approved.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeToRentalApp => 'Welcome to RentalApp';

  @override
  String get findYourNextHome => 'Find your next home with ease.';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get dates => 'Dates';

  @override
  String nights(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nights',
      one: '1 night',
      zero: '0 nights',
    );
    return '$_temp0';
  }

  @override
  String get guests => 'Guests';

  @override
  String get priceDetails => 'Price Details';

  @override
  String get serviceFee => 'Service fee';

  @override
  String get totalPaid => 'Total Paid (USD)';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get areYouSureCancelBooking =>
      'Are you sure you want to cancel this booking? This action cannot be undone.';

  @override
  String get cancellationError => 'Could not cancel booking.';

  @override
  String get cancellationSuccess => 'Booking cancelled successfully.';

  @override
  String get directionsNotAvailable =>
      'Could not launch maps, address is not available.';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get costSummary => 'Cost Summary';

  @override
  String get pricePerNightLabel => 'Price per night';

  @override
  String get numberOfNights => 'Number of nights';

  @override
  String get totalCost => 'Total Cost';

  @override
  String get confirmAndPay => 'Confirm and Pay';

  @override
  String get failedToCreateBooking => 'Failed to create booking.';

  @override
  String get bookingSuccessful => 'Booking Successful!';

  @override
  String get bookingSuccessMessage =>
      'You have successfully booked your stay. You can view the details in your bookings list.';

  @override
  String get viewBookingDetails => 'View Booking Details';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noUpcomingBookings => 'You have no upcoming bookings.';

  @override
  String get noCompletedBookings => 'You have no completed bookings.';

  @override
  String get noCancelledBookings => 'You have no cancelled bookings.';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get addReview => 'Add Review';

  @override
  String get editBooking => 'Edit Booking';

  @override
  String get editBookingNotAvailable => 'This feature is not yet available.';

  @override
  String get total => 'Total';

  @override
  String get selectNewDates => 'Select new dates for your booking at';

  @override
  String get bookingUpdatedSuccess => 'Booking updated successfully!';

  @override
  String get failedToUpdateBooking => 'Failed to update booking.';

  @override
  String get updateBooking => 'Update Booking';

  @override
  String get writeReview => 'Write a Review';

  @override
  String get howWasYourStay => 'How was your stay?';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get yourReview => 'Your Review';

  @override
  String get tellUsExperience => 'Tell us about your experience...';

  @override
  String get submitReview => 'Submit Review';

  @override
  String get pleaseSelectRating => 'Please select a rating.';

  @override
  String get pleaseWriteComment => 'Please write a comment.';

  @override
  String get reviewSubmittedSuccess => 'Review submitted successfully!';

  @override
  String get failedToSubmitReview => 'Failed to submit review.';

  @override
  String get getYouStarted => 'Let\'s get you started!';

  @override
  String get createPassword => 'Create password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match!';

  @override
  String get reEnterPassword => 'Re-enter your password';

  @override
  String get next => 'Next';

  @override
  String get unexpectedErrorOccurred => 'An unexpected error occurred.';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get addNewApartment => 'Add New Apartment';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get title => 'Title';

  @override
  String get required => 'Required';

  @override
  String get location => 'Location';

  @override
  String get governorate => 'Governorate';

  @override
  String get city => 'City';

  @override
  String get detailedAddress => 'Detailed Address';

  @override
  String get specifications => 'Specifications';

  @override
  String get pricePerNight => 'Price / night';

  @override
  String get areaSqm => 'Area (sqm)';

  @override
  String get numberOfRooms => 'Number of Rooms';

  @override
  String get photos => 'Photos';

  @override
  String get pleaseAddOneImage => 'Please add at least one image.';

  @override
  String get apartmentAddedSuccess => 'Apartment added successfully!';

  @override
  String get failedToAddApartment => 'Failed to add apartment.';

  @override
  String get addApartment => 'Add Apartment';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get editApartment => 'Edit Apartment';

  @override
  String get changesSavedSuccess => 'Changes saved successfully!';

  @override
  String get failedToSaveChanges => 'Failed to save changes.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get manageBookingRequest => 'Manage Booking Request';

  @override
  String get renterInformation => 'Renter Information';

  @override
  String get joined => 'Joined';

  @override
  String get apartment => 'Apartment';

  @override
  String get totalPayout => 'Total Payout';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get actionFailed => 'Action failed, please try again.';

  @override
  String get couldNotLoadApartments => 'Could not load your apartments.';

  @override
  String get noApartmentsAdded => 'You have not added any apartments yet.';

  @override
  String get viewBookings => 'View Bookings';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDeleteApartment => 'Confirm Deletion';

  @override
  String get areYouSureDeleteApartment =>
      'Are you sure you want to permanently delete this apartment? All related bookings will be cancelled. This action cannot be undone.';

  @override
  String get apartmentDeletedSuccess => 'Apartment deleted successfully.';

  @override
  String get failedToDeleteApartment => 'Failed to delete apartment.';

  @override
  String get bookingsFor => 'Bookings for';

  @override
  String get noBookingsForApartment =>
      'There are no bookings for this apartment yet.';

  @override
  String get bookedBy => 'Booked by';

  @override
  String get status => 'Status';

  @override
  String get apartmentBookings => 'Apartment Bookings';

  @override
  String get newRequests => 'New Requests';

  @override
  String get noNewRequests => 'No new booking requests.';

  @override
  String get ownerDashboard => 'Owner Dashboard';

  @override
  String get welcomeOwner => 'Welcome, Owner!';

  @override
  String get viewAll => 'View All';

  @override
  String get myApartments => 'My Apartments';

  @override
  String get ownerProfile => 'Owner Profile';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get businessSettings => 'Business Settings';

  @override
  String get payoutMethods => 'Payout Methods';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get featureNotAvailable => 'This feature is not yet available.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordUpdatedSuccess => 'Password updated successfully!';

  @override
  String get failedToUpdatePassword => 'Failed to update password.';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get failedToUpdateProfile => 'Failed to update profile.';

  @override
  String get myReviews => 'My Reviews';

  @override
  String get noReviewsYet => 'You have not written any reviews yet.';

  @override
  String get reviewOn => 'Review on';

  @override
  String get myProfile => 'My Profile';

  @override
  String get favorites => 'Favorites';

  @override
  String get guest => 'Guest';

  @override
  String get viewAndEditProfile => 'View and edit profile';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get searchHint => 'Search for a city, neighborhood, or address...';

  @override
  String get exploreAndSearch => 'Explore & Search';

  @override
  String get noApartmentsMatch => 'No apartments match your criteria.';

  @override
  String get filterOptions => 'Filter Options';

  @override
  String get priceRange => 'Price Range';

  @override
  String get minRooms => 'Min. Rooms';

  @override
  String get reset => 'Reset';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String areYouSureDeleteUser(Object fullName) {
    return 'Are you sure you want to permanently delete the user $fullName? This action cannot be undone.';
  }

  @override
  String get accept => 'Accept';

  @override
  String get noPendingUsers => 'No pending users for approval.';

  @override
  String get allUsers => 'All Users';

  @override
  String get noUsersFound => 'No users found in the system.';

  @override
  String get pending => 'Pending';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navMyPlace => 'My Place';

  @override
  String get navBookings => 'Bookings';

  @override
  String get homeScreenTitle => 'Home';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get homeScreenMessage =>
      'Explore apartments or manage your properties using the tabs below.';

  @override
  String welcomeBack(Object name) {
    return 'Welcome back, $name!';
  }

  @override
  String get exploreScreenTitle => 'Explore & Search';

  @override
  String get searchPlaceholder => 'Search places by title...';

  @override
  String get genericFetchError => 'An error occurred. Pull to refresh.';

  @override
  String get noResults => 'No apartments match your criteria.';

  @override
  String get filterSheetTitle => 'Filter Options';

  @override
  String get filterLocation => 'Location';

  @override
  String get filterPriceRange => 'Price Range';

  @override
  String get filterSpecifications => 'Specifications';

  @override
  String get favoritesTitle => 'My Favorites';

  @override
  String get noFavoritesMessage => 'Your favorite places will appear here.';

  @override
  String get resetPasswordSuccess => 'Instructions sent successfully!';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get couldNotLaunchMaps => 'Could not launch maps';

  @override
  String get bookingDetailsUnavailable => 'Booking details are unavailable';

  @override
  String bookingId(Object id) {
    return 'Booking ID: $id';
  }

  @override
  String get bookingRequestSent => 'Request Sent!';

  @override
  String get bookingRequestSentMessage =>
      'Your booking request has been sent to the owner. You can view its status in your bookings list.';

  @override
  String get viewMyBookings => 'View My Bookings';

  @override
  String get status_pending_approval => 'Pending Approval';

  @override
  String get status_confirmed => 'Confirmed';

  @override
  String get status_rejected => 'Rejected';

  @override
  String get status_cancelled => 'Cancelled';

  @override
  String get status_completed => 'Completed';

  @override
  String get sendBookingRequest => 'Send Booking Request';
}

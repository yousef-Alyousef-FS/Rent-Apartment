// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get availableApartments => 'الشقق المتاحة';

  @override
  String get confirmLogout => 'تأكيد تسجيل الخروج';

  @override
  String get areYouSureLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get account => 'الحساب';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get noApartmentsAvailable => 'لا يوجد شقق متاحة حالياً.';

  @override
  String get loadingApartments => 'جاري تحميل الشقق...';

  @override
  String errorOccurred(Object errorMessage) {
    return 'حدث خطأ: $errorMessage';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String rooms(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غرفة',
      many: '$count غرفة',
      few: '$count غرف',
      two: 'غرفتان',
      one: 'غرفة واحدة',
      zero: '٠ غرف',
    );
    return '$_temp0';
  }

  @override
  String get sqm => 'متر مربع';

  @override
  String get description => 'الوصف';

  @override
  String get editApartmentDetails => 'تعديل تفاصيل الشقة';

  @override
  String get price => 'السعر';

  @override
  String get perNight => '/ ليلة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String reviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تقييم',
      many: '$count تقييمًا',
      few: '$count تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
      zero: '٠ تقييمات',
    );
    return '$_temp0';
  }

  @override
  String get completeYourProfile => 'أكمل ملفك الشخصي';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get enterFirstName => 'أدخل اسمك الأول';

  @override
  String get firstNameRequired => 'الاسم الأول مطلوب';

  @override
  String get lastName => 'الاسم الأخير';

  @override
  String get enterLastName => 'أدخل اسمك الأخير';

  @override
  String get lastNameRequired => 'الاسم الأخير مطلوب';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get dobHint => 'YYYY-MM-DD';

  @override
  String get personalPhoto => 'الصورة الشخصية';

  @override
  String get idCardPhoto => 'صورة الهوية';

  @override
  String get selectBothPhotos => 'الرجاء اختيار الصورة الشخصية وصورة الهوية.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get resetYourPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordInstructions =>
      'أدخل رقم الهاتف المرتبط بحسابك، وسنرسل لك التعليمات لإعادة تعيين كلمة المرور.';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get sendResetInstructions => 'إرسال تعليمات إعادة التعيين';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'سجل الدخول لمتابعة استخدام التطبيق...';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get passwordMinLength => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get forgotYourPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟';

  @override
  String get registrationPending => 'التسجيل معلق';

  @override
  String get yourAccountIsUnderReview => 'حسابك قيد المراجعة';

  @override
  String get pendingApprovalMessage =>
      'لقد تم إرسال طلب تسجيلك بنجاح. يرجى الانتظار حتى يقوم المسؤول بالموافقة على حسابك. ستتمكن من تسجيل الدخول بمجرد الموافقة على حسابك.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeToRentalApp => 'مرحباً بك في تطبيق الإيجار';

  @override
  String get findYourNextHome => 'ابحث عن منزلك التالي بكل سهولة.';

  @override
  String get bookingDetails => 'تفاصيل الحجز';

  @override
  String get dates => 'التواريخ';

  @override
  String nights(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ليلة',
      many: '$count ليلة',
      few: '$count ليال',
      two: 'ليلتان',
      one: 'ليلة واحدة',
      zero: '٠ ليال',
    );
    return '$_temp0';
  }

  @override
  String get guests => 'الضيوف';

  @override
  String get priceDetails => 'تفاصيل السعر';

  @override
  String get serviceFee => 'رسوم الخدمة';

  @override
  String get totalPaid => 'المبلغ الإجمالي (بالدولار)';

  @override
  String get getDirections => 'الحصول على الاتجاهات';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get areYouSureCancelBooking =>
      'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancellationError => 'تعذر إلغاء الحجز.';

  @override
  String get cancellationSuccess => 'تم إلغاء الحجز بنجاح.';

  @override
  String get directionsNotAvailable => 'تعذر تشغيل الخرائط، العنوان غير متوفر.';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get checkIn => 'تسجيل الوصول';

  @override
  String get checkOut => 'تسجيل المغادرة';

  @override
  String get costSummary => 'ملخص التكلفة';

  @override
  String get pricePerNightLabel => 'السعر لليلة';

  @override
  String get numberOfNights => 'عدد الليالي';

  @override
  String get totalCost => 'التكلفة الإجمالية';

  @override
  String get confirmAndPay => 'التأكيد والدفع';

  @override
  String get failedToCreateBooking => 'فشل إنشاء الحجز.';

  @override
  String get bookingSuccessful => 'تم الحجز بنجاح!';

  @override
  String get bookingSuccessMessage =>
      'لقد قمت بحجز إقامتك بنجاح. يمكنك عرض التفاصيل في قائمة حجوزاتك.';

  @override
  String get viewBookingDetails => 'عرض تفاصيل الحجز';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get upcoming => 'القادمة';

  @override
  String get completed => 'المكتملة';

  @override
  String get cancelled => 'الملغاة';

  @override
  String get noUpcomingBookings => 'ليس لديك حجوزات قادمة.';

  @override
  String get noCompletedBookings => 'ليس لديك حجوزات مكتملة.';

  @override
  String get noCancelledBookings => 'ليس لديك حجوزات ملغاة.';

  @override
  String get yesCancel => 'نعم، إلغاء';

  @override
  String get addReview => 'إضافة تقييم';

  @override
  String get editBooking => 'تعديل الحجز';

  @override
  String get editBookingNotAvailable => 'هذه الميزة غير متوفرة بعد.';

  @override
  String get total => 'الإجمالي';

  @override
  String get selectNewDates => 'اختر تواريخ جديدة لحجزك في';

  @override
  String get bookingUpdatedSuccess => 'تم تحديث الحجز بنجاح!';

  @override
  String get failedToUpdateBooking => 'فشل تحديث الحجز.';

  @override
  String get updateBooking => 'تحديث الحجز';

  @override
  String get writeReview => 'كتابة تقييم';

  @override
  String get howWasYourStay => 'كيف كانت إقامتك؟';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get yourReview => 'مراجعتك';

  @override
  String get tellUsExperience => 'أخبرنا عن تجربتك...';

  @override
  String get submitReview => 'إرسال التقييم';

  @override
  String get pleaseSelectRating => 'الرجاء اختيار تقييم.';

  @override
  String get pleaseWriteComment => 'الرجاء كتابة تعليق.';

  @override
  String get reviewSubmittedSuccess => 'تم إرسال التقييم بنجاح!';

  @override
  String get failedToSubmitReview => 'فشل إرسال التقييم.';

  @override
  String get getYouStarted => 'هيا بنا نبدأ!';

  @override
  String get createPassword => 'إنشاء كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة!';

  @override
  String get reEnterPassword => 'أعد إدخال كلمة المرور';

  @override
  String get next => 'التالي';

  @override
  String get unexpectedErrorOccurred => 'حدث خطأ غير متوقع.';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get addNewApartment => 'إضافة شقة جديدة';

  @override
  String get basicInformation => 'المعلومات الأساسية';

  @override
  String get title => 'العنوان';

  @override
  String get required => 'مطلوب';

  @override
  String get location => 'الموقع';

  @override
  String get governorate => 'المحافظة';

  @override
  String get city => 'المدينة';

  @override
  String get detailedAddress => 'العنوان التفصيلي';

  @override
  String get specifications => 'المواصفات';

  @override
  String get pricePerNight => 'السعر / الليلة';

  @override
  String get areaSqm => 'المساحة (متر مربع)';

  @override
  String get numberOfRooms => 'عدد الغرف';

  @override
  String get photos => 'الصور';

  @override
  String get pleaseAddOneImage => 'الرجاء إضافة صورة واحدة على الأقل.';

  @override
  String get apartmentAddedSuccess => 'تمت إضافة الشقة بنجاح!';

  @override
  String get failedToAddApartment => 'فشل إضافة الشقة.';

  @override
  String get addApartment => 'إضافة الشقة';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get editApartment => 'تعديل الشقة';

  @override
  String get changesSavedSuccess => 'تم حفظ التغييرات بنجاح!';

  @override
  String get failedToSaveChanges => 'فشل حفظ التغييرات.';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get manageBookingRequest => 'إدارة طلب الحجز';

  @override
  String get renterInformation => 'معلومات المستأجر';

  @override
  String get joined => 'انضم في';

  @override
  String get apartment => 'الشقة';

  @override
  String get totalPayout => 'المبلغ الإجمالي';

  @override
  String get approve => 'موافقة';

  @override
  String get reject => 'رفض';

  @override
  String get actionFailed => 'فشلت العملية، يرجى المحاولة مرة أخرى.';

  @override
  String get couldNotLoadApartments => 'تعذر تحميل شققك.';

  @override
  String get noApartmentsAdded => 'لم تقم بإضافة أي شقق بعد.';

  @override
  String get viewBookings => 'عرض الحجوزات';

  @override
  String get delete => 'حذف';

  @override
  String get confirmDeleteApartment => 'تأكيد الحذف';

  @override
  String get areYouSureDeleteApartment =>
      'هل أنت متأكد أنك تريد حذف هذه الشقة نهائياً؟ سيتم إلغاء جميع الحجوزات المتعلقة بها. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get apartmentDeletedSuccess => 'تم حذف الشقة بنجاح.';

  @override
  String get failedToDeleteApartment => 'فشل حذف الشقة.';

  @override
  String get bookingsFor => 'حجوزات شقة';

  @override
  String get noBookingsForApartment => 'لا يوجد حجوزات لهذه الشقة بعد.';

  @override
  String get bookedBy => 'حجزت بواسطة';

  @override
  String get status => 'الحالة';

  @override
  String get apartmentBookings => 'حجوزات الشقق';

  @override
  String get newRequests => 'الطلبات الجديدة';

  @override
  String get noNewRequests => 'لا يوجد طلبات حجز جديدة.';

  @override
  String get ownerDashboard => 'لوحة تحكم المالك';

  @override
  String get welcomeOwner => 'أهلاً بك أيها المالك!';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get myApartments => 'شقتي';

  @override
  String get ownerProfile => 'ملف المالك';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get businessSettings => 'إعدادات العمل';

  @override
  String get payoutMethods => 'طرق الدفع';

  @override
  String get transactionHistory => 'سجل المعاملات';

  @override
  String get featureNotAvailable => 'هذه الميزة غير متوفرة بعد.';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordUpdatedSuccess => 'تم تحديث كلمة المرور بنجاح!';

  @override
  String get failedToUpdatePassword => 'فشل تحديث كلمة المرور.';

  @override
  String get updatePassword => 'تحديث كلمة المرور';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get failedToUpdateProfile => 'فشل تحديث الملف الشخصي.';

  @override
  String get myReviews => 'تقييماتي';

  @override
  String get noReviewsYet => 'لم تكتب أي تقييمات بعد.';

  @override
  String get reviewOn => 'تقييم على';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get favorites => 'المفضلة';

  @override
  String get guest => 'زائر';

  @override
  String get viewAndEditProfile => 'عرض وتعديل الملف الشخصي';

  @override
  String get notLoggedIn => 'لم يتم تسجيل الدخول';

  @override
  String get searchHint => 'ابحث عن مدينة، حي، أو عنوان...';

  @override
  String get exploreAndSearch => 'استكشف وابحث';

  @override
  String get noApartmentsMatch => 'لا توجد شقق تطابق معاييرك.';

  @override
  String get filterOptions => 'خيارات الفلترة';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get minRooms => 'أدنى عدد غرف';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get applyFilters => 'تطبيق الفلاتر';
}

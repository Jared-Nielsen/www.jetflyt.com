export const ar = {
  translation: {
    // Navigation
    'nav.tenders': 'المناقصات',
    'nav.handling': 'المناولة',
    'nav.fleet': 'الأسطول',
    'nav.reports': 'التقارير',
    'nav.signIn': 'تسجيل الدخول',
    'nav.signOut': 'تسجيل الخروج',

    // Landing Page
    'landing.title': 'إدارة مناقصات وقود الطيران',
    'landing.subtitle': 'تحسين عملية شراء وقود الطيران',
    'landing.auth.signInCta': 'سجل الدخول للوصول ←',
    
    'landing.features.tenders.title': 'تقديم مناقصة',
    'landing.features.tenders.description': 'إنشاء وتقديم عروض عقود الوقود السنوية بسهولة.',
    
    'landing.features.handling.title': 'المناولة الأرضية',
    'landing.features.handling.description': 'تقديم مناقصة لخدمات المناولة الأرضية.',
    
    'landing.features.fleet.title': 'إدارة الأسطول',
    'landing.features.fleet.description': 'تسجيل وإدارة معلومات أسطول طائراتك.',
    
    'landing.features.reports.title': 'التقارير',
    'landing.features.reports.description': 'عرض التحليلات والرؤى حول عملياتك.',

    // Tender Management
    'tenders.title': 'المناقصات',
    'tenders.subtitle': 'إنشاء وإدارة مناقصات الوقود عبر العديد من مشغلي المطارات.',
    'tenders.newTender': 'مناقصة جديدة',
    
    'tenders.status.title': 'الحالة',
    'tenders.status.pending': 'قيد الانتظار',
    'tenders.status.active': 'نشط',
    'tenders.status.accepted': 'مقبول',
    'tenders.status.rejected': 'مرفوض',
    'tenders.status.canceled': 'ملغى',

    'tenders.details.title': 'تفاصيل المناقصة',
    'tenders.details.created': 'تم الإنشاء في',
    'tenders.details.aircraft': 'الطائرة',
    'tenders.details.location': 'الموقع',
    'tenders.details.fuelRequest': 'طلب الوقود',
    'tenders.details.bestPrice': 'أفضل سعر حالي',
    'tenders.details.fboResponses': 'ردود مشغلي المطارات',
    'tenders.details.description': 'الوصف',
    'tenders.details.totalValue': 'القيمة الإجمالية',
    'tenders.details.tenderId': 'رقم المناقصة',

    'tenders.offers.columns.fbo': 'مشغل المطار',
    'tenders.offers.columns.location': 'الموقع',
    'tenders.offers.columns.offerPrice': 'سعر العرض',
    'tenders.offers.columns.totalCost': 'التكلفة الإجمالية',
    'tenders.offers.columns.taxesAndFees': 'الضرائب والرسوم',
    'tenders.offers.columns.finalCost': 'التكلفة النهائية',
    'tenders.offers.columns.actions': 'الإجراءات',

    'tenders.offers.buttons.accept': 'قبول',
    'tenders.offers.buttons.sendContract': 'إرسال العقد',
    'tenders.offers.buttons.close': 'إغلاق',
    'tenders.offers.buttons.cancel': 'إلغاء',

    'tenders.offers.status.canceled': 'ملغى',

    'tenders.offers.modal.contractTitle': 'تأكيد العقد',
    'tenders.offers.modal.contractSent': 'تم إرسال العقد إلى {{fbo}}',

    'tenders.offers.errors.acceptFailed': 'فشل قبول العرض. يرجى المحاولة مرة أخرى.',

    'tenders.offers.noResponses': 'لم يتم العثور على عروض.',
    'tenders.offers.response': 'رد',
    'tenders.offers.responses': 'ردود',

    'tenders.form.title.new': 'إنشاء مناقصة جديدة',
    'tenders.form.title.edit': 'تعديل المناقصة',
    'tenders.form.title.cancel': 'إلغاء المناقصة',

    'tenders.form.fields.aircraft': 'الطائرة',
    'tenders.form.fields.selectAircraft': 'اختر الطائرة',
    'tenders.form.fields.airport': 'المطار',
    'tenders.form.fields.selectAirport': 'اختر المطار',
    'tenders.form.fields.gallons': 'الجالونات المطلوبة',
    'tenders.form.fields.targetPrice': 'السعر المستهدف',
    'tenders.form.fields.annual': 'سنوي',
    'tenders.form.fields.startDate': 'تاريخ البدء',
    'tenders.form.fields.endDate': 'تاريخ الانتهاء (اختياري)',
    'tenders.form.fields.description': 'الوصف',
    'tenders.form.fields.selectFbos': 'اختر مشغلي المطارات',

    'tenders.form.buttons.cancel': 'إلغاء',
    'tenders.form.buttons.create': 'إنشاء المناقصة',
    'tenders.form.buttons.update': 'تحديث المناقصة',
    'tenders.form.buttons.creating': 'جاري الإنشاء...',
    'tenders.form.buttons.edit': 'تعديل',
    'tenders.form.buttons.cancelTender': 'إلغاء المناقصة',
    'tenders.form.buttons.close': 'إغلاق',
    'tenders.form.buttons.keepIt': 'لا، احتفظ بها',
    'tenders.form.buttons.cancelling': 'جاري الإلغاء...',
    'tenders.form.buttons.confirmCancel': 'نعم، إلغاء المناقصة',

    'tenders.form.confirmCancel': 'هل أنت متأكد من رغبتك في إلغاء هذه المناقصة؟ لا يمكن التراجع عن هذا الإجراء.',

    'tenders.form.errors.invalidDates': 'يجب أن يكون تاريخ الانتهاء بعد تاريخ البدء',
    'tenders.form.errors.noFboSelected': 'يرجى اختيار مشغل مطار واحد على الأقل',

    // Ground Handling
    'handling.title': 'خدمات المناولة الأرضية',
    'handling.subtitle': 'إنشاء وإدارة طلبات خدمات المناولة الأرضية.',
    'handling.newServiceTender': 'مناقصة خدمة جديدة',
    'handling.noServiceTenders': 'لم يتم العثور على مناقصات خدمة.',

    'handling.details.title': 'تفاصيل مناقصة الخدمة',
    'handling.details.created': 'تم الإنشاء',
    'handling.details.arrival': 'الوصول',
    'handling.details.departure': 'المغادرة',
    'handling.details.service': 'الخدمة',
    'handling.details.quantity': 'الكمية',
    'handling.details.requestedDate': 'التاريخ المطلوب',
    'handling.details.completedDate': 'تاريخ الإكمال',
    'handling.details.description': 'الوصف',
    'handling.details.passengerInfo': 'معلومات الركاب',
    'handling.details.passengers': 'الركاب',
    'handling.details.crew': 'الطاقم',
    'handling.details.pets': 'الحيوانات الأليفة',

    'handling.list.columns.aircraft': 'الطائرة',
    'handling.list.columns.service': 'الخدمة',
    'handling.list.columns.fboLocations': 'مواقع مشغلي المطارات',
    'handling.list.columns.description': 'الوصف',
    'handling.list.columns.status': 'الحالة',
    'handling.list.fboLocations': 'مواقع مشغلي المطارات',
    'handling.list.fboCount_one': 'مشغل مطار',
    'handling.list.fboCount_other': 'مشغلي مطارات',

    'handling.status.pending': 'قيد الانتظار',
    'handling.status.accepted': 'مقبول',
    'handling.status.inProgress': 'قيد التنفيذ',
    'handling.status.completed': 'مكتمل',
    'handling.status.canceled': 'ملغى',

    'handling.form.title.new': 'إنشاء مناقصة خدمة جديدة',
    'handling.form.title.edit': 'تعديل مناقصة الخدمة',

    'handling.form.fields.aircraft': 'الطائرة',
    'handling.form.fields.selectAircraft': 'اختر الطائرة',
    'handling.form.fields.airport': 'المطار',
    'handling.form.fields.selectAirport': 'اختر المطار',
    'handling.form.fields.service': 'الخدمة',
    'handling.form.fields.selectService': 'اختر الخدمة',
    'handling.form.fields.quantity': 'الكمية',
    'handling.form.fields.description': 'الوصف',
    'handling.form.fields.requestedDate': 'التاريخ المطلوب',
    'handling.form.fields.arrivalDate': 'تاريخ الوصول (اختياري)',
    'handling.form.fields.departureDate': 'تاريخ المغادرة (اختياري)',
    'handling.form.fields.selectFbos': 'اختر مشغلي المطارات',
    'handling.form.fields.passengerCount': 'عدد الركاب',
    'handling.form.fields.crewCount': 'عدد أفراد الطاقم',
    'handling.form.fields.petCount': 'عدد الحيوانات الأليفة',

    'handling.form.buttons.cancel': 'إلغاء',
    'handling.form.buttons.create': 'إنشاء المناقصة',
    'handling.form.buttons.update': 'تحديث المناقصة',
    'handling.form.buttons.edit': 'تعديل',
    'handling.form.buttons.cancelTender': 'إلغاء المناقصة',
    'handling.form.errors.invalidDates': 'يجب أن يكون تاريخ المغادرة بعد تاريخ الوصول',
    'handling.form.errors.noFboSelected': 'يرجى اختيار مشغل مطار واحد على الأقل',
    'handling.form.errors.noRequestedDate': 'التاريخ المطلوب مطلوب',
    'handling.form.errors.submissionFailed': 'فشل تقديم النموذج. يرجى المحاولة مرة أخرى.',

    // Trip Management
    'trip.routes.addRoute': 'إضافة مسار',

    // Activity Logs
    'logs.title': 'سجلات النشاط',
    'logs.subtitle': 'عرض وتتبع التغييرات في المناقصات ومناقصات FBO',
    'logs.tenderLogs': 'سجلات المناقصات',
    'logs.fboTenderLogs': 'سجلات مناقصات FBO',
    'logs.timestamp': 'الوقت والتاريخ',
    'logs.user': 'معرف المستخدم',
    'logs.tender': 'المناقصة',
    'logs.fbo': 'FBO',
    'logs.action': 'الإجراء',
    'logs.changes': 'التغييرات',

    // Footer
    'footer.about.title': 'عن JetFlyt',
    'footer.about.description': 'تحسين عملية شراء وقود الطيران مع حلول مبتكرة لإدارة المناقصات.',
    'footer.quickLinks.title': 'روابط سريعة',
    'footer.quickLinks.fboMap': 'خريطة المشغلين',
    'footer.quickLinks.airports': 'المطارات',
    'footer.quickLinks.dispatch': 'الإرسال',
    'footer.quickLinks.support': 'الدعم',
    'footer.legal.title': 'قانوني',
    'footer.legal.privacy': 'سياسة الخصوصية',
    'footer.legal.terms': 'الشروط والأحكام',
    'footer.contact.title': 'اتصل بنا',
    'footer.contact.contactUs': 'تواصل معنا',
    'footer.copyright': '© {{year}} JetFlyt. جميع الحقوق محفوظة.',

    // Fleet Management
    'fleet.title': 'إدارة الأسطول',
    'fleet.subtitle': 'إدارة معلومات ومواصفات أسطول طائراتك.',
    'fleet.addAircraft': 'إضافة طائرة',
    'fleet.uploadExcel': 'تحميل إكسل',
    'fleet.downloadTemplate': 'تنزيل النموذج',
    'fleet.confirmDelete': 'هل أنت متأكد من رغبتك في حذف هذه الطائرة؟',
    'fleet.uploadSuccess': 'تم تحميل بيانات الطائرة بنجاح',
    'fleet.errors.saveFailed': 'فشل حفظ الطائرة. يرجى المحاولة مرة أخرى.',
    'fleet.errors.deleteFailed': 'فشل حذف الطائرة. يرجى المحاولة مرة أخرى.',
    'fleet.errors.uploadFailed': 'فشل تحميل البيانات. يرجى التحقق من التنسيق والمحاولة مرة أخرى.',

    // Aircraft Details
    'fleet.details.title': 'تفاصيل الطائرة',
    'fleet.details.registration': 'التسجيل',
    'fleet.details.edit': 'تعديل',
    'fleet.details.viewOnMap': 'عرض على الخريطة',
    'fleet.details.aircraftType': 'نوع الطائرة',
    'fleet.details.manufacturer': 'الشركة المصنعة',
    'fleet.details.year': 'السنة',
    'fleet.details.engineType': 'نوع المحرك',
    'fleet.details.fuelType': 'نوع الوقود',
    'fleet.details.fuelCapacity': 'سعة الوقود',
    'fleet.details.maxRange': 'المدى الأقصى',
    'fleet.details.currentLocation': 'الموقع الحالي',
    'fleet.details.locationNotSet': 'لم يتم تحديد الموقع',
    'fleet.details.modelPreview': 'معاينة النموذج ثلاثي الأبعاد',

    // Common
    'common.loading': 'جاري التحميل...',
    'common.close': 'إغلاق',
    'common.notAvailable': 'غير متوفر'
  }
};
// lib/content/site_content.dart
// Uses the single AppLocale from i18n/locale_scope.dart
import '../i18n/locale_scope.dart' show AppLocale;

/// Lightweight i18n helper: given a map {en:..., ar:..., he:...} returns the requested string.
/// Fallback order: requested -> EN -> first available -> "…"
String t(Map<String, String> m, AppLocale locale) {
  // AppLocale is a String like 'en' | 'ar' | 'he' (may also be 'en-US' on web)
  final code = locale.contains('-') ? locale.split('-').first : locale;
  return m[code] ?? m['en'] ?? (m.values.isNotEmpty ? m.values.first : '…');
}

/// ===== Brand/config used across the app =====
class ContentConfig {
  static const brandName = 'Dar al-Fajr';
  static const donateUrl = 'https://example.com/pay'; // TODO
  static const youtubeUrl = 'https://youtube.com/@daralfajr';

  // Bottom row (YouTube, phone, WhatsApp, email)
  static const contactPhone = 'tel:+972501234567'; // main phone
  static const whatsappLink = 'https://wa.me/972501234567'; // main WhatsApp
  static const contactEmail = 'mailto:info@daralfajr.org'; // change if needed
}

/// ===== Home section =====
class HomeContent {
  static const hadith = {
    'en': 'The Prophet (PBUH) said:\n"The best of you are those who learn the Qur\'an and teach it."',
    'ar': 'قال رسول الله ﷺ: «خَيْرُكُمْ مَنْ تَعَلَّمَ القُرْآنَ وَعَلَّمَهُ»',
    'he': 'אמר הנביא (בס״ה): "הטובים בכם הם הלומדים את הקוראן ומלמדים אותו."',
  };

  static const subtitle = {
    'en': 'Join us in our mission to spread knowledge and understanding of the Qur\'an.',
    'ar': 'انضمّ إلينا في رسالتنا نحو جيل قرآني.',
    'he': 'הצטרפו אלינו בשליחות להפיץ ידע והבנה של הקוראן.',
  };

  static Map<String, String> statsLabels(AppLocale l) => {
        'students': t({'en': 'Students', 'ar': 'الطلاب', 'he': 'תלמידים'}, l),
        'weeklyClasses': t({'en': 'Weekly Classes', 'ar': 'دروس أسبوعية', 'he': 'שיעורים שבועיים'}, l),
        'volunteers': t({'en': 'Volunteers', 'ar': 'متطوعون', 'he': 'מתנדבים'}, l),
        'years': t({'en': 'Years Serving', 'ar': 'سنوات خدمة', 'he': 'שנות פעילות'}, l),
      };

  static const statsValues = {
    'students': '110',
    'weeklyClasses': '25',
    'volunteers': '30',
    'years': '2',
  };

  static String donateCta(AppLocale l) => t(
        {'en': 'Donate Now', 'ar': 'تبرّع الآن', 'he': 'לתרומה עכשיו'},
        l,
      );
}

/// ===== About section =====
class AboutContent {
  static const title = {
    'en': 'About Dar al-Fajr',
    'ar': 'عن دار الفجر',
    'he': 'על דאר אל-פג׳ר',
  };

  static const description = {
    'en':
        'Dar al-Fajr is a Quranic education center in Kfar Kama, dedicated to teaching children and youth reading, memorization, and proper recitation of the Qur’an. We run five days a week, with tailored programs from beginners to advanced students, now serving over 110 learners. Our mission is clear: to nurture a generation that loves the Qur’an and lives by its guidance.',
    'ar':
        'دار الفجر هو مركز لتعليم القرآن في كفر كما، مكرّس لتعليم الأطفال والشباب قراءة القرآن وحفظه وتجويده. نعمل خمسة أيام في الأسبوع، مع برامج مخصّصة للمبتدئين والمتقدّمين، ونخدم اليوم أكثر من 110 طالبًا. رسالتنا واضحة: تربية جيل يحب القرآن ويعيش بهديه.',
    'he':
        'דר אל-פג׳ר הוא מרכז ללימודי קוראן בכפר כמא, המוקדש להקניית קריאה, שינון וקריאה נכונה לילדים ולנוער. אנו פועלים חמישה ימים בשבוע, עם תוכניות מותאמות לכל הרמות, ומשרתים כיום מעל 110 תלמידים. השליחות שלנו ברורה: לגדל דור שאוהב את הקוראן וחי על פי הדרכתו.',
  };

  static List<String> pillars(AppLocale l) => [
        t({'en': 'Education', 'ar': 'التعليم', 'he': 'חינוך'}, l),
        t({'en': 'Community', 'ar': 'المجتمع', 'he': 'קהילה'}, l),
        t({'en': 'Service', 'ar': 'الخدمة', 'he': 'שירות'}, l),
      ];
}

/// ===== Donation section =====
class DonationContent {
  static const title = {
    'en': 'Support Dar al-Fajr',
    'ar': 'ادعم دار الفجر',
    'he': 'תמכו בדר אל־פג׳ר',
  };

  static const subtitle = {
    'en': 'Every ayah memorized, every letter recited, adds to the reward of those who support this mission.',
    'ar': 'كل آية يحفظها الطالب، وكل حرف يتلوه، يكون في ميزان حسنات من ساهم في دعمه.',
    'he': 'כל פסוק שנשמר וכל אות שנקראת – נזקפים לזכות מי שתומך בשליחות הזו.',
  };

  static const cardCta = {
    'en': 'Donate by Card',
    'ar': 'تبرّع بالبطاقة',
    'he': 'תרומה בכרטיס אשראי',
  };

  static const bankTitle = {
    'en': 'Bank Transfer',
    'ar': 'تحويل بنكي',
    'he': 'העברה בנקאית',
  };

  // Keep all locales if you sometimes show them; or call: t(DonationContent.bankDetails, 'he')
  static const bankDetails = {
    'en':
        'Bank: 17 – Mercantile Discount\nBranch: HaTavor 695\nAccount Name: Dar al-Fajr Kfar Kama\nAccount Number: 69187',
    'ar': 'البنك: 17 – مركنتיל ديسكونت\nالفرع: التابور 695\nاسم الحساب: دار الفجر كفر كما\nرقم الحساب: 69187',
    'he': 'בנק: 17 - מרכנתיל דיסקונט בע"\nסניף: התבור 695\nשם המוטב: דאר אל פג׳ר כפר כמא\nמספר חשבון: 69187',
  };

  static const copyCta = {
    'en': 'Copy Details',
    'ar': 'نسخ التفاصيل',
    'he': 'העתקת פרטים',
  };

  static const copied = {
    'en': 'Bank details copied',
    'ar': 'تم نسخ التفاصيل البنكية',
    'he': 'פרטי הבנק הועתקו',
  };
}

class BankDetails {
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String iban;
  final String swift;
  const BankDetails({
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.iban,
    required this.swift,
  });

  String asBlock() =>
      'Bank: $bankName\nAccount Name: $accountName\nAccount Number: $accountNumber\nIBAN: $iban\nSWIFT: $swift';
}

/// ===== Photos section (paths only; text is minimal) =====
class PhotosContent {
  // If you want to use this instead of PageView’s generator, list your real assets:
  static const images = <String>[
    'assets/images/image-01.jpg',
    'assets/images/image-02.jpg',
    'assets/images/image-03.jpg',
    'assets/images/image-04.jpg',
    'assets/images/image-05.jpg',
    'assets/images/image-06.jpg',
    'assets/images/image-07.jpg',
    'assets/images/image-08.jpg',
    'assets/images/image-09.jpg',
    'assets/images/image-10.jpg',
  ];
}

/// ===== Contact section =====
class ContactContent {
  static const title = {
    'en': 'Contact Us',
    'ar': 'تواصل معنا',
    'he': 'צרו קשר',
  };

  static const call = {'en': 'Call', 'ar': 'اتصال', 'he': 'שיחה'};
  static const whatsapp = {'en': 'WhatsApp', 'ar': 'واتساب', 'he': 'וואטסאפ'};
  static const youtube = {'en': 'YouTube', 'ar': 'يوتيوب', 'he': 'יוטיוב'};
  static const phone = {'en': 'Phone', 'ar': 'هاتف', 'he': 'טלפון'};
  static const email = {'en': 'Email', 'ar': 'بريد إلكتروني', 'he': 'אימייל'};

  static List<Member> boardMembers = const [
    Member(
      name: 'Aslan Nash',
      role: {'en': 'Center Manager', 'ar': 'مدير المركز', 'he': 'מנהל המרכז'},
      phone: 'tel:+972501234567',
      whatsapp: 'https://wa.me/972501234567',
    ),
    Member(
      name: 'Ahmad Shawgan',
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972501234568',
      whatsapp: 'https://wa.me/972501234568',
    ),
    Member(
      name: 'Noah Thawko',
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972501234568',
      whatsapp: 'https://wa.me/972501234568',
    ),
    Member(
      name: 'Hani Ashmooz',
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972501234568',
      whatsapp: 'https://wa.me/972501234568',
    ),
    Member(
      name: 'Sam Thawko',
      role: {'en': 'Board member', 'ar': 'عضו إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972501234568',
      whatsapp: 'https://wa.me/972501234568',
    ),
  ];
}

class Member {
  final String name;
  final Map<String, String> role; // localized role
  final String? phone; // tel:+972...
  final String? whatsapp; // https://wa.me/972...
  const Member({
    required this.name,
    required this.role,
    this.phone,
    this.whatsapp,
  });

  String roleFor(AppLocale l) => t(role, l);
}

/// ===== Nav labels =====
class NavContent {
  static const home = {'en': 'Home', 'ar': 'الرئيسية', 'he': 'בית'};
  static const about = {'en': 'About', 'ar': 'من نحن', 'he': 'אודות'};
  static const donate = {'en': 'Donate', 'ar': 'تبرّع', 'he': 'תרומה'};
  static const photos = {'en': 'Photos', 'ar': 'صور', 'he': 'תמונות'};
  static const contact = {'en': 'Contact', 'ar': 'تواصل', 'he': 'יצירת קשר'};
}

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
  static const brandNameLocalized = {
    'en': 'Dar al-Fajr',
    'ar': 'دار الفجر',
    'he': 'דאר אל-פג׳ר',
  };

  static const brandLogo = 'assets/images/logo.png';
  static const donateUrl = 'https://pay.sumit.co.il/frrouf/i66g0c/c/payment/';
  static const studentPayUrl = 'https://pay.sumit.co.il/frrouf/i66g6b/c/payment/';

  // Bottom row (YouTube, phone, WhatsApp, email)
  static const contactPhone = 'tel:+972512875576';
  static const whatsappLink = 'https://wa.me/972512875576';
  static const contactEmail = 'mailto:daralfajerkfarkama@gmail.com';
  static const youtubeUrl = 'https://youtube.com/@Dar-al-Fajr';
}

/// ===== Home section =====
class HomeContent {
  static const hadith = {
    'en': '"The best of you are those who learn the Qur\'an and teach it."',
    'ar': 'قال رسول الله ﷺ: «خَيْرُكُمْ مَنْ تَعَلَّمَ القُرْآنَ وَعَلَّمَهُ»',
    'he': '"הטובים שבכם הם הלומדים את הקוראן ומלמדים אותו."',
  };

  static const subtitle = {
    'en': 'Join us in our mission to spread knowledge and understanding of the Qur\'an.',
    'ar': 'انضمّ إلينا في رسالتنا نحو جيل قرآني.',
    'he': 'בואו להיות חלק מהמאמץ להפיץ את הידע וההבנה של הקוראן.',
  };

  static Map<String, String> statsLabels(AppLocale l) => {
        'students': t({'en': 'Students', 'ar': 'طالب', 'he': 'תלמידים'}, l),
        'weeklyClasses': t({'en': 'Weekly Classes', 'ar': 'درس أسبوعي', 'he': 'שיעורים שבועיים'}, l),
        'volunteers': t({'en': 'Volunteers', 'ar': 'متطوع', 'he': 'מתנדבים'}, l),
        'years': t({'en': 'Years Serving', 'ar': 'سنوات خدمة', 'he': 'שנות פעילות'}, l),
      };

  static const statsValues = {
    'students': '110',
    'weeklyClasses': '60',
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
        'Dar al-Fajr is an Islamic education center in Kfar Kama, dedicated to teaching children and youth the reading, memorization, and proper recitation of the Qur’an. In addition to Qur’an studies, we hold weekly lessons that focus on Islamic values, faith, and character - covering topics such as fiqh, ʿaqīdah, and sīrah. Today, Dar al-Fajr serves over 110 students across multiple levels, from beginners to advanced. Our mission is clear: to nurture a generation that loves the Qur’an, understands its message, and lives by its guidance.',
    'ar':
        'دار الفجر هو مركز تعليمي إسلامي في كفر كما، يُعنى بتعليم الأطفال والناشئة قراءة القرآن الكريم وتجويده وحفظه. إلى جانب دروس القرآن، نقيم دروسًا أسبوعية تُعنى بالقيم الإسلامية والإيمان والأخلاق، وتشمل موضوعات في الفقه والعقيدة والسيرة النبوية. يضم المركز اليوم أكثر من 110 طالبًا وطالبة في مستويات مختلفة، من المبتدئين إلى المتقدمين. ورسالتنا واضحة: تربية جيلٍ يحبّ القرآن، يفهم معانيه ويعيش بهديه.',
    'he':
        'דאר אל־פג׳ר הוא מרכז חינוך אסלאמי בכפר כמא, שמוקדש ללימוד קריאה, שינון ותגויד של הקוראן לילדים ולנוער. בנוסף ללימודי הקוראן, אנו מקיימים שיעורים שבועיים בנושאים של ערכים אסלאמיים, אמונה ומידות טובות - כגון פִקְה, עַקִידָה וסִירַה. כיום לומדים במרכז למעלה מ־110 תלמידים ברמות שונות - מהמתחילים ועד המתקדמים. החזון שלנו ברור: לטפח דור שאוהב את הקוראן, מבין את משמעותו וחי לאורו.',
  };

  static List<String> pillars(AppLocale l) => [
        t({'en': 'Education', 'ar': 'تربية', 'he': 'חינוך'}, l),
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
    'he': 'כל פסוק שנשנן וכל אות שנקרא – מוסיפים לשכרם של התומכים בדרך הזאת.',
  };

  static const cardCta = {
    'en': 'Donate by Card',
    'ar': 'تبرّع بالبطاقة',
    'he': 'תרומה בכרטיס אשראי',
  };

  static const studentCta = {
    'en': 'Student Payment',
    'ar': 'دفع رسوم الطالب',
    'he': 'תשלום עבור תלמיד',
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
    'he': 'בנק: 17 - מרכנתיל דיסקונט בע"מ\nסניף: התבור 695\nשם המוטב: דאר אל פג׳ר כפר כמא\nמספר חשבון: 69187',
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
  static const _count = 27;
  static const _dir = 'assets/images';
  static const _prefix = 'image-';
  static const _ext = '.webp';

  static final List<String> images = List.generate(
    _count,
    (i) => '$_dir/$_prefix${(i + 1).toString().padLeft(2, '0')}$_ext',
    growable: false,
  );
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
      name: {'en': 'Aslan Nash', 'ar': 'اسلان ناش', 'he': 'אסלאן נאש'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972532737826',
      whatsapp: 'https://wa.me/972532737826',
    ),
    Member(
      name: {'en': 'Ahmad Shawgan', 'ar': 'أحمد شوجن', 'he': 'אחמד שוגן'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972507864552',
      whatsapp: 'https://wa.me/972507864552',
    ),
    Member(
      name: {'en': 'Noah Thawko', 'ar': 'نوح تحاوخو', 'he': 'נוח תחאוכו'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972506825975',
      whatsapp: 'https://wa.me/972506825975',
    ),
    Member(
      name: {'en': 'Hani Ashmoz', 'ar': 'هاني أشموز', 'he': 'האני אשמוז'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972505213482',
      whatsapp: 'https://wa.me/972505213482',
    ),
    Member(
      name: {'en': 'Sam Thawko', 'ar': 'سام تحاوخو', 'he': 'סאם תחאוכו'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972543046004',
      whatsapp: 'https://wa.me/972543046004',
    ),
    Member(
      name: {'en': 'Othman Shawgan', 'ar': 'عثمان شوجن', 'he': "עות'מאן שוגן"},
      role: {'en': 'Director of Education', 'ar': 'المدير التعليمي', 'he': 'מנהל הלימודים'},
      phone: '',
      whatsapp: '',
    ),
  ];
}

class Member {
  final Map<String, String> name;
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
  String nameFor(AppLocale l) => t(name, l);
}

/// ===== Nav labels =====
class NavContent {
  static const home = {'en': 'Home', 'ar': 'الرئيسية', 'he': 'בית'};
  static const about = {'en': 'About', 'ar': 'من نحن', 'he': 'אודות'};
  static const donate = {'en': 'Donate', 'ar': 'تبرّع', 'he': 'תרומה'};
  static const photos = {'en': 'Photos', 'ar': 'صور', 'he': 'תמונות'};
  static const contact = {'en': 'Contact', 'ar': 'تواصل', 'he': 'יצירת קשר'};
}

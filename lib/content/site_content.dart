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

  static const amutaNumber = '580814747';

  static const amutaBadge = {
    'en': 'Registered Non-Profit #580814747 • Kfar Kama',
    'ar': 'جمعية مسجلة #580814747 • كفر كما',
    'he': 'עמותה רשומה (ע"ר) #580814747 • כפר כמא',
  };

  static const brandLogo = 'assets/images/logo-tr.png';
  static const donateUrl = 'https://pay.sumit.co.il/frrouf/i66g0c/c/payment/';
  static const studentPayUrl = 'https://pay.sumit.co.il/frrouf/i66g6b/c/payment/';

  // Bottom row (YouTube, phone, WhatsApp, email)
  static const contactPhone = 'tel:+972512875576';
  static const whatsappLink = 'https://wa.me/972512875576';
  static const contactEmail = 'mailto:daralfajerkfarkama@gmail.com';
  static const youtubeUrl = 'https://youtube.com/@Dar-al-Fajr';
  static const instagramUrl = 'https://www.instagram.com/dar.alfajr/';
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
    'he': 'הצטרפו ליוזמה להפיץ את הידע וההבנה של הקוראן.',
  };

  static const secondaryCta = {
    'en': 'Our Mission',
    'ar': 'رسالتنا',
    'he': 'החזון שלנו',
  };

  static Map<String, String> statsLabels(AppLocale l) => {
        'students': t({'en': 'Students', 'ar': 'طالب وطالبة', 'he': 'תלמידים ותלמידות'}, l),
        'weeklyClasses': t({'en': 'Weekly Classes', 'ar': 'درس أسبوعي', 'he': 'שיעורים שבועיים'}, l),
        'volunteers': t({'en': 'Volunteers', 'ar': 'متطوع', 'he': 'מתנדבים'}, l),
        'years': t({'en': 'Years Serving', 'ar': 'سنوات خدمة', 'he': 'שנות פעילות'}, l),
      };

  static const statsValues = {
    'students': '180',
    'weeklyClasses': '100',
    'volunteers': '50',
    'years': '3',
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
        'Dar al-Fajr is an Islamic education center in Kfar Kama, dedicated to teaching children and youth the reading, memorization, and proper recitation of the Qur’an. In addition to Qur’an studies, we hold weekly lessons that focus on Islamic values, faith, and character - covering topics such as fiqh, ʿaqīdah, and sīrah. Today, Dar al-Fajr serves over 180 students (boys and girls) across multiple levels, from beginners to advanced. Our mission is clear: to nurture a generation that loves the Qur’an, understands its message, and lives by its guidance.',
    'ar':
        'دار الفجر هو مركز تعليمي إسلامي في كفر كما، يُعنى بتعليم الأطفال والناشئة قراءة القرآن الكريم وتجويده وحفظه. إلى جانب دروس القرآن، نقيم دروسًا أسبوعية تُعنى بالقيم الإسلامية والإيمان والأخلاق، وتشمل موضوعات في الفقه والعقيدة والسيرة النبوية. يضم المركز اليوم أكثر من 180 طالبًا وطالبة في مستويات مختلفة، من المبتدئين إلى المتقدمين. ورسالتنا واضحة: تربية جيلٍ يحبّ القرآن، يفهم معانيه ويعيش بهديه.',
    'he':
        'דאר אל־פג׳ר הוא מרכז חינוך אסלאמי בכפר כמא, שמוקדש ללימוד קריאה, שינון ותגויד של הקוראן לילדים ולנוער. בנוסף ללימודי הקוראן, אנו מקיימים שיעורים שבועיים בנושאים של ערכים אסלאמיים, אמונה ומידות טובות - כגון פִקְה, עַקִידָה וסִירַה. כיום לומדים במרכז למעלה מ־180 תלמידים ותלמידות ברמות שונות - מהמתחילים ועד המתקדמים. החזון שלנו ברור: לטפח דור שאוהב את הקוראן, מבין את משמעותו וחי לאורו.',
  };

  static List<String> pillars(AppLocale l) => [
        t({'en': 'Education', 'ar': 'تربية', 'he': 'חינוך'}, l),
        t({'en': 'Community', 'ar': 'المجتمع', 'he': 'קהילה'}, l),
        t({'en': 'Service', 'ar': 'الخدمة', 'he': 'שירות'}, l),
      ];

  static List<String> pillarDescriptions(AppLocale l) => [
        t(
          {
            'en': 'Structured Qur’an recitation, memorization, and weekly lessons in Islamic values, fiqh, and sīrah.',
            'ar': 'حلقات منهجية لتلاوة القرآن الكريم وحفظه، ودروس أسبوعية في العقيدة والفقه والسيرة النبوية.',
            'he': 'לימוד מובנה של קריאה ושינון הקוראן, לצד שיעורים שבועיים בערכים, אמונה ומידות טובות.',
          },
          l,
        ),
        t(
          {
            'en': 'Strengthening identity, brotherhood, and shared values for over 180 boys and girls in Kfar Kama.',
            'ar': 'تعزيز الهوية والأخوة والقيم المشتركة لأكثر من 180 طالباً وطالبة في كفر كما.',
            'he': 'חיזוק הזהות, האחווה והערכים המשותפים עבור למעלה מ־180 תלמידים ותלמידות בכפר כמא.',
          },
          l,
        ),
        t(
          {
            'en':
                'Powered by 50+ dedicated volunteers nurturing a generation that lives by the guidance of the Qur’an.',
            'ar': 'بجهود أكثر من 50 متطوعاً مخلصاً في تربية جيل يعيش بهدي القرآن الكريم ويخدم مجتمعه.',
            'he': 'מופעל על ידי למעלה מ־50 מתנדבים מסורים המטפחים דור שחי לאורו של הקוראן ותורם לקהילה.',
          },
          l,
        ),
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

  static const recurringBadge = {
    'en': 'Monthly Standing Order (הוראת קבע) Recommended',
    'ar': 'يُوصى بالتبرع الشهري الثابت (הוראת קבע)',
    'he': 'מומלץ להצטרף כשותפים קבועים בהוראת קבע',
  };

  static const cardCta = {
    'he': 'תרומה באשראי / הוראת קבע',
    'ar': 'تبرّع بالبطاقة / تبرّع شهري',
    'en': 'Donate by Card / Monthly',
  };

  static const studentCta = {
    'en': 'Student Payment',
    'ar': 'دفع رسوم الطالب',
    'he': 'תשלום עבור תלמיד',
  };

  static const bankTitle = {
    'en': 'Direct Bank Transfer',
    'ar': 'تحويل بنكي مباشر',
    'he': 'העברה בנקאית',
  };

  // Keep all locales if you sometimes show them; or call: t(DonationContent.bankDetails, 'he')
  static const bankDetails = {
    'en':
        'Bank: 17 – Mercantile Discount\nBranch: HaTavor 695\nAccount Name: Dar al-Fajr Kfar Kama\nAccount Number: 69187',
    'ar': 'البنك: 17 – مركنتيل ديسكونت\nالفرع: التابور 695\nاسم الحساب: دار الفجر كفر كما\nرقم الحساب: 69187',
    'he': 'בנק: 17 - מרכנתיל דיסקונט בע"מ\nסניף: התבור 695\nשם המוטב: דאר אל פג׳ר כפר כמא\nמספר חשבון: 69187',
  };

  static const copyCta = {
    'en': 'Copy All Details',
    'ar': 'نسخ جميع التفاصيل',
    'he': 'העתקת כל הפרטים',
  };

  static const copied = {
    'en': 'Copied to clipboard',
    'ar': 'تم النسخ',
    'he': 'הועתק ללוח',
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

/// ===== Photos section =====
class PhotosContent {
  static const title = {
    'en': 'Campus & Community Gallery',
    'ar': 'معرض صور المركز',
    'he': 'גלריית תמונות מהמרכז',
  };

  static const subtitle = {
    'en': 'Moments from our weekly study circles, student activities, and community gatherings in Kfar Kama.',
    'ar': 'لمحات من حلقات التحفيظ الأسبوعية، أنشطة الطلاب، واللقاءات التربوية في كفر كما.',
    'he': 'רגעים מתוך שיעורי הקוראן, הפעילויות החינוכיות והמפגשים הקהילתיים שלנו בכפר כמא.',
  };

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
    'en': 'Contact us',
    'ar': 'تواصل معنا',
    'he': 'יצירת קשר',
  };

  static const subtitle = {
    'en': 'Contact the center directly during office hours.',
    'ar': 'يمكنكم التواصل مع المركز مباشرة خلال ساعات الدوام.',
    'he': 'ניתן לפנות ישירות למרכז בשעות הפעילות.',
  };

  static const officeHoursTitle = {
    'en': 'Office Hours',
    'ar': 'ساعات السكرتارية',
    'he': 'שעות מזכירות',
  };

  static const officeHoursValue = {
    'en': 'Sunday – Thursday\n16:00 – 18:00',
    'ar': 'الأحد – الخميس\n16:00 – 18:00',
    'he': 'ראשון – חמישי\n16:00 – 18:00',
  };

  static const call = {'en': 'Call', 'ar': 'اتصال', 'he': 'שיחה'};
  static const whatsapp = {'en': 'WhatsApp', 'ar': 'واتساب', 'he': 'וואטסאפ'};
  static const youtube = {'en': 'YouTube', 'ar': 'يوتيوب', 'he': 'יוטיוב'};
  static const instagram = {'en': 'Instagram', 'ar': 'انستاجرام', 'he': 'אינסטגרם'};
  static const phone = {'en': 'Phone', 'ar': 'هاتف', 'he': 'טלפון'};
  static const email = {'en': 'Email', 'ar': 'بريد إلكتروني', 'he': 'אימייל'};

  static const boardSectionTitle = {
    'en': 'Board Members',
    'ar': 'أعضاء إدارة الجمعية',
    'he': 'חברי העמותה',
  };

  static const keyPeopleSectionTitle = {
    'en': 'Key People',
    'ar': 'إدارة المركز',
    'he': 'הנהלת המרכז',
  };

  static List<Member> boardMembers = const [
    Member(
      name: {'en': 'Aslan Nash', 'ar': 'اسلان ناش', 'he': 'אסלאן נאש'},
      role: {'en': 'Chairman of the Board', 'ar': 'مدير الجمعية', 'he': 'מנהל עמותה'},
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
      name: {'en': 'Tawfek Hatukai', 'ar': 'توفيق حاتوقاي', 'he': 'תאופיק חתוקאי'},
      role: {'en': 'Board member', 'ar': 'عضو إدارة', 'he': 'חבר הנהלה'},
      phone: 'tel:+972526034686',
      whatsapp: 'https://wa.me/972526034686',
    ),
  ];

  static List<Member> keyPeople = const [
    Member(
      name: {'en': 'Othman Shawgan', 'ar': 'عثمان شوجن', 'he': "עות'מאן שוגן"},
      role: {'en': 'Director of Education', 'ar': 'مدير مركز التعليم', 'he': 'מנהל מרכז לימודים'},
      phone: '',
      whatsapp: '',
    ),
    Member(
      name: {'en': 'Sana Patuash', 'ar': 'سناء بطواش', 'he': 'סנא פטואש'},
      role: {'en': "Sisters' Center Director", 'ar': 'مديرة مركز الأخوات', 'he': 'מנהלת מרכז נשים/בנות'},
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

/// ===== Footer labels =====
class FooterContent {
  static const tagline = {
    'en': 'Islamic Education & Community Center • Kfar Kama',
    'ar': 'مركز تعليمي إسلامي ومجتمعي • كفر كما',
    'he': 'מרכז חינוך אסלאמי וקהילתי • כפר כמא',
  };

  static const registration = {
    'en': 'Registered Non-Profit Association (Amuta) #580814747',
    'ar': 'جمعية غير ربحية مسجلة رقم 580814747',
    'he': 'עמותה רשומה (ע"ר) מס׳ 580814747',
  };

  static const rights = {
    'en': '© Dar al-Fajr Kfar Kama. All rights reserved.',
    'ar': '© دار الفجر كفر كما. جميع الحقوق محفوظة.',
    'he': '© דאר אל-פג׳ר כפר כמא. כל הזכויות שמורות.',
  };
}



import 'package:flutter/material.dart';

const primaryColor = Colors.brown;
const secondaryColor = Colors.brown;


const List<String> orderTypes = [
  "طلب عام",
  "طلب صيانه",
  "طلب معاينه",
  "طلب تركيب",
];

const List<String> surah = [
  "السورة",
  "1. Al-Fatiha    سورة الفاتحة",
  "2. Al-Baqara    سورة البقرة",
  "3. Aal-e-Imran    سورة آل عمران",
  "4. An-Nisa    سورة النساء",
  "5. Al-Maeda    سورة المائدة",
  "6. Al-Anaam    سورة الأنعام",
  "7. Al-Araf    سورة الأعراف",
  "8. Al-Anfal    سورة الأنفال",
  "9. At-Taubah    سورة التوبة",
  "10. Yunus    سورة يونس",
  "11. Hud    سورة هود",
  "12. Yusuf    سورة يوسف",
  "13. Ar-Rad    سورة الرعد",
  "14. Ibrahim    سورة إبراهيم",
  "15. Al-Hijr    سورة الحجر",
  "16. An-Nahl    سورة النحل",
  "17. Al-Isra    سورة الإسراء",
  "18.Al-Kahf    سورة الكهف",
  "19. Maryam    سورة مريم",
  "20. Taha    سورة طه",
  "21. Al-Anbiya    سورة الأنبياء",
  "22. Al-Hajj    سورة الحج",
  "23. Al-Mumenoon    سورة المؤمنون",
  "24. An-Noor    سورة النور",
  "25. Al-Furqan    سورة الفرقان",
  "26. Ash-Shuara    سورة الشعراء",
  "27. An-Naml    سورة النمل",
  "28. Al-Qasas    سورة القصص",
  "29. Al-Ankaboot    سورة العنكبوت",
  "30. Ar-Room    سورة الروم",
  "31. Luqman    سورة لقمان",
  "32. As-Sajda    سورة السجدة",
  "33. Al-Ahzab    سورة الأحزاب",
  "34. Saba    سورة سبأ",
  "35. Fatir    سورة فاطر",
  "36. Ya Seen    سورة يس",
  "37. As-Saaffat    سورة الصافات",
  "38. Sad    سورة ص",
  "39. Az-Zumar    سورة الزمر",
  "40. Ghafir    سورة غافر",
  "41. Fussilat    سورة فصلت",
  "42. Ash-Shura    سورة الشورى",
  "43. Az-Zukhruf    سورة الزخرف",
  "44. Ad-Dukhan    سورة الدخان",
  "45. Al-Jathiya    سورة الجاثية",
  "46. Al-Ahqaf    سورة الأحقاف",
  "47. Muhammad    سورة محمد",
  "48. Al-Fath    سورة الفتح",
  "49. Al-Hujraat    سورة الحجرات",
  "50. Qaf    سورة ق",
  "51. Adh-Dhariyat    سورة الذاريات",
  "52. At-tur    سورة الطور",
  "53. An-Najm    سورة النجم",
  "54. Al-Qamar    سورة القمر",
  "55. Ar-Rahman    سورة الرحمن",
  "56. Al-Waqia    سورة الواقعة",
  "57. Al-Hadid    سورة الحديد",
  "58. Al-Mujadila    سورة المجادلة",
  "59. Al-Hashr    سورة الحشر",
  "60. Al-Mumtahana    سورة الممتحنة",
  "61. As-Saff    سورة الصف",
  "62. Al-Jumua    سورة الجمعة",
  "63. Al-Munafiqoon    سورة المنافقون",
  "64. At-Taghabun  سورة التغا",
  "65. At-Talaq    سورة الطلاق",
  "66. At-Tahrim    سورة التحريم",
  "67. Al-Mulk    سورة الملك",
  "68. Al-Qalam    سورة القلم",
  "69. Al-Haaqqa    سورة الحاقة",
  "70. Al-Maarij    سورة المعارج",
  "71. Nooh    سورة نوح",
  "72. Al-Jinn    سورة الجن",
  "73. Al-Muzzammil    سورة المزمل",
  "74. Al-Muddathir    سورة المدثر",
  "75. Al-Qiyama    سورة القيامة",
  "76. Al-Insan    سورة الإنسان",
  "77. Al-Mursalat    سورة المرسلات",
  "78. An-Naba    سورة النبأ",
  "79. An-Naziat    سورة النازعات",
  "80. Abasa    سورة عبس",
  "81. At-Takwir    سورة التكوير",
  "82. AL-Infitar    سورة الإنفطار",
  "83. Al-Mutaffifin    سورة المطففين",
  "84. Al-Inshiqaq    سورة الانشقاق",
  "85. Al-Burooj    سورة البروج",
  "86. At-Tariq    سورة الطارق",
  "87. Al-Ala    سورة الأعلى",
  "88. Al-Ghashiya    سورة الغاشية",
  "89. Al-Fajr    سورة الفجر",
  "90. Al-Balad    سورة البلد",
  "91. Ash-Shams    سورة الشمس",
  "92. Al-Lail    سورة الليل",
  "93. Ad-Dhuha    سورة الضحى",
  "94. Al-Inshirah    سورة الشرح",
  "95. At-Tin    سورة التين",
  "96. Al-Alaq    سورة العلق",
  "97. Al-Qadr    سورة القدر",
  "98. Al-Bayyina    سورة البينة",
  "99. Al-Zalzala    سورة الزلزلة",
  "100. Al-Adiyat    سورة العاديات",
  "101. Al-Qaria    سورة القارعة",
  "102. At-Takathur    سورة التكاثر",
  "103. Al-Asr    سورة العصر",
  "104. Al-Humaza    سورة الهمزة",
  "105. Al-fil    سورة الفيل",
  "106. Quraish    سورة قريش",
  "107. Al-Maun    سورة الماعون",
  "108. Al-Kauther    سورة الكوثر",
  "109. Al-Kafiroon    سورة الكافرون",
  "110. An-Nasr    سورة النصر",
  "111. Al-Masadd    سورة المسد",
  "112. Al-Ikhlas    سورة الإخلاص",
  "113. Al-Falaq    سورة الفلق",
  "114. An-Nas    سورة الناس"
];

const List<String> verses = [
  "السورة",
  "الفاتحه",
  "البقره",
  "ال عمران",
  "النساء",
];

const List<String> parts = [
  "الجزء",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
];

const List<Color> states_color = [
  Colors.blue,
  Colors.purple,
  Colors.green,
  Colors.red
];



















































































































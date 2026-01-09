import 'package:book_reader_app/models/book_content/section_1_topic_contant.dart';
import 'package:book_reader_app/models/book_content/section_2_topic_content.dart';
import 'package:book_reader_app/models/book_content/section_3_topic_content.dart';
import 'package:book_reader_app/models/book_content/section_4_topic_content.dart';
import 'package:book_reader_app/models/book_content/section_5_topic_content.dart';
import 'package:book_reader_app/models/book_content/section_6_topic_content.dart';
import 'package:book_reader_app/models/book_content/section_8_topic_content.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'book_content/section_7_topic_content.dart';
import 'new_model.dart';

// ===== Helper to insert contents =====
Future<void> insertSectionsAndTopics(Isar isar) async {
  if (await isar.sections.count() > 0) return;

  // Create Sections
  final section1 = Section()..sTitle = "प्रथम खंड"..sSubTitle = "पंचामृत अभिषेक पाठ एवं दैनिक पूजन"..sImage = "assets/sec_images/sec_1.png";
  final section2 = Section()..sTitle = "द्वितीय खंड"..sSubTitle = "विशेष पूजाएँ"..sImage = "assets/sec_images/sec_2.png";
  final section3 = Section()..sTitle = "तृतीया खंड"..sSubTitle = "आरती"..sImage = "assets/sec_images/sec_3.png";
  final section4 = Section()..sTitle = "चतुर्थ खंड"..sSubTitle = "जैन धर्म की प्रारंभिक जानकारी"..sImage = "assets/sec_images/sec_4.png";
  final section5 = Section()..sTitle = "पंचम खंड"..sSubTitle = "स्तोत्र"..sImage = "assets/sec_images/sec_5.png";
  final section6 = Section()..sTitle = "षष्ठ खंड"..sSubTitle = "सामायिक, प्रतिक्रमण आदि"..sImage = "assets/sec_images/sec_6.png";
  final section7 = Section()..sTitle = "सप्तम खंड"..sSubTitle = "चालीसा"..sImage = "assets/sec_images/sec_7.png";
  final section8 = Section()..sTitle = "अष्टम खंड"..sSubTitle = "भजन"..sImage = "assets/sec_images/sec_8.png";

  await isar.writeTxn(() async {
    // Save sections first to generate IDs
    final sectionIds = await isar.sections.putAll([section1, section2, section3, section4, section5, section6, section7, section8]);
    section1.sId = sectionIds[0];
    section2.sId = sectionIds[1];
    section3.sId = sectionIds[2];
    section4.sId = sectionIds[3];
    section5.sId = sectionIds[4];
    section6.sId = sectionIds[5];
    section7.sId = sectionIds[6];
    section8.sId = sectionIds[7];

    // In 1st Section there are 19 Topics ✅
    final topicsSection1 = [
      Topic()..tName = "णमोकार मंत्र"..tTranslateName = "Namokar Mantra"..sId = section1.sId,
      Topic()..tName = "देवदर्शन विधि"..tTranslateName = "Dev Darshan Vidhi"..sId = section1.sId,
      Topic()..tName = "मंगलाष्टकम्"..tTranslateName = "Mangalashtakam"..sId = section1.sId,
      Topic()..tName = "देव दर्शन स्तोत्र"..tTranslateName = "Dev Darshan Stotra"..sId = section1.sId,
      Topic()..tName = "दर्शन स्तुति"..tTranslateName = "Darshan Stuti"..sId = section1.sId,
      Topic()..tName = "दिग्बंधन एवं सकलीकरण"..tTranslateName = "Digbandhan and Sakalikarana"..sId = section1.sId,
      Topic()..tName = "पंचामृत अभिषेक का महत्व"..tTranslateName = "Panchamrit Abhishek Ka Mahatva"..sId = section1.sId,
      Topic()..tName = "गर्भ कल्याणक पाठ एवं जन्मकल्याणक पाठ"..tTranslateName = "Garbha Kalyanak Path Evam Janmakalyanak Path"..sId = section1.sId,
      Topic()..tName = "पंचामृत अभिषेक पाठ"..tTranslateName = "Panchamrit Abhishek Path"..sId = section1.sId,
      Topic()..tName = "महा शांतिधारा"..tTranslateName = "Maha Shanti Dhara"..sId = section1.sId,
      Topic()..tName = "विनय पाठ"..tTranslateName = "Vinay Path"..sId = section1.sId,
      Topic()..tName = "पूजा का महत्व"..tTranslateName = "Puja Ka Mahatva"..sId = section1.sId,
      Topic()..tName = "पूजा प्रारंभ विधि"..tTranslateName = "Puja Prarambh Vidhi"..sId = section1.sId,
      Topic()..tName = "नवदेवता पूजन"..tTranslateName = "Navdevta Pujan"..sId = section1.sId,
      Topic()..tName = "देव-शास्त्र-गुरु पूजा"..tTranslateName = "Dev Shastra Guru Puja"..sId = section1.sId,
      Topic()..tName = "अर्घावली"..tTranslateName = "Ardhavali"..sId = section1.sId,
      Topic()..tName = "शांति पाठ (हिन्दी)"..tTranslateName = "Shanti Path (Hindi)"..sId = section1.sId,
      Topic()..tName = "शांति पाठ (संस्कृत)"..tTranslateName = "Shanti Path (Sanskrit)"..sId = section1.sId,
      Topic()..tName = "स्तुति (तुम तरन तारन...)"..tTranslateName = "Stuti (Tum Taran Taran...)"..sId = section1.sId,
    ];

    // In 2nd Section there are 66 Topics
    final topicsSection2 = [
      Topic()..tName = "णमोकार महामंत्र पूजा"..tTranslateName = "Namokar Mahamantra Pooja"..sId = section2.sId,
      Topic()..tName = "देव पूजा"..tTranslateName = "Dev Pooja"..sId = section2.sId,
      Topic()..tName = "गुरु पूजा"..tTranslateName = "Guru Pooja"..sId = section2.sId,
      Topic()..tName = "देव-शास्त्र-गुरु पूजा"..tTranslateName = "Dev Shastra Guru Pooja"..sId = section2.sId,
      Topic()..tName = "श्री सिद्धचक्र पूजा हिन्दी"..tTranslateName = "Shri Siddhachakra Puja Hindi"..sId = section2.sId,
      Topic()..tName = "सिद्ध पूजा- संस्कृत (ऊर्ध्वाधोरयुतं सबिन्दु...)"..tTranslateName = "Sidhh pooja sanskrit"..sId = section2.sId,
      Topic()..tName = "श्री विद्यमान बीस तीर्थंकर पूजा (द्वीप अढाई मेरु...)"..tTranslateName = "Shri Viddhman bis tirhtkar pooja"..sId = section2.sId,
      Topic()..tName = "नित्यमह पूजा (अरिहंतों को नमस्कार...)"..tTranslateName = "Nityamaha Pooja"..sId = section2.sId,
      Topic()..tName = "समुच्चय चौबीसी जिन पूजा (वृषभ अजित संभव...)"..tTranslateName = "Samuchaya Chaubisi Jin Puja"..sId = section2.sId,
      Topic()..tName = "तीस चौबीसी पूजा (पाँच भरत...)"..tTranslateName = "Tis Chaubisi Puja"..sId = section2.sId,

      Topic()..tName = "श्री आदिनाथ जिन पूजा (नाभिराय मरुदेवी के नंदन...)"..tTranslateName = "Shri Adinath Jina Puja"..sId = section2.sId,
      Topic()..tName = "श्री ज्येष्ठ जिनवर पूजा (नाभिराय कुल मंडन...)"..tTranslateName = "Shri Jyestha Jinvar Puja"..sId = section2.sId,
      Topic()..tName = "श्री सुमतिनाथ जिन पूजा (श्रीसुमति तीर्थंकर जगत में...)"..tTranslateName = "Shri Sumatinath Jina Puja"..sId = section2.sId,
      Topic()..tName = "श्री पद्मप्रभ जिन पूजा बाड़ा (श्रीधरन नंदन पद्मप्रभु...)"..tTranslateName = "Shri Padmaprabhu Jin Pooja Bada"..sId = section2.sId,
      Topic()..tName = "श्री चंद्रप्रभ जिन पूजा (चारु चरण...)"..tTranslateName = "Shri Chandraprabh Jin Puja (Charu Charan...)"..sId = section2.sId,
      Topic()..tName = "श्री चंद्रप्रभ जिन पूजा (देहरा तिजारा)"..tTranslateName = "Shri Chandraprabh Jin Puja (Dehra Tijara)"..sId = section2.sId,
      Topic()..tName = "श्री चंद्रप्रभ जिन पूजा (शुभ अतिशय...)"..tTranslateName = "Shri Chandraprabh Jin Puja (Subh Atisay...)"..sId = section2.sId,
      Topic()..tName = "श्री पुष्पदंत जिन पूजा (पुष्पदंत भगवंत संत...)"..tTranslateName = "Shri Pushpadant Jin Puja ("..sId = section2.sId,
      Topic()..tName = "श्री शीतलनाथ जिन पूजा (शीतलनाथ नमो धरी...)"..tTranslateName = "Shri Sheetalnath Jin puja"..sId = section2.sId,
      Topic()..tName = "श्री वासुपूज्य जिन पूजा (श्रीमत वासुपूज्य जिनवर पद...)"..tTranslateName = "Shri Vasupujya Jin puja"..sId = section2.sId,

      Topic()..tName = "श्री शांतिनाथ जिन पूजा (या भव कानन...)"..tTranslateName = "Shri Shantinath Jin Puja"..sId = section2.sId,
      Topic()..tName = "श्री मुनिसुव्रत जिन पूजा पैठण (विघ्न हरण मंगल...)"..tTranslateName = "Shri Munisuvrata Jin puja paithan"..sId = section2.sId,
      Topic()..tName = "श्री नेमिनाथ जिन पूजा (जैतिजै...)"..tTranslateName = "Shri Neminath Jin puja"..sId = section2.sId,
      Topic()..tName = "श्री कलिकुण्ड पार्श्वनाथ जिन पूजा (भाषा)"..tTranslateName = "Shri Kalikunda Parshvanath Jin puja"..sId = section2.sId,
      Topic()..tName = "श्री पार्श्वनाथ जिन पूजा (वर स्वर्ग प्रणत को...)"..tTranslateName = "Sri Parsvnath Jin Puja"..sId = section2.sId,
      Topic()..tName = "श्री रविव्रत पूजा (यह भविजन हितकार...)"..tTranslateName = "Shri Ravivrata Puja"..sId = section2.sId,
      Topic()..tName = "श्री विघ्नहर पार्श्वनाथ अतिशय क्षेत्र महुआ की पूजा (महुआ नगर विराजते...)"..tTranslateName = "Shri Vighnahar Parshvanath Atishay Shri Vighnahar Parshvanath Atishay ki puja"..sId = section2.sId,
      Topic()..tName = "श्री महावीर जिन पूजा (श्रीमत वीर हरें...)"..tTranslateName = "Sri Mahaveer Jin Puja"..sId = section2.sId,
      Topic()..tName = "श्री त्रय जिनेन्द्र पूजा (चंद्रप्रभु शांतिनाथ महावीर...)"..tTranslateName = "Sri Traya Jinendra Puja"..sId = section2.sId,
      Topic()..tName = "श्री सिद्ध यंत्र या विनायक यंत्र पूजा (परमेष्ठिन ! जगत्राण...)"..tTranslateName = "Sri Siddha Yantra or Vinayaka Yantra Puja"..sId = section2.sId,

      Topic()..tName = "श्री ऋषिमंडल पूजा भाषा (चौबीस जिन पद प्रथम...)"..tTranslateName = "Shri Rishi Mandal Puja bhasha"..sId = section2.sId,
      Topic()..tName = "नवग्रह अरिष्ट निवारक विधान स्तोत्र एवं जाप्य मंत्र (प्रणम्याद्यन्त तीर्थेशं...)"..tTranslateName = "Navagraha Arishta Nivaraka Vidhan Stotra and Japya Mantra"..sId = section2.sId,
      Topic()..tName = "सूर्य ग्रह अरिष्ट निवारक श्री पद्मप्रभ पूजा"..tTranslateName = "Surya grah arista nivarak Shri Padmaprabha Puja"..sId = section2.sId,
      Topic()..tName = "चंद्र ग्रह अरिष्ट निवारक श्री चंद्रप्रभ पूजा"..tTranslateName = "Chandra grah arista nivarak Shri Chandraprabh Puja"..sId = section2.sId,
      Topic()..tName = "मंगल ग्रह अरिष्ट निवारक श्री वासुपूज्य पूजा"..tTranslateName = "Mangal grah arista nivarak Shri Vasupujya Puja"..sId = section2.sId,
      Topic()..tName = "बुध ग्रह अरिष्ट निवारक अष्ट जिन पूजा"..tTranslateName = "Budh grah arista nivarak asta Jin Puja"..sId = section2.sId,
      Topic()..tName = "गुरु ग्रह अरिष्ट निवारक अष्ट जिन पूजा"..tTranslateName = "Guru grah arista nivarak asta Jin Puja"..sId = section2.sId,
      Topic()..tName = "शुक्र ग्रह अरिष्ट निवारक श्री पुष्पदंत पूजा"..tTranslateName = "Shukra grah arista nivarak Shri Pushpadanta Puja"..sId = section2.sId,
      Topic()..tName = "शनि ग्रह अरिष्ट निवारक श्री मुनिसुव्रत पूजा"..tTranslateName = "Shani grah arista nivarak Shri Munisuvrata Puja"..sId = section2.sId,
      Topic()..tName = "राहु ग्रह अरिष्ट निवारक श्री नेमिनाथ जिन पूजा"..tTranslateName = "Rahu grah arista nivarak Shri Neminatha Jin Puja"..sId = section2.sId,

      Topic()..tName = "केतु ग्रह अरिष्ट निवारक श्री मल्ली-पार्श्वनाथ जिनपूजा"..tTranslateName = "Ketu grah arista nivarak Shri Malli-Parshvanath Jin puja"..sId = section2.sId,
      Topic()..tName = "श्री सम्मेद शिखर पूजा विधान (सिद्ध क्षेत्र तीरथ)"..tTranslateName = "Shri Sammed Shikhar Puja Vidhan"..sId = section2.sId,
      Topic()..tName = "श्री सप्तऋषि पूजा (प्रथम नाम...)"..tTranslateName = "Shri Saptarishi Pooja"..sId = section2.sId,
      Topic()..tName = "चौंसठ ऋद्धि पूजा (संसार सकल...)"..tTranslateName = "Chaushath Riddhi Puja"..sId = section2.sId,
      Topic()..tName = "श्री शांतिसागर महाराज की पूजा (श्री शांति सिंधु आचार्य...)"..tTranslateName = "of Shri Shantisagar Maharaj ki puja"..sId = section2.sId,
      Topic()..tName = "निर्वाण क्षेत्र पूजा (परम पूज्य चौबीस...)"..tTranslateName = "Nirvana Kshetra Puja"..sId = section2.sId,
      Topic()..tName = "सरस्वती पूजा (जनम जरा मृत्यु छय...)"..tTranslateName = "Saraswati Puja"..sId = section2.sId,
      Topic()..tName = "रक्षाबंधन पर्व पूजा श्री विष्णुकुमार मुनि एवं श्री अकम्पनाचार्य मुनि (जय अकम्पनाचार्य आदि..)"..tTranslateName = "Raksha Bandhan puja Shri Vishnukumar Muni and Shri Akampanacharya Muni"..sId = section2.sId,
      Topic()..tName = "नंदीश्वर द्वीप पूजा (सरब परव में बड़ो...)"..tTranslateName = "Nandishwar Puja"..sId = section2.sId,
      Topic()..tName = "पंचमेरु पूजा (तीर्थंकरों के न्हवन ...)"..tTranslateName = "Panchmeru Puja"..sId = section2.sId,

      Topic()..tName = "सोलह कारण पूजा (सोलहकारण भाय...)"..tTranslateName = "Solah Karan Puja"..sId = section2.sId,
      Topic()..tName = "दशलक्षण पूजा (उत्तम क्षमा मार्दव...)"..tTranslateName = "Dashalakshan Puja"..sId = section2.sId,
      Topic()..tName = "सुगंध दशमी व्रत पूजा (सुगंध दशमी...)"..tTranslateName = "Sugandha Dashami vrat pooja ("..sId = section2.sId,
      Topic()..tName = "अनंत व्रत पूजा (श्री जिनराज चतुर्दश...)"..tTranslateName = "Anant Vrat Puja"..sId = section2.sId,
      Topic()..tName = "रत्नत्रय पूजा (चहुँ गति फनि...)"..tTranslateName = "Ratnatraya Puja"..sId = section2.sId,
      Topic()..tName = "सम्यग्दर्शन पूजा (सिद्ध अष्ट गुणमय...)"..tTranslateName = "Samyagdarshan Puja"..sId = section2.sId,
      Topic()..tName = "सम्यग्ज्ञान पूजा (पंच भेद...)"..tTranslateName = "Samyagyan puja"..sId = section2.sId,
      Topic()..tName = "सम्यक्चारित्र पूजा (विषय रोग...)"..tTranslateName = "Samyakcharitra Puja"..sId = section2.sId,
      Topic()..tName = "गौतम गणधर पूजा (गणपति गणीश गणेश...)"..tTranslateName = "Gautam Gandhar Puja"..sId = section2.sId,
      Topic()..tName = "केवलज्ञान महालक्ष्मी पूजा (कैवल्यज्ञान...)"..tTranslateName = "Kevalgyan Mahalakshmi Puja"..sId = section2.sId,

      Topic()..tName = "वीर निर्वाण संवत्सर पूजा (नव वर्ष की पूजा)"..tTranslateName = "Veer Nirvana Samvatsara Puja"..sId = section2.sId,
      Topic()..tName = "महालक्ष्मी माता पूजा (हे लक्ष्मी माता...)"..tTranslateName = "Mahalakshmi Mata Puja"..sId = section2.sId,
      Topic()..tName = "श्री प‌द्मावती माता की गोद भरने का भजन एवं विधि"..tTranslateName = "Shri Padmavati Mata vidhi"..sId = section2.sId,
      Topic()..tName = "श्री प‌द्मावती की पूजा (जगजीवन को...)"..tTranslateName = "Sri Padmavati puja"..sId = section2.sId,
      Topic()..tName = "श्री क्षेत्रपाल की पूजा (क्षेत्रपालाय...)"..tTranslateName = "Sri Kshetrapala Ki Puja"..sId = section2.sId,
      Topic()..tName = "निर्वाण काण्ड (भाषा) (वीतराग वन्दो...)"..tTranslateName = "Nirvana Kand"..sId = section2.sId,
      Topic()..tName = "हवन विधि"..tTranslateName = "Havan Vidhi"..sId = section2.sId,
      Topic()..tName = "जाप मंत्र, ध्यान बीज मंत्र आदि"..tTranslateName = "Jap mantra, dhyan etc."..sId = section2.sId,
      Topic()..tName = "प्रभु पोंखण विधि"..tTranslateName = "Prabhu Ponkhan Vidhi"..sId = section2.sId,
    ];

    // In 3rd Section there are 18 Topics ✅
    final topicsSection3 = [
      Topic()..tName = "श्री आदिनाथ भगवान की आरती"..tTranslateName = "Shree Aadinath Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री सुमतिनाथ भगवान की आरती"..tTranslateName = "Shree Sumatinath Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री चंद्रप्रभ भगवान की आरती"..tTranslateName = "Shree Chandraprabh Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री शांतिनाथ भगवान की आरती"..tTranslateName = "Shree Shantinath Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री पार्श्वनाथ भगवान की आरती"..tTranslateName = "Shree Parshwanath Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री महावीर भगवान की आरती"..tTranslateName = "Shree Mahavir Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री पंच परमेष्ठी की आरती"..tTranslateName = "Shree Panch Parmeshthi Ki Aarti"..sId = section3.sId,
      Topic()..tName = "श्री अरिहंत भगवान की आरती"..tTranslateName = "Shree Arihant Bhagwan Ki Aarti"..sId = section3.sId,
      Topic()..tName = "नंदीश्वर की आरती"..tTranslateName = "Nandishwar Ki Aarti"..sId = section3.sId,
      Topic()..tName = "दशलक्ष्मण की आरती"..tTranslateName = "Dashlakshman Ki Aarti"..sId = section3.sId,
      Topic()..tName = "चौबीस तीर्तकर की आरती"..tTranslateName = "Chaubis Tirthakara Ki Aarti"..sId = section3.sId,
      Topic()..tName = "जिनवाणी की आरती"..tTranslateName = "Jinvani Ki Aarti"..sId = section3.sId,
      Topic()..tName = "गुरुवर की आरती"..tTranslateName = "Guruvar Ki Aarti"..sId = section3.sId,
      Topic()..tName = "प‌द्मावती की आरती"..tTranslateName = "Padmavati Ki Aarti"..sId = section3.sId,
      Topic()..tName = "क्षेत्रपाल की आरती"..tTranslateName = "Kshetrapal Ki Aarti"..sId = section3.sId,
      Topic()..tName = "पंचकल्याणक की आरती"..tTranslateName = "Panchkalyanak Ki Aarti"..sId = section3.sId,
      Topic()..tName = "निर्वाण क्षेत्र की आरती"..tTranslateName = "Nirvan Keshtra Ki Aarti"..sId = section3.sId,
      Topic()..tName = "दीपावली पूजन विधि"..tTranslateName = "Dipavali Poojan Vidhi"..sId = section3.sId,
    ];

    // In 4th Section there are 17 Topics
    final topicsSection4 = [
      Topic()..tName = "णमोकार मंत्र"..tTranslateName = "Namokaar mantr"..sId = section4.sId,
      Topic()..tName = "णमोकार महामंत्र का अर्थ एवं विशेषताएँ"..tTranslateName = "Namokaar Mahaamantr Ka Arth Evan Visheshataen"..sId = section4.sId,
      Topic()..tName = "जैन दर्शन की विशेषताएँ"..tTranslateName = "Jain Darshan Ki Visheshataen"..sId = section4.sId,
      // Topic()..tName = "कर्म सिद्धांत"..tTranslateName = "Karma Shiddhant"..sId = section4.sId,
      // Topic()..tName = "षट् काल परिवर्तन एवं काल व लंबाई संबंधी माप"..tTranslateName = "Shatkal Parivartan evam kal..."..sId = section4.sId,
      // Topic()..tName = "जैन पर्व"..tTranslateName = "Jain Parva"..sId = section4.sId,
      // Topic()..tName = "शलाका पुरुष एवं अन्य महापुरुष"..tTranslateName = "Shalaka Purusha Evam Anya Mahapurush"..sId = section4.sId,
      // Topic()..tName = "सम्यग्दर्शन का महत्व एवं उसकी विशेषताएँ"..tTranslateName = "Samyagdarshan Ka Mahatva Evam Uski Visheshataen"..sId = section4.sId,
      // Topic()..tName = "लोकाकाश"..tTranslateName = "Lokaakaash"..sId = section4.sId,
      // Topic()..tName = "ढाई द्वीप"..tTranslateName = "Dhai Dhvipa"..sId = section4.sId,
      // Topic()..tName = "नंदीश्वर द्वीप"..tTranslateName = "NandiShwara Dhvipa"..sId = section4.sId,
      // Topic()..tName = "समवशरण एवं दिव्य ध्वनि"..tTranslateName = "Samavsharan evam divya dhvani"..sId = section4.sId,
      // Topic()..tName = "जैन धर्म के विशेष चिन्ह"..tTranslateName = "Jain Dharma ke Vishesh Chinh"..sId = section4.sId,
      // Topic()..tName = "तीर्थकर की विशेषताएँ एवं भूत, वर्तमान ओर भविष्य के चौबीस तीर्थकर"..tTranslateName = "Bhut, vartman oor bhavishya Ke Chaubis Tirthakara"..sId = section4.sId,
      // Topic()..tName = "जिनवाणी के बारह अंग एवं चार अनुयोग"..tTranslateName = "Jinvani ke barah aang"..sId = section4.sId,
      // Topic()..tName = "श्रावक की षट आवश्यक क्रियाएँ"..tTranslateName = "Shrvak Kee Shat Aavashyak Kriyaem"..sId = section4.sId,
      // Topic()..tName = "सामायिक एवं प्रतिक्रमण का महत्व"..tTranslateName = "Samayik Evam Pratikraman ka mahatva"..sId = section4.sId,
    ];

    // In 5th Section there are 18 Topics
    final topicsSection5 = [
      Topic()..tName = "श्री भक्तामर स्तोत्र"..tTranslateName = "Shree Bhaktamar Stotra "..sId = section5.sId,
      Topic()..tName = "विपत्ति नाशक चंद्रप्रभ स्तोत्र"..tTranslateName = "Vipatti Nashak Chandraprabh Stotra"..sId = section5.sId,
      // Topic()..tName = "लघु सहस्रनाम स्तोत्र एवं अर्थ"..tTranslateName = "Laghu Sahasranama Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "तत्त्वार्थ सूत्र"..tTranslateName = "Tattvarth Sutra"..sId = section5.sId,
      // Topic()..tName = "लघु तत्त्वार्थ सूत्र एवं अर्थ"..tTranslateName = "Laghu Tattvarth Sutra evam arth"..sId = section5.sId,
      // Topic()..tName = "नवग्रह शांति स्तोत्र एवं अर्थ"..tTranslateName = "Navagraha Shanti Stotra"..sId = section5.sId,
      // Topic()..tName = "विषापहार स्तोत्र- भाषा"..tTranslateName = "Vishaapahar Stotra Bhasha"..sId = section5.sId,
      // Topic()..tName = "वज्र पंजर स्तोत्र"..tTranslateName = "Vajra Panjar Stotra"..sId = section5.sId,
      // Topic()..tName = "गणधर वलय स्तोत्र एवं अर्थ"..tTranslateName = "Gandhar Valaya Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "कल्याण मंदिर स्तोत्र एवं अर्थ"..tTranslateName = "Kalyan Mandir Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "पार्श्वनाथ स्तोत्र एवं अर्थ"..tTranslateName = "Parsvnath Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "उवसग्गहर स्तोत्र एवं अर्थ"..tTranslateName = "Uvasaggahara Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "महावीराष्टक स्तोत्र एवं अर्थ"..tTranslateName = "Mahavirashtaka Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "ऋषिमंडल स्तोत्र एवं अर्थ"..tTranslateName = "Rishimandala Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "ऋषिमंडल स्तोत्र भाषा"..tTranslateName = "Rishimandal Stotra Bhasha"..sId = section5.sId,
      // Topic()..tName = "सरस्वती स्तोत्र एवं अर्थ"..tTranslateName = "Saraswati Stotra evam arth"..sId = section5.sId,
      // Topic()..tName = "लक्ष्मी स्तोत्र"..tTranslateName = "Lakshmi Stotra"..sId = section5.sId,
      // Topic()..tName = "श्री जैन रक्षा स्तोत्र"..tTranslateName = "Shri Jain Raksha Stotra"..sId = section5.sId,
    ];

    // In 6th Section there are 12 Topics ✅
    final topicsSection6 = [
      Topic()..tName = "सामायिक पाठ भाषा"..tTranslateName = "Samayik Paath Bhasha"..sId = section6.sId,
      Topic()..tName = "लघु प्रतिक्रमण"..tTranslateName = "Laghu Pratikraman"..sId = section6.sId,
      Topic()..tName = "आलोचना पाठ"..tTranslateName = "Alochana Paath"..sId = section6.sId,
      Topic()..tName = "बारह भावना"..tTranslateName = "Baarah Bhavna"..sId = section6.sId,
      Topic()..tName = "बारह भावना (बड़ी)"..tTranslateName = "Baarah Bhavna (badi)"..sId = section6.sId,
      Topic()..tName = "वैराग्य भावना (दिन रात मेरे स्वामी...)"..tTranslateName = "Vairagya bhavna"..sId = section6.sId,
      Topic()..tName = "समाधि भावना"..tTranslateName = "Samadhi Bhavana (Din raat mere swami...)"..sId = section6.sId,
      Topic()..tName = "समाधि भक्ति (तेरी छत्रछाया में...)"..tTranslateName = "Samadhi Bhakti (Teri Chhtrachhaya me...)"..sId = section6.sId,
      Topic()..tName = "बड़ा समाधिमरण (भाषा) (वंदो श्री अरहंत...)"..tTranslateName = "Bada Samadhimaran"..sId = section6.sId,
      Topic()..tName = "मेरी भावना"..tTranslateName = "Meri Bhavana"..sId = section6.sId,
      Topic()..tName = "भावना बत्तीसी (प्रेम भाव हो सब जीवों से...)"..tTranslateName = "Bhavana Battisi (Prem bhav ho sab jivo se...)"..sId = section6.sId,
      Topic()..tName = "संकट मोचन विनती (हो दीनबंधु श्रीपति...)"..tTranslateName = "Sankat Mochan Vinti (Ho dinabandhu shripati...)"..sId = section6.sId,
    ];

    // In 7th Section there are 10 Topics ✅
    final topicsSection7 = [
      Topic()..tName = "श्री आदिनाथ चालीसा"..tTranslateName = "Shree Aadinath Chalisha"..sId = section7.sId,
      Topic()..tName = "श्री सुमतिनाथ चालीसा"..tTranslateName = "Shree Sumatinath Chalisha"..sId = section7.sId,
      Topic()..tName = "श्री पद्मप्रभ चालीसा"..tTranslateName = "Shree Padmaprabh Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री चंद्रप्रभ चालीसा तिजारा"..tTranslateName = "Shree Chandraprabh Chalisa Tijara"..sId = section7.sId,
      Topic()..tName = "श्री पुष्पदंत चालीसा"..tTranslateName = "Shree Pushpadant Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री वासुपूज्य चालीसा"..tTranslateName = "Shree Vasupujya Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री शांतिनाथ चालीसा"..tTranslateName = "Shree Shantinath Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री मुनिसुव्रत चालीसा"..tTranslateName = "Shree Munisuvrat Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री पार्श्वनाथ चालीसा"..tTranslateName = "Shree Parshvanath Chalisa"..sId = section7.sId,
      Topic()..tName = "श्री महावीर चालीसा"..tTranslateName = "Shree Mahavir Chalisa"..sId = section7.sId,
    ];

    // In 8th Section there are 23 Topics ✅
    final topicsSection8 = [
      Topic()..tName = "भक्ति करता छूटे"..tTranslateName = "Bhakti karta chhute"..sId = section8.sId,
      Topic()..tName = "चंद्रप्रभु स्वामी"..tTranslateName = "Chandrabhu Swami"..sId = section8.sId,
      Topic()..tName = "पूर्ण पूजन हुआ"..tTranslateName = "Purna Pujan Hua"..sId = section8.sId,
      Topic()..tName = "तुमसे लगी लगन"..tTranslateName = "Tumse Lagi Lagan"..sId = section8.sId,
      Topic()..tName = "इस जग से मुझको पार करो"..tTranslateName = "Is Jag Se Mujhko Paar Karo"..sId = section8.sId,
      Topic()..tName = "नंदीश्वर रास"..tTranslateName = "Nandishwar Ras"..sId = section8.sId,
      Topic()..tName = "श्री सिद्धचक्र का पाठ करो"..tTranslateName = "Shree Siddhachakra Ka Paath Karo"..sId = section8.sId,
      Topic()..tName = "रंग मा रंग मा रंग मारे"..tTranslateName = "Rang Ma Rang Ma Rang Ma Re"..sId = section8.sId,
      Topic()..tName = "शास्त्र स्तुति (माता तू दया करके...)"..tTranslateName = "Shastra Stuti (Mata Tu Daya Karke...)"..sId = section8.sId,
      Topic()..tName = "शास्त्र स्तुति (हे शारदे माँ...)"..tTranslateName = "Shastra Stuti (He Sharade Maa...)"..sId = section8.sId,
      Topic()..tName = "जिनवाणी स्तुति (मिथ्यातम नाशवे को...)"..tTranslateName = "Jinvani Stuti (Mithyatam Nashve Ko...)"..sId = section8.sId,
      Topic()..tName = "जिनवाणी स्तुति (वीर हिमाचल ते निकसी...)"..tTranslateName = "Jinvani Stuti (Veer Himachal Te Niksi...)"..sId = section8.sId,
      Topic()..tName = "श्री वीरनाथ की स्तुति"..tTranslateName = "Shri Veernath Ki Stuti"..sId = section8.sId,
      Topic()..tName = "मोक्ष के प्रेमी"..tTranslateName = "Moksha ke premi"..sId = section8.sId,
      Topic()..tName = "किसी के काम जो आए..."..tTranslateName = "Kisi Ke Kaam Jo Aaye..."..sId = section8.sId,
      Topic()..tName = "कभी प्यासे को पानी पिलाया नहीं..."..tTranslateName = "Kabhi Pyase Ko Pani Pilaya Nahi..."..sId = section8.sId,
      Topic()..tName = "आ फूलों रोज"..tTranslateName = "Aa Phoolo Roj..."..sId = section8.sId,
      Topic()..tName = "घट-घट जीवन ज्योति"..tTranslateName = "Ghat ghat jivan jyoti"..sId = section8.sId,
      Topic()..tName = "गुरु भजन (ओ गुरु सा...)"..tTranslateName = "Guru bhajan (oo guru sa...)"..sId = section8.sId,
      Topic()..tName = "भजन (मेरे सिर पे रख दो...)"..tTranslateName = "Bhajan (Mere sir pe rakh do...)"..sId = section8.sId,
      Topic()..tName = "भजन (मुनिवर आज मेरी कुटिया .... सब तेरो केशरिया लाल...)"..tTranslateName = "Bhajan (munivar aaj meri kutiya.... sab tere keshariya lal...)"..sId = section8.sId,
      Topic()..tName = "गरबा (मारो धन्य बन्यो...)"..tTranslateName = "Garba (maro dhanya banyo...)"..sId = section8.sId,
      Topic()..tName = "गरबा (साथीया पुरावो आज...)"..tTranslateName = "Garba (sathiya puravo aaj...)"..sId = section8.sId,
    ];


    // Save topics
    await isar.topics.putAll([...topicsSection1, ...topicsSection2, ...topicsSection3, ...topicsSection4, ...topicsSection5, ...topicsSection6, ...topicsSection7, ...topicsSection8]);

    // Insert 1st section's contents
    await _insertTopicContents(isar, topicsSection1[0], namokarJson);
    await _insertTopicContents(isar, topicsSection1[1], devDarshanVidhiJson);
    await _insertTopicContents(isar, topicsSection1[2], mangalJson);
    await _insertTopicContents(isar, topicsSection1[3], devDarshanJson);
    await _insertTopicContents(isar, topicsSection1[4], darshanStutiJson);
    await _insertTopicContents(isar, topicsSection1[5], digbandhanJson);
    await _insertTopicContents(isar, topicsSection1[6], panchamrutJson);
    await _insertTopicContents(isar, topicsSection1[7], garbhKalynakJson);
    await _insertTopicContents(isar, topicsSection1[8], panchamrutAbhishekJson);
    await _insertTopicContents(isar, topicsSection1[9], mahaShantiDharaJson);
    await _insertTopicContents(isar, topicsSection1[10], vinayPathJson);
    await _insertTopicContents(isar, topicsSection1[11], poojaMahtvaJson);
    await _insertTopicContents(isar, topicsSection1[12], poojaPrarambhJson);
    await _insertTopicContents(isar, topicsSection1[13], navDevtaJson);
    await _insertTopicContents(isar, topicsSection1[14], devShastraGuruPoojaJson);
    await _insertTopicContents(isar, topicsSection1[15], ardhavliJson);
    await _insertTopicContents(isar, topicsSection1[16], shantiHindiJson);
    await _insertTopicContents(isar, topicsSection1[17], shantiSanskritJson);
    await _insertTopicContents(isar, topicsSection1[18], stutiJson);
    // Insert 2nd section's contents
    await _insertTopicContents(isar, topicsSection2[0], namokarMantraJson);
    await _insertTopicContents(isar, topicsSection2[1], devPoojaJson);
    // Insert 3rd section's contents
    await _insertTopicContents(isar, topicsSection3[0], adinathAartiJson);
    await _insertTopicContents(isar, topicsSection3[1], sumatinathAartiJson);
    await _insertTopicContents(isar, topicsSection3[2], chandraPrabhAartiJson);
    await _insertTopicContents(isar, topicsSection3[3], shantinathAartiJson);
    await _insertTopicContents(isar, topicsSection3[4], parshwanathAartiJson);
    await _insertTopicContents(isar, topicsSection3[5], mahavirAartiJson);
    await _insertTopicContents(isar, topicsSection3[6], panchParmesthiJson);
    await _insertTopicContents(isar, topicsSection3[7], arihantAartiJson);
    await _insertTopicContents(isar, topicsSection3[8], nandishawerAartiJson);
    await _insertTopicContents(isar, topicsSection3[9], dashLakshmanAartiJson);
    await _insertTopicContents(isar, topicsSection3[10], chobisTirthkarAartiJson);
    await _insertTopicContents(isar, topicsSection3[11], jinvaniAartiJson);
    await _insertTopicContents(isar, topicsSection3[12], guruvarAartiJson);
    await _insertTopicContents(isar, topicsSection3[13], padmavatiJson);
    await _insertTopicContents(isar, topicsSection3[14], kshetrapalAartiJson);
    await _insertTopicContents(isar, topicsSection3[15], panchKalyanakAartiJson);
    await _insertTopicContents(isar, topicsSection3[16], nirvanKhetraAartiJson);
    await _insertTopicContents(isar, topicsSection3[17], dipawaliVidhiJson);
    // Insert 4th section's contents
    await _insertTopicContents(isar, topicsSection4[0], mangalJson4);
    await _insertTopicContents(isar, topicsSection4[1], mangalJson4);
    // Insert 5th section's contents
    /*await _insertTopicContents(isar, topicsSection5[0], mangalJson5);
    await _insertTopicContents(isar, topicsSection5[1], mangalJson5);*/
    // Insert 6th section's contents
    await _insertTopicContents(isar, topicsSection6[0], samayikPathJson);
    await _insertTopicContents(isar, topicsSection6[1], laghuPratikamanJson);
    await _insertTopicContents(isar, topicsSection6[2], aalochnaPathJson);
    await _insertTopicContents(isar, topicsSection6[3], barahJson);
    await _insertTopicContents(isar, topicsSection6[4], barahbadiJson);
    await _insertTopicContents(isar, topicsSection6[5], vairagyaBhavnaJson);
    await _insertTopicContents(isar, topicsSection6[6], samadhiJson);
    await _insertTopicContents(isar, topicsSection6[7], samadhiBhaktiJson);
    await _insertTopicContents(isar, topicsSection6[8], badaSamadhiKaranJson);
    await _insertTopicContents(isar, topicsSection6[9], meriBhavnaJson);
    await _insertTopicContents(isar, topicsSection6[10], bhavnaBattisiJson);
    await _insertTopicContents(isar, topicsSection6[11], sankatMochanJson);
    // Insert 7th section's contents
    await _insertTopicContents(isar, topicsSection7[0], aadinathChalishaJson);
    await _insertTopicContents(isar, topicsSection7[1], sumatiNathChalishaJson);
    await _insertTopicContents(isar, topicsSection7[2], padmprabhChalishaJson);
    await _insertTopicContents(isar, topicsSection7[3], chandraPrabhChalishaJson);
    await _insertTopicContents(isar, topicsSection7[4], pushpDantChalishaJson);
    await _insertTopicContents(isar, topicsSection7[5], vasuPujyaChalishaJson);
    await _insertTopicContents(isar, topicsSection7[6], shantiNathChalishaJson);
    await _insertTopicContents(isar, topicsSection7[7], munisvratChalishaJson);
    await _insertTopicContents(isar, topicsSection7[8], parshwNathChalishaJson);
    await _insertTopicContents(isar, topicsSection7[9], mahavirChalishaJson);

    // Insert 8th section's contents
    await _insertTopicContents(isar, topicsSection8[0], bhaktikartaJson);
    await _insertTopicContents(isar, topicsSection8[1], ChandraprabhuswamiJson);
    await _insertTopicContents(isar, topicsSection8[2], prunaPoojanJson);
    await _insertTopicContents(isar, topicsSection8[3], tumselagilaganJson);
    await _insertTopicContents(isar, topicsSection8[4], isjagseJson);
    await _insertTopicContents(isar, topicsSection8[5], nandishwarrasJson);
    await _insertTopicContents(isar, topicsSection8[6], shreesidhchakarkapathkaroJson);
    await _insertTopicContents(isar, topicsSection8[7], rangmarangmarangJson);
    await _insertTopicContents(isar, topicsSection8[8], matatudayakarkeJson);
    await _insertTopicContents(isar, topicsSection8[9], heyshardeymaJson);
    await _insertTopicContents(isar, topicsSection8[10], jinvanishurttiJson);
    await _insertTopicContents(isar, topicsSection8[11], virhimachaltenikasiJson);
    await _insertTopicContents(isar, topicsSection8[12], virnathkisuthiJson);
    await _insertTopicContents(isar, topicsSection8[13], mokashkrpremiJson);
    await _insertTopicContents(isar, topicsSection8[14], kisikekamjoayeJson);
    await _insertTopicContents(isar, topicsSection8[15], kabhipyasekopanipilayanahiJson);
    await _insertTopicContents(isar, topicsSection8[16], aafullowrojJson);
    await _insertTopicContents(isar, topicsSection8[17], ghatGhatJivanJoytiJson);
    await _insertTopicContents(isar, topicsSection8[18], guruBhjanJson);
    await _insertTopicContents(isar, topicsSection8[19], mereSirPeRakhDoJson);
    await _insertTopicContents(isar, topicsSection8[20], munivarAajMeriKutiyaJson);
    await _insertTopicContents(isar, topicsSection8[21], garbamarodhanyJson);
    await _insertTopicContents(isar, topicsSection8[22], garboSathiyaPuravoAajJson);

  });
}


Future<void> _insertTopicContents(Isar isar, Topic topic, List<Map<String, dynamic>> jsonList) async {
  final contents = jsonList.map((item) {
    return Content()
      ..cText = item['text']?.toString() ?? ''
      ..cBold = item['bold'] == true
      ..cAlign = item['align']?.toString() ?? 'justify'
      ..cImage = item['image']?.toString() // ✅ Optional image
      ..tId = topic.tId;
  }).toList();

  await isar.contents.putAll(contents);
}


/// Store Slider Images in DB
Future<void> insertImages(Isar isar) async {
  final count = await isar.imageModels.count();
  if (count > 0) return; // prevent duplicate insert

  final imagePaths = [
    "assets/home_images/1 (1).jpeg",
    "assets/home_images/2 2.jpg",
    "assets/home_images/3 2.jpg",
    "assets/home_images/4.jpeg",
    "assets/home_images/5.jpg",
    "assets/home_images/6 2.jpg",
    "assets/home_images/7.jpg",
    "assets/home_images/8.jpg",
  ];

  await isar.writeTxn(() async {
    for (var path in imagePaths) {
      await isar.imageModels.put(ImageModel()..imagePath = path);
    }
  });
}

/// Get Stored Images from DB
Future<List<String>> getImages() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([ImageModelSchema], directory: dir.path);
  final images = await isar.imageModels.where().findAll();
  await isar.close();
  return images.map((img) => img.imagePath).toList();
}



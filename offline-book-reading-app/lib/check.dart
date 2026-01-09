// // ===== Helper to insert contents =====
// import 'package:book_reader_app/models/new_model.dart';
// import 'package:isar/isar.dart';
//
// import 'models/book_content/section_1_topic_contant.dart';
// import 'models/book_content/section_2_topic_content.dart';
// import 'models/book_content/section_3_topic_content.dart';
// import 'models/book_content/section_4_topic_content.dart';
// import 'models/book_content/section_5_topic_content.dart';
// import 'models/book_content/section_6_topic_content.dart';
// import 'models/book_content/section_7_topic_content.dart';
// import 'models/book_content/section_8_topic_content.dart';
//
// Future<void> insertSectionsAndTopics(Isar isar) async {
//   if (await isar.sections.count() > 0) return;
//
//   // Create Sections
//   final section1 = Section()..sTitle = "प्रथम खंड"..sSubTitle = "पंचामृत अभिषेक पाठ एवं दैनिक पूजन"..sImage = "assets/sec_images/sec_1.png";
//   final section2 = Section()..sTitle = "द्वितीय खंड"..sSubTitle = "विशेष पूजाएँ"..sImage = "assets/sec_images/sec_2.png";
//   final section3 = Section()..sTitle = "तृतीया खंड"..sSubTitle = "आरती"..sImage = "assets/sec_images/sec_3.png";
//   final section4 = Section()..sTitle = "चतुर्थ खंड"..sSubTitle = "जैन धर्म की प्रारंभिक जानकारी"..sImage = "assets/sec_images/sec_4.png";
//   final section5 = Section()..sTitle = "पंचम खंड"..sSubTitle = "स्तोत्र"..sImage = "assets/sec_images/sec_5.png";
//   final section6 = Section()..sTitle = "षष्ठ खंड"..sSubTitle = "सामायिक, प्रतिक्रमण आदि"..sImage = "assets/sec_images/sec_6.png";
//   final section7 = Section()..sTitle = "सप्तम खंड"..sSubTitle = "चालीसा"..sImage = "assets/sec_images/sec_7.png";
//   final section8 = Section()..sTitle = "अष्टम खंड"..sSubTitle = "भजन"..sImage = "assets/sec_images/sec_8.png";
//
//   await isar.writeTxn(() async {
//     // Save sections first to generate IDs
//     final sectionIds = await isar.sections.putAll([section1, section2, section3, section4, section5, section6, section7, section8]);
//     section1.sId = sectionIds[0];
//     section2.sId = sectionIds[1];
//     section3.sId = sectionIds[2];
//     section4.sId = sectionIds[3];
//     section5.sId = sectionIds[4];
//     section6.sId = sectionIds[5];
//     section7.sId = sectionIds[6];
//     section8.sId = sectionIds[7];
//
//     // In 1st Section there are 19 Topics
//     final topicsSection1 = [
//       Topic()..tName = "णमोकार मंत्र"..tTranslateName = "Namokar Mantra"..sId = section1.sId,
//       Topic()..tName = "देवदर्शन विधि"..tTranslateName = "Dev Darshan Vidhi"..sId = section1.sId,
//       ...
//     ];
//
//     // In 2nd Section there are 66 Topics
//     final topicsSection2 = [
//       Topic()..tName = "णमोकार महामंत्र पूजा"..tTranslateName = "Namokar Mahamantra Pooja"..sId = section2.sId,
//       ...
//     ];
//
//     // In 3rd Section there are 14 Topics
//     final topicsSection3 = [
//       Topic()..tName = "श्री आदिनाथ भगवान की आरती"..tTranslateName = "Shree Aadinath Bhagwan Ki Aarti"..sId = section3.sId,
//       ...
//     ];
//
//     // In 4th Section there are 16 Topics
//     final topicsSection4 = [
//       Topic()..tName = "णमोकार महामंत्र का अर्थ एवं विशेषताएँ"..tTranslateName = "Namokaar Mahaamantr Ka Arth Evan Visheshataen"..sId = section4.sId,
//       Topic()..tName = "जैन दर्शन की विशेषताएँ"..tTranslateName = "Jain Darshan Ki Visheshataen"..sId = section4.sId,
//       ...
//     ];
//
//     // In 5th Section there are 18 Topics
//     final topicsSection5 = [
//       Topic()..tName = "श्री भक्तामर स्तोत्र"..tTranslateName = "Shree Bhaktamar Stotra "..sId = section5.sId,
//      ...
//     ];
//
//     // In 6th Section there are 13 Topics
//     final topicsSection6 = [
//       Topic()..tName = "सामायिक पाठ भाषा"..tTranslateName = "Samayik Paath Bhasha"..sId = section6.sId,
//       ...
//     ];
//
//     // In 7th Section there are 10 Topics
//     final topicsSection7 = [
//       Topic()..tName = "श्री आदिनाथ चालीसा"..tTranslateName = "Shree Aadinath Chalisha"..sId = section7.sId,
//       Topic()..tName = "श्री सुमतिनाथ चालीसा"..tTranslateName = "Shree Sumatinath Chalisha"..sId = section7.sId,
//       ...
//     ];
//
//     // In 8th Section there are 17 Topics
//     final topicsSection8 = [
//       Topic()..tName = "भक्ति करता छूटे"..tTranslateName = "Bhakti karta chhute"..sId = section8.sId,
//       ...
//     ];
//
//
//     // Save topics
//     await isar.topics.putAll([...topicsSection1, ...topicsSection2, ...topicsSection3, ...topicsSection4, ...topicsSection5, ...topicsSection6, ...topicsSection7, ...topicsSection8]);
//
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection1[0], namokarJson);
//     await _insertTopicContents(isar, topicsSection1[1], devDarshanVidhiJson);
//     await _insertTopicContents(isar, topicsSection1[2], mangalJson);
//     await _insertTopicContents(isar, topicsSection1[3], devDarshanJson);
//     await _insertTopicContents(isar, topicsSection1[4], darshanStutiJson);
//     await _insertTopicContents(isar, topicsSection1[5], digbandhanJson);
//     await _insertTopicContents(isar, topicsSection1[6], panchamrutJson);
//     await _insertTopicContents(isar, topicsSection1[7], garbhKalynakJson);
//     await _insertTopicContents(isar, topicsSection1[8], panchamrutAbhishekJson);
//     await _insertTopicContents(isar, topicsSection1[9], mahaShantiDharaJson);
//     await _insertTopicContents(isar, topicsSection1[10], vinayPathJson);
//     await _insertTopicContents(isar, topicsSection1[11], poojaMahtvaJson);
//     await _insertTopicContents(isar, topicsSection1[12], poojaPrarambhJson);
//     await _insertTopicContents(isar, topicsSection1[13], navDevtaJson);
//     await _insertTopicContents(isar, topicsSection1[14], devShastraGuruPoojaJson);
//     await _insertTopicContents(isar, topicsSection1[15], ardhavliJson);
//     await _insertTopicContents(isar, topicsSection1[16], shantiHindiJson);
//     await _insertTopicContents(isar, topicsSection1[17], shantiSanskritJson);
//     await _insertTopicContents(isar, topicsSection1[18], stutiJson);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection2[0], namokarMantraJson);
//     await _insertTopicContents(isar, topicsSection2[1], devPoojaJson);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection3[0], adinathAartiJson);
//     await _insertTopicContents(isar, topicsSection3[1], sumatinathAartiJson);
//     await _insertTopicContents(isar, topicsSection3[2], chandraPrabhAartiJson);
//     await _insertTopicContents(isar, topicsSection3[3], shantinathAartiJson);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection4[0], mangalJson4);
//     await _insertTopicContents(isar, topicsSection4[1], mangalJson4);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection5[0], mangalJson5);
//     await _insertTopicContents(isar, topicsSection5[1], mangalJson5);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection6[0], mangalJson6);
//     await _insertTopicContents(isar, topicsSection6[1], mangalJson6);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection7[0], mangalJson7);
//     await _insertTopicContents(isar, topicsSection7[1], mangalJson7);
//     // Insert section 1 contents
//     await _insertTopicContents(isar, topicsSection8[0], mangalJson8);
//     await _insertTopicContents(isar, topicsSection8[1], mangalJson8);
//   });
// }
//
//
// Future<void> _insertTopicContents(Isar isar, Topic topic, List<Map<String, dynamic>> jsonList) async {
//   final contents = jsonList.map((item) {
//     return Content()
//       ..cText = item['text']?.toString() ?? ''
//       ..cBold = item['bold'] == true
//       ..cAlign = item['align']?.toString() ?? 'justify'
//       ..cImage = item['image']?.toString() // ✅ Optional image
//       ..tId = topic.tId;
//   }).toList();
//
//   await isar.contents.putAll(contents);
// }
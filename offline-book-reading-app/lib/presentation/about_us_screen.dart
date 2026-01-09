import 'package:book_reader_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AboutUsScreen extends StatelessWidget {
  final Isar isar;
  const AboutUsScreen({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {
        'location': 'बोरिवली (मुंबई)',
        'names': [
          'श्रीमती दीपाली राहुल शाह, 98201 84796',
          'श्रीमती जयती अरिजय शाह, 98194 07038',
        ],
      },
      {
        'location': 'कांदिवली (मुंबई)',
        'names': ['श्रीमती नीता देवेन्द्र परीख, 97697 74244'],
      },
      {
        'location': 'सूरत',
        'names': [
          'श्रीमती डिम्पल निलेश मास्टर, 98791 74886',
          'श्रीमती पल्लवी संदीप मोदी, 99255 10000',
        ],
      },
      {
        'location': 'भरुच',
        'names': ['श्रीमती जागृति निलेश चोकसी, 94266 53024'],
      },
      {
        'location': 'बरोडा',
        'names': ['श्रीमती हीना नयन जैन, 98983 41704'],
      },
      {
        'location': 'अहमदाबाद',
        'names': ['श्रीमती नेहल कमलेश शाह, 93746 98126'],
      },
      {
        'location': 'रतलाम',
        'names': ['श्रीमती पूजा हार्दिक शाह, 99264 30777'],
      },
      {
        'location': 'उदयपुर',
        'names': ['श्रीमती प्रियंका अरुण मिंडा, 97833 72311'],
      },
      {
        'location': 'इंदौर',
        'names': ['श्रीमती सोनाली अनंत शाह, 62699 99111'],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('About DevPooja App', style: TextStyle(fontWeight: FontWeight.w700),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Centered top text
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '–: संकलनकर्ता एवं प्रकाशक :–',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appBlack
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'स्व. श्री पत्रालाल रायचंद शाह परिवार\n‘जम्बूद्वीप’, बैंक कॉलोनी, रतलाम (म.प्र.)',
                style: TextStyle(
                  color: appBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(
                  'प्राप्ति स्थान : ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appBlack
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),

          // Contact list
          ...List.generate(
            contacts.length,
                (index) {
              final item = contacts[index];
              final names = item['names'] as List<String>? ?? [];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${item['location']}',
                      style: TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...names.map(
                          (name) => Text(
                        name,
                        style: TextStyle(color: appBlack, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

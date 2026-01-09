import 'package:flutter/material.dart';

class ThirdContent extends StatelessWidget {
  const ThirdContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dream Home Level Agent  \nWhy Use a Dream Home Level Agent\n',
                style: TextStyle(color: Colors.grey[700], fontSize: 17),
              ),

              //Text('Why Use a RealStoria Level Agent ?',style: TextStyle(color: Colors.grey[700],fontSize: 17)),
              SizedBox(
                height: 5,
              ),
              Text(
                  "Why Use a Dream Home Level Agent and Sales teams of Dream Home's Network are licensed real estate professionals who specialize "
                  "in selling residential properties and new construction projects. They are expects in sales and marketing in particular locations and frequently have"
                  "access to multiple sources and qualified prospects that are not available to the individual purchaser.   ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 17)),
              SizedBox(
                height: 15,
              ),
              Text(
                  'They will provide you with an unparalleled quality of service and also extensive knowledge about market trends,local information and real estate opportunities to buy,sell,invest and rent estate.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 17)),
              SizedBox(
                height: 15,
              ),
              Text(
                  "Dream Home's client benefit from their in dept local expertise in technology to make it even easier to build a custom plan for buyer and sellers to meet their goals. ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 17)),
              SizedBox(
                height: 15,
              ),
              Text('Call Your Local Dream Home Level Agent Today!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 17)),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Why Dream Home.com',
                      style: TextStyle(color: Colors.grey[700], fontSize: 17))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'The Real Estate Market Place for Everybody.Source for Real Estate Services. Homes For Sales,Luxury and Waterfront Properties and Market Information.'
                'Dream Home.com is a customer oriented website for real estate listings for sale and rent, local information about local areas,market prices and new construction project. '
                'In partnership with The Ved & Dev Group at value and quality we are committed toproviding value and quality service ti our clients.'
                'Our Success is build on Our values and integrity on every aspect of real estate transaction. We strive to partner with top local agents only that share our commitment to the highest'
                'industry standards and business practices.',
                style: TextStyle(color: Colors.grey[700], fontSize: 17),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Disclaimer',
                      style: TextStyle(color: Colors.grey[700], fontSize: 17))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Local Real Estate Services Provided By : Charles Rutenberg Realty LLC,Address : 2201 W  Dream Homes Tower ,#200,Dream Home, DM 33309, The Ved & Dev Group,Telephone 26-255-473, 27-614-535,'
                'Information deemed RELIABLE but not GUARANTEED, Website owned and Provided by RealStoria Network.',
                style: TextStyle(color: Colors.grey[700], fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '* We are continually working and improving the user experience for people with disabilities and applying relevant accessibility standards to ensuring digital accessibility for everyone.',
                style: TextStyle(color: Colors.grey[700], fontSize: 17),
              )
            ],
          ),
        ),
      ],
    );
  }
}

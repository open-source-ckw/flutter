
import 'dart:convert';

const addToCartCnt = 'add_to_cart';
const cOPTIONS = 'OPTION';
const key = 'consumer_key=ck_b5ec0da1ca6d02240f9f0dfef0a3b72295d33492&consumer_secret=cs_0d569a96d2b06abb1ef706c5b3bb7dec44a7be3a';

String mainBannerImg = 'https://wpdemo.thatsend.app/wp-content/uploads/2023/03/Main-section.jpg';
String noImg = 'https://wpdemo.thatsend.app/wp-content/uploads/2023/03/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg';

/// Custom API ........

const userCustomMainApiURL = 'https://wpdemo.thatsend.app/wp-json/custom/';

/// Wordpress API ......

String administrativeUsername = 'admin';
String administrativePassword = 'admin@333';
String administrativeBasicAuth = 'Basic ' + base64Encode(utf8.encode('$administrativeUsername:$administrativePassword'));

const wordpressAPIURL = 'https://wpdemo.thatsend.app/wp-json/wp/v2/';
// fashionia.thatsend.app

/// Woocommerce API .......

const String wcScheme = 'https';
const wcHost = 'wpdemo.thatsend.app';
const wcPath = '/wp-json/wc/v3/';
const wcConsumerKey = 'ck_b5ec0da1ca6d02240f9f0dfef0a3b72295d33492';
const wcConsumerSecret = 'cs_0d569a96d2b06abb1ef706c5b3bb7dec44a7be3a';

/// Payment key
const String RAZORPAY_API_KEY = 'rzp_test_LUVEXC27QYZGZs';
const String RAZORPAY_SECRET_KEY = 'bPjFU7fId7U9ZD9LcWpe037q';

const currency = '₹';

/// Important support for company
const companyScheme = 'https';
const companyHost = 'thatsend.com';
const companyPath = '/post-project/';
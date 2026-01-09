class SubscriptionPlans {
  String SP_ID;
  String sp_name;
  String sp_description;
  String sp_duration;
  String sp_durationin;
  String sp_currency;
  double sp_price;
  int sp_discount;
  double sp_discountedPrice;

  SubscriptionPlans({
    required this.SP_ID,
    required this.sp_name,
    required this.sp_description,
    required this.sp_duration,
    required this.sp_durationin,
    required this.sp_currency,
    required this.sp_price,
    required this.sp_discount,
    required this.sp_discountedPrice,
  });

  @override
  String toString() {
    return 'SubscriptionPlans{SP_ID: $SP_ID, sp_name: $sp_name, sp_description: $sp_description, sp_duration: $sp_duration, sp_durationin: $sp_durationin, sp_currency: $sp_currency, sp_price: $sp_price, sp_discount: $sp_discount, sp_discountedPrice: $sp_discountedPrice}';
  }

  SubscriptionPlans.fromJson(Map<String, dynamic> json)
      : SP_ID = json['SP_ID'],
        sp_name = json['sp_name'],
        sp_description = json['sp_description'],
        sp_duration = json['sp_duration'],
        sp_durationin = json['sp_durationin'],
        sp_currency = json['sp_currency'],
        sp_price = double.parse(json['sp_price'].toString()),
        sp_discount = json['sp_discount'],
        sp_discountedPrice =
            double.parse(json['sp_discountedPrice'].toString());

  Map<String, dynamic> toJson() => {
        'SP_ID': SP_ID,
        'sp_name': sp_name,
        'sp_description': sp_description,
        'sp_duration': sp_duration,
        'sp_durationin': sp_durationin,
        'sp_currency': sp_currency,
        'sp_price': sp_price,
        'sp_discount': sp_discount,
        'sp_discountedPrice': sp_discountedPrice
      };
}

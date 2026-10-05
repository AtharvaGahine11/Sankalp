class SubscriptionPlanModel {
  final String id;
  final String name;
  final String tag;
  final int price;
  final int originalPrice;
  final String billingPeriod;
  final List<String> features;
  final bool isBestValue;
  final bool isCurrentPlan;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.price,
    required this.originalPrice,
    required this.billingPeriod,
    required this.features,
    this.isBestValue = false,
    this.isCurrentPlan = false,
  });
}

class OrderModel {
  final String orderId;
  final String itemName;
  final String itemType; // 'plus_subscription', 'course', 'test_series'
  final int amount;
  final int discount;
  final int gst;
  final int totalAmount;
  final String paymentMethod;
  final DateTime orderDate;
  final String status;

  const OrderModel({
    required this.orderId,
    required this.itemName,
    required this.itemType,
    required this.amount,
    required this.discount,
    required this.gst,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderDate,
    this.status = 'Success',
  });
}

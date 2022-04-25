class Orders {
  final String? id;
  final String? status;
  final String? date_created;
  final String? total;
  final String? customer_id;
  final String? payment_method;
  final String? transaction_id;
  final String? date_paid;
  final String? date_completed;
  final List<dynamic>? billing;
  final List<dynamic>? line_items;

  Orders({
    this.id,
    this.status,
    this.date_created,
    this.total,
    this.customer_id,
    this.payment_method,
    this.transaction_id,
    this.date_paid,
    this.date_completed,
    this.billing,
    this.line_items,
  });
}

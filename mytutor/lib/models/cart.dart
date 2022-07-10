class Cart {
  String? cartId;
  String? subjectName;
  String? cartQty;
  String? subjectId;
  String? totalprice;

  Cart(
      {this.cartId,
      this.subjectName,
      this.cartQty,
      this.subjectId,
      this.totalprice});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    subjectName = json['subject_name'];
    cartQty = json['cart_qty'];
    subjectId = json['subject_id'];
    totalprice = json['totalprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['subject_name'] = subjectName;
    data['cart_qty'] = cartQty;
    data['subject_id'] = subjectId;
    data['totalprice'] = totalprice;
    return data;
  }
}

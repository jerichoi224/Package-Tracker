enum ShippingStatusEnum {
  gettingInfo("Getting Info"),
  inProgress("In Progress"),
  delivered("Delivered"),
  error("Error");

  const ShippingStatusEnum(this.caption);
  final String caption;
}
enum ServiceEnum {
  dhl("DHL", "de.dhl"),
  sagawa("Sagawa", "jp.sagawa"),
  kuronekoyamato("Kuroneko Yamato", "jp.yamato"),
  japanpost("Japan Post", "jp.yuubin"),
  chunilps("천일택배", "kr.chunilps"),
  cjlogistics("CJ대한통운", "kr.cjlogistics"),
  cupost("CU 편의점 택배", "kr.cupost"),
  cvsnet("GS Postbox 택배", "kr.cvsnet"),
  cway("Woori Express", "kr.cway"),
  daesin("대신택배", "kr.daesin"),
  krpost("우체국 택배", "kr.epost"),
  hanips("한의사랑택배", "kr.hanips"),
  hanjin("한진택배", "kr.hanjin"),
  hdexp("합동택배", "kr.hdexp"),
  homepick("홈픽", "kr.homepick"),
  honamlogis("호서호남택배", "kr.honamlogis"),
  ilyanglogis("일양로지스", "kr.ilyanglogis"),
  kdexp("경동택배", "kr.kdexp"),
  kunyoung("건영택배", "kr.kunyoung"),
  logen("로젠택배", "kr.logen"),
  lotte("롯데택배", "kr.lotte"),
  slx("SLX", "kr.slx"),
  swgexp("성원글로벌카고", "kr.swgexp"),
  tnt("TNT", "nl.tnt"),
  ems("EMS", "un.upu.ems"),
  fedex("Fedex", "us.fedex"),
  ups("UPS", "us.ups"),
  usps("USPS", "us.usps");

  const ServiceEnum(this.displayName, this.carrierId);
  final String displayName, carrierId;
}
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  static const String _adRemoveProductId = 'remove_ads';
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isPremiumUser = false;
  late Stream<List<PurchaseDetails>> _purchaseUpdated;

  bool get isPremiumUser => _isPremiumUser;

  Future<void> initStoreInfo() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      print("⚠️ In-app purchases are not available.");
      return;
    }

    // 🔹 상품 정보 가져오기
    final ProductDetailsResponse response =
    await _iap.queryProductDetails({_adRemoveProductId});
    if (response.productDetails.isEmpty) {
      print("⚠️ Product details not found.");
      return;
    }

    // 🔹 과거 구매 내역 확인
    await _iap.restorePurchases();

    // 🔹 구매 상태 업데이트 리스너
    _purchaseUpdated = _iap.purchaseStream;
    _purchaseUpdated.listen((List<PurchaseDetails> purchases) {
      _handlePurchaseUpdate(purchases);
    });
  }

  Future<void> buyRemoveAds() async {
    final ProductDetailsResponse response =
    await _iap.queryProductDetails({_adRemoveProductId});

    if (response.productDetails.isNotEmpty) {
      final purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      print("⚠️ No product details available.");
    }
  }

  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        if (purchase.productID == _adRemoveProductId) {
          _isPremiumUser = true;
          print("✅ Premium user activated.");
        }
      } else if (purchase.status == PurchaseStatus.error) {
        print("❌ Purchase error: ${purchase.error}");
      }
    }
  }
}

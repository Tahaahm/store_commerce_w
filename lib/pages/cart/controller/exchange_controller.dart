import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';

class ExchangeRateController extends GetxController {
  static ExchangeRateController get instance => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxDouble iqdAmount = RxDouble(0.0);
  RxBool isLoading = RxBool(false); // Add isLoading state

  @override
  void onInit() {
    super.onInit();
    fetchIqdAmount();
  }

  Future<void> fetchIqdAmount() async {
    try {
      isLoading.value = true; // Set isLoading to true when fetching
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('exchange').doc('exchange_rates').get();
      if (snapshot.exists) {
        double amount = snapshot.data()?['iqd_amount'] ?? 0.0;
        iqdAmount.value = amount;
        // Update total amount after fetching IQD amount
        CartController.instance.updateTotalAmount();
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching iqd_amount: $e');
    } finally {
      isLoading.value = false; // Set isLoading to false after fetching
    }
  }
}

// ignore_for_file: prefer_const_constructors, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:store_commerce_shop/data/api/pdf_api.dart';
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/pages/cart/controller/cart_controller.dart';
import 'package:store_commerce_shop/pages/main_page/naviagte_menu.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/sizes.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';
import 'package:store_commerce_shop/util/helpers/helper_functions.dart';
import 'package:store_commerce_shop/util/newtork_manager/network_manager.dart';
import 'package:store_commerce_shop/util/popups/full_screen_loaders.dart';
import 'package:store_commerce_shop/util/popups/loaders.dart';
import 'package:store_commerce_shop/util/validators/validation.dart';

class GeneratePdfPage extends StatelessWidget {
  const GeneratePdfPage({
    Key? key,
    required this.items,
    required this.totalPrice,
    required this.discount,
  }) : super(key: key);

  final List<CartModel> items;
  final double totalPrice;
  final int discount;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final keyForm = GlobalKey<FormState>();
    final dliveryTime = TextEditingController();
    bool stockUpdateSuccess =
        true; // Variable to track the success of stock update

    String invoiceNumber = ''; // Variable to store the generated invoice number

    return Scaffold(
      appBar: AppBar(
        title: Text('Generate'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.offAll(() => NavigationMenu()),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Dimentions.height32,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      TImage.pdfGenerator,
                      height: Dimentions.pageView200,
                      width: Dimentions.pageView200,
                    ),
                    const Text(
                      "Generate Invoice",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Dimentions.height15,
                    ),
                    Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          SizedBox(
                            width: Dimentions.pageView400,
                            child: TextFormField(
                              controller: nameController,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                "Name",
                                value,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.people),
                                labelText: TText.name,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: TSize.spaceBtwInputField,
                          ),
                          SizedBox(
                            width: Dimentions.pageView400,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: phoneController,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                "Phone",
                                value,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.call),
                                labelText: TText.phone,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: TSize.spaceBtwInputField,
                          ),
                          SizedBox(
                            width: Dimentions.pageView400,
                            child: TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.location),
                                labelText: "Address",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 15),
                                  child: Text(
                                    "(Optional)",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: TSize.spaceBtwInputField,
                          ),
                          SizedBox(
                            width: Dimentions.pageView400,
                            child: TextFormField(
                              controller: dliveryTime,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.timer_1),
                                labelText: "Delivery Time",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 15),
                                  child: Text(
                                    "(Optional)",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: TSize.spaceBtwInputField,
                    ),
                    SizedBox(
                      width: Dimentions.pageView400,
                      child: ElevatedButton(
                        onPressed: () async {
                          final cartController = CartController.instance;
                          final isConnected =
                              await NetworkManager.instance.isConnected();
                          if (!isConnected) {
                            TLoaders.errorSnackBar(
                              title: "Internet",
                              message:
                                  "No Connection. Please connect to the internet and try again.",
                            );
                            return;
                          }

                          // if (keyForm.currentState!.validate()) {
                          try {
                            final cartItems = List<CartModel>.from(items);

                            // Step 1: Update the stock
                            // TFullScreenLoader.openLoadingDialog(
                            //   "Updating stock...",
                            //   TImage.processing,
                            // );
                            // for (var item in items) {
                            //   await cartController.decrementProductStock(
                            //     item.product!,
                            //     item.quantity!,
                            //   );
                            //   if (!stockUpdateSuccess) {
                            //     break;
                            //   }
                            // }
                            // TFullScreenLoader.stopLoading();

                            // Step 2: Generate PDF and add to cart history
                            // if (stockUpdateSuccess) {
                            TFullScreenLoader.openLoadingDialog(
                              "Loading Pdf...",
                              TImage.processing,
                            );

                            // Generate invoice number
                            invoiceNumber = await generateQuotationCode();

                            await PdfApi.openGeneratedInvoice(
                              cartItems,
                              totalPrice,
                              discount,
                              nameController.text,
                              phoneController.text,
                              addressController.text,
                              dliveryTime.text,
                              invoiceNumber,
                            );

                            // await CartRepo().addToCartHistory(
                            //   cartItems,
                            //   DateTime.now(),
                            // ); // Update favorite products before clearing the cart

                            // Future.delayed(Duration(milliseconds: 1500),
                            //     () {
                            //   cartController.clearCart();
                            // });
                            // }
                          } catch (e) {
                            TFullScreenLoader.stopLoading();
                            TLoaders.errorSnackBar(
                              title: "Error generating and opening invoice",
                              message: e.toString(),
                            );
                            if (!stockUpdateSuccess) {
                              TFullScreenLoader.openLoadingDialog(
                                "Rolling back stock...",
                                TImage.processing,
                              );
                              for (var item in items) {
                                await cartController.decrementProductStock(
                                  item.product!,
                                  item.quantity!,
                                );
                              }
                              TFullScreenLoader.stopLoading();
                            }
                          } finally {
                            // if (stockUpdateSuccess) {
                            //   Future.delayed(Duration(seconds: 2), () {
                            //     Get.offAll(() => NavigationMenu());
                            //   });
                            // }
                          }
                          // }
                        },
                        child: const Text("Generate"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Future<String> generateQuotationCode() async {
    try {
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('quotation').doc('number');

      final String quotationCode =
          await FirebaseFirestore.instance.runTransaction(
        (Transaction transaction) async {
          // Check if the document exists, if not, create it
          final DocumentSnapshot<Map<String, dynamic>> snapshot =
              await transaction.get(docRef)
                  as DocumentSnapshot<Map<String, dynamic>>;

          if (!snapshot.exists) {
            // Create the document with initial value
            transaction.set(docRef, {'number': 0});
            return 'SN0';
          }

          // Get the current quotation number and increment it
          int currentNumber = snapshot.data()!['number'];
          final int newNumber = currentNumber + 1;

          // Update the document with the new number
          transaction.update(docRef, {'number': newNumber});

          return 'SN$newNumber';
        },
      );

      return quotationCode;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Error", message: "Error generating quotation code: $e");
      return ''; // Handle error accordingly
    }
  }
}

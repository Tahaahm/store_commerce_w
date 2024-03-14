// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print, unnecessary_string_interpolations, unused_local_variable, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:store_commerce_shop/models/cart_model/cart_model.dart';
import 'package:store_commerce_shop/models/products/product_model.dart';
import 'package:store_commerce_shop/util/constants/image_string.dart';
import 'package:store_commerce_shop/util/constants/text_strings.dart';
import 'package:store_commerce_shop/util/dimention/dimention.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      print("Error opening file: $e");
    }
  }

  static Future<File> generateInvoice(
      List<CartModel> items,
      double totalPrice,
      int discount,
      String name,
      String phone,
      String address,
      String selectedDate,
      String invoiceNumber) async {
    final String quotationCode = invoiceNumber;
    // Load image from asset and convert to bytes
    Future<Uint8List> loadImageFromAsset(String assetPath) async {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    }

    final pdf = pw.Document();

    final regularFontData =
        await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/OpenSans-Bold.ttf');
    final italicFontData =
        await rootBundle.load('assets/fonts/OpenSans-Italic.ttf');
    final boldItalicFontData =
        await rootBundle.load('assets/fonts/OpenSans-BoldItalic.ttf');
    final arabicFontData =
        await rootBundle.load('assets/fonts/Droid Arabic Naskh Regular.ttf');
    final arabicFont = pw.Font.ttf(arabicFontData);

// Convert font data to Uint8List
    final regularFontUint8List = regularFontData.buffer.asUint8List();
    final boldFontUint8List = boldFontData.buffer.asUint8List();
    final italicFontUint8List = italicFontData.buffer.asUint8List();
    final boldItalicFontUint8List = boldItalicFontData.buffer.asUint8List();

// Define fonts
    final regularFont = pw.Font.ttf(regularFontUint8List.buffer.asByteData());
    final boldFont = pw.Font.ttf(boldFontUint8List.buffer.asByteData());
    final italicFont = pw.Font.ttf(italicFontUint8List.buffer.asByteData());
    final boldItalicFont =
        pw.Font.ttf(boldItalicFontUint8List.buffer.asByteData());
    final Uint8List logoBytes = await loadImageFromAsset(TImage.logo);
    final Uint8List logoBytes1 = await loadImageFromAsset(TImage.logo1);
    final Uint8List logoBytes2 = await loadImageFromAsset(TImage.logo2);
    final Uint8List logoBytes3 = await loadImageFromAsset(TImage.logo3);
    final Uint8List logoBytes4 = await loadImageFromAsset(TImage.logo4);
    final Uint8List logoBytes5 = await loadImageFromAsset(TImage.logo5);
    final Uint8List logoByte6 = await loadImageFromAsset(TImage.logo6);
    final Uint8List logoByte7 = await loadImageFromAsset(TImage.logo7);

    final headers = [
      '',
      'Description',
      'IMG',
      "Made In",
      "Code",
      'Q',
      'Price',
      "Total"
    ];

    final totalAfterDiscount =
        totalPrice - (totalPrice * (discount / 100)).round().toDouble();

    final tableData =
        await Future.wait(items.asMap().entries.map((entry) async {
      final index =
          entry.key + 1; // Adding 1 to the index to start counting from 1
      final item = entry.value;

      final imageBytes = await downloadImage(item.img!);
      final descriptionLines = item.product!.description;

      final dimension =
          '${item.product!.height} X ${item.product!.width} X ${item.product!.depth}';
      final currencySymbol = item.product!.currency == 'USD'
          ? '\$'
          : 'IQD'; // Determine currency symbol
      final totalPrice = (item.price! * item.quantity!)
          .toStringAsFixed(2); // Calculate total price for the product

      // Check if descriptionLines is empty
      final descriptionCell = descriptionLines.isNotEmpty
          ? pw.Container(
              width: 160,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children: [
                    pw.Text("- "),
                    pw.Text(item.name!,
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                  ]),
                  for (var line in descriptionLines)
                    line.isNotEmpty
                        ? pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                                pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.SizedBox(
                                        width:
                                            5), // Adjust the width as needed for spacing
                                    pw.Text(
                                      "-",
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                    pw.Expanded(
                                      child: pw.Text(
                                        line,
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                          fontSize: 8,
                                          lineSpacing:
                                              0.8, // Adjust the lineHeight to reduce spacing
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                        : pw.Text("- Empty"),
                  pw.Row(
                    children: [
                      if (item.product!.height != 0 ||
                          item.product!.width != 0 ||
                          item.product!.depth != 0)
                        pw.Text("-"),
                      if (item.product!.height != 0 ||
                          item.product!.width != 0 ||
                          item.product!.depth != 0)
                        pw.Text(dimension, style: pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text("-"),
                      pw.Text(item.product!.weight.toString() + "KG",
                          style: pw.TextStyle(fontSize: 8)),
                      pw.SizedBox(width: 15),
                      item.product!.power != 0 ? pw.Text("-") : pw.SizedBox(),
                      item.product!.power != 0
                          ? pw.Text(item.product!.power.toString() + "KW",
                              style: pw.TextStyle(fontSize: 8))
                          : pw.SizedBox(),
                      pw.SizedBox(width: 15),
                      item.product!.volume != 0 ? pw.Text("-") : pw.SizedBox(),
                      item.product!.volume != 0
                          ? pw.Text(item.product!.volume.toString() + "L",
                              style: pw.TextStyle(fontSize: 8))
                          : pw.SizedBox(),
                    ],
                  ),
                ],
              ),
            )
          : pw.Text('Empty');

      return [
        '$index', // Use index as the first element
        descriptionCell,
        pw.Container(
          width: 50,
          height: 50,
          child: pw.Image(pw.MemoryImage(imageBytes)),
        ),
        pw.Container(
          width: 50,
          child: pw.Text(item.product!.brand, style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Container(
          width: 50,
          child:
              pw.Text(item.product!.material, style: pw.TextStyle(fontSize: 8)),
        ),
        item.quantity,
        pw.Container(
          width: 45,
          child: pw.Text('$currencySymbol${item.price}',
              style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Container(
          width: 45,
          child: pw.Text('$currencySymbol$totalPrice',
              style: pw.TextStyle(fontSize: 8)), // Add the total price cell
        ),
      ];
    }));

    final totalNumber = items
        .map((item) => item.quantity)
        .reduce((a, b) => (a ?? 0) + (b ?? 0));
    final totalWeight = items.fold<double>(
        0,
        (previousValue, item) =>
            previousValue + calculateWeight(item.product!));
    final totalVolume = items.fold<double>(
        0,
        (previousValue, item) =>
            previousValue + calculateVolume(item.product!));

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 15.0,
            marginRight: 15.0,
            marginTop: 15.0,
            marginBottom: 0.0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: regularFont,
            bold: boldFont,
            italic: italicFont,
            boldItalic: boldItalicFont,
          ),
          header: (pw.Context context) {
            if (context.pageNumber == 1) {
              return pw.Column(children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Image(
                            pw.MemoryImage(logoBytes),
                            height: 220,
                            width: 250,
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 20),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(height: 10),
                                pw.Text(
                                  TText.headerPDF,
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 9,
                                    color: PdfColor.fromInt(0xff2f5597),
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Row(children: [
                                  pw.Text(
                                    "Address ",
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    TText.addressPDF,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff2f5597),
                                    ),
                                  ),
                                ]),
                                pw.SizedBox(height: 2),
                                pw.Row(children: [
                                  pw.Text(
                                    "Phone ",
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    TText.addressPDF2,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff2f5597),
                                    ),
                                  ),
                                ]),
                                pw.SizedBox(height: 4),
                                pw.Row(children: [
                                  pw.Text(
                                    "Email ",
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    TText.emailaddress1,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff2f5597),
                                    ),
                                  ),
                                ]),
                                pw.SizedBox(height: 4),
                                pw.Row(children: [
                                  pw.Text(
                                    "Email ",
                                    style: pw.TextStyle(
                                        fontSize: 7,
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.Text(
                                    TText.emailaddress2,
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff2f5597),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: Dimentions.height30),
                          pw.Row(children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Name/',
                                style: pw.TextStyle(
                                  fontSize: 7,
                                  color: PdfColor.fromInt(0xff203764),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              'لاسم',
                              textAlign: pw.TextAlign.right,
                              textDirection: pw.TextDirection
                                  .rtl, // Set text direction to right-to-left for Arabic
                              style: pw.TextStyle(
                                fontSize: 7,
                                color: PdfColor.fromInt(0xff203764),
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont, // Use the Arabic font
                              ),
                            ),
                            pw.SizedBox(width: 2),
                            pw.Text(' $name',
                                style: pw.TextStyle(
                                  fontSize: 7,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.black,
                                ),
                                maxLines: 4),
                          ]),
                          pw.Padding(
                            padding: pw.EdgeInsets.symmetric(horizontal: 15),
                            child: pw.Divider(
                              color: PdfColor.fromInt(0xff5b9bd5),
                            ),
                          ),
                          pw.Row(children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.only(left: 20),
                              child: pw.Text(
                                'Phone/',
                                style: pw.TextStyle(
                                  fontSize: 7,
                                  color: PdfColor.fromInt(0xff203764),
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              'الهاتف',
                              textAlign: pw.TextAlign.right,
                              textDirection: pw.TextDirection
                                  .rtl, // Set text direction to right-to-left for Arabic
                              style: pw.TextStyle(
                                fontSize: 7,
                                color: PdfColor.fromInt(0xff203764),
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont, // Use the Arabic font
                              ),
                            ),
                            pw.SizedBox(width: 2),
                            pw.Text(
                              ' $phone',
                              style: pw.TextStyle(
                                fontSize: 7,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                          pw.Padding(
                            padding: pw.EdgeInsets.symmetric(horizontal: 15),
                            child: pw.Divider(
                              color: PdfColor.fromInt(0xff5b9bd5),
                            ),
                          ),
                          pw.Center(
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                pw.Text(
                                  'TO/',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xff203764),
                                  ),
                                ),
                                pw.Text(
                                  'الى',
                                  textAlign: pw.TextAlign.right,
                                  textDirection: pw.TextDirection
                                      .rtl, // Set text direction to right-to-left for Arabic
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColor.fromInt(0xff203764),
                                    fontWeight: pw.FontWeight.bold,
                                    font: arabicFont, // Use the Arabic font
                                  ),
                                ),
                              ])),
                          pw.Padding(
                            padding: pw.EdgeInsets.symmetric(horizontal: 45),
                            child: pw.Divider(
                              color: PdfColor.fromInt(0xff5b9bd5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(height: Dimentions.height30),
                              pw.Row(children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 20),
                                  child: pw.Text(
                                    'Address/',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff203764),
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  'ألعنوان',
                                  textAlign: pw.TextAlign.right,
                                  textDirection: pw.TextDirection
                                      .rtl, // Set text direction to right-to-left for Arabic
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColor.fromInt(0xff203764),
                                    fontWeight: pw.FontWeight.bold,
                                    font: arabicFont, // Use the Arabic font
                                  ),
                                ),
                                pw.SizedBox(width: 2),
                                address.isNotEmpty
                                    ? pw.Text(
                                        ' $address',
                                        style: pw.TextStyle(
                                          fontSize: 7,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      )
                                    : pw.Text(""),
                              ]),
                              pw.Padding(
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 15),
                                child: pw.Divider(
                                  color: PdfColor.fromInt(0xff5b9bd5),
                                ),
                              ),
                              pw.Row(children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 20),
                                  child: pw.Text(
                                    'Q. No/',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff203764),
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  'رقم العرض',
                                  textAlign: pw.TextAlign.right,
                                  textDirection: pw.TextDirection
                                      .rtl, // Set text direction to right-to-left for Arabic
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColor.fromInt(0xff203764),
                                    fontWeight: pw.FontWeight.bold,
                                    font: arabicFont, // Use the Arabic font
                                  ),
                                ),
                                pw.SizedBox(width: 2),
                                pw.Text(
                                  ' $quotationCode',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ]),
                              pw.Padding(
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 15),
                                child: pw.Divider(
                                  color: PdfColor.fromInt(0xff5b9bd5),
                                ),
                              ),
                              pw.Row(children: [
                                pw.Padding(
                                  padding: pw.EdgeInsets.only(left: 20),
                                  child: pw.Text(
                                    'Date/',
                                    style: pw.TextStyle(
                                      fontSize: 7,
                                      color: PdfColor.fromInt(0xff203764),
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  'التاریخ',
                                  textAlign: pw.TextAlign.right,
                                  textDirection: pw.TextDirection
                                      .rtl, // Set text direction to right-to-left for Arabic
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColor.fromInt(0xff203764),
                                    fontWeight: pw.FontWeight.bold,
                                    font: arabicFont, // Use the Arabic font
                                  ),
                                ),
                                pw.SizedBox(width: 2),
                                pw.Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now()),
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.black,
                                  ),
                                ),
                              ]),
                              pw.Padding(
                                padding:
                                    pw.EdgeInsets.symmetric(horizontal: 15),
                                child: pw.Divider(
                                  color: PdfColor.fromInt(0xff5b9bd5),
                                ),
                              ),
                            ])),
                  ],
                ),
                pw.Container(
                    width: double.maxFinite,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            "PRICE OFFER",
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                              color: PdfColor.fromInt(0xff2f5597),
                            ),
                          ),
                          pw.SizedBox(width: 150),
                        ]))
              ]);
            } else {
              return pw.SizedBox();
            }
          },
          build: (pw.Context context) {
            int currentPageNumber = 0;
            final isLastPage = currentPageNumber == context.pagesCount;
            return [
              pw.SizedBox(height: Dimentions.height15),
              pw.Table.fromTextArray(
                headers: headers,
                data: tableData,
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(),
                headerDecoration:
                    pw.BoxDecoration(color: PdfColor.fromInt(0xffddebf7)),
                cellDecoration: (rowIndex, columnIndex, cellData) {
                  // Define background color based on row and column index
                  if (rowIndex == 0) {
                    return pw.BoxDecoration(
                        color: PdfColor.fromInt(0xffddebf7));
                  } else {
                    return pw.BoxDecoration();
                  }
                },
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: []),
                    pw.Column(children: [
                      pw.Container(
                          width: 180,
                          height: 18,
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Row(children: [
                            pw.Container(
                              alignment: pw.Alignment.center,
                              height: 18,
                              width: 100,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  width: 1,
                                  color: PdfColors.black,
                                ),
                              ),
                              child: pw.Text(
                                "Total Price",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Container(
                                alignment: pw.Alignment.center,
                                height: 18,
                                width: 80,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                    width: 1,
                                    color: PdfColors.black,
                                  ),
                                ),
                                child: pw.Text(
                                    "\$${totalPrice.round().toDouble()}",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )))
                          ])),
                      if (discount > 0)
                        pw.Container(
                            width: 180,
                            height: 18,
                            color: PdfColor.fromInt(0xfff3dcce),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Row(children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                height: 18,
                                width: 100,
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                    width: 1,
                                    color: PdfColors.black,
                                  ),
                                ),
                                child: pw.Text(
                                  "Discount",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Container(
                                  alignment: pw.Alignment.center,
                                  height: 18,
                                  width: 80,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      width: 1,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  child: pw.Text("$discount%OFF",
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                      )))
                            ])),
                      pw.Container(
                          width: 180,
                          height: 18,
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Row(children: [
                            pw.Container(
                              alignment: pw.Alignment.center,
                              height: 18,
                              width: 100,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  width: 1,
                                  color: PdfColors.black,
                                ),
                              ),
                              child: pw.Text(
                                "Sub Total",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.center,
                              height: 18,
                              width: 80,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  width: 1,
                                  color: PdfColors.black,
                                ),
                              ),
                              child: pw.Text(
                                "\$${totalAfterDiscount.round()}",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            )
                          ])),
                      pw.SizedBox(
                        height: 12,
                      ),
                      pw.Container(
                          width: 180,
                          height: 65,
                          alignment: pw.Alignment.center,
                          child: pw.Column(children: [
                            pw.Row(children: [
                              pw.Text("QTY/ "),
                              pw.Text(
                                "$totalNumber",
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text("Delivery Time "),
                              selectedDate.isNotEmpty
                                  ? pw.Text(
                                      "$selectedDate",
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                    )
                                  : pw.Row(
                                      children: List.generate(
                                          12,
                                          (index) => pw.Text(".",
                                              style: pw.TextStyle(
                                                  color: PdfColors.grey)))),
                            ]),
                          ]))
                    ])
                  ]),
              pw.SizedBox(height: 12),
            ];
          },
          footer: (pw.Context context) {
            final isLastPage = context.pageNumber == context.pagesCount;
            if (isLastPage) {
              return pw.Container(
                  height: 35,
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 5.0),
                  child: pw.Column(children: [
                    pw.Divider(
                      color: PdfColors.black,
                      height: 5,
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Column(
                            children: [
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Image(
                                      pw.MemoryImage(logoBytes1),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoBytes2),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoBytes3),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoBytes4),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoBytes5),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoByte6),
                                      height: 25,
                                      width: 65,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Image(
                                      pw.MemoryImage(logoByte7),
                                      height: 25,
                                      width: 65,
                                    ),
                                  ]),
                            ],
                          ),
                        ])
                  ]));
            } else {
              return pw.SizedBox(); // Return an empty container for other pages
            }
          }),
    );

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> openGeneratedInvoice(
      List<CartModel> items,
      double totalPrice,
      int discount,
      String name,
      String phone,
      String address,
      String selectedDate,
      String invoiceNumber) async {
    try {
      final File pdfFile = await generateInvoice(items, totalPrice, discount,
          name, phone, address, selectedDate, invoiceNumber);
      await OpenFile.open(pdfFile.path);
    } catch (e) {
      print('Error generating and opening invoice: $e');
    }
  }

  static Future<Uint8List> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image');
    }
  }

  String calculateDiscountedTotal(int selectedDiscount, double totalNumber) {
    double originalTotal = totalNumber;
    double discountPercentage = (100 - selectedDiscount) / 100;
    double discountedTotal = originalTotal * discountPercentage;
    return discountedTotal.toStringAsFixed(2);
  }

  static double calculateWeight(ProductModel product) {
    return product.weight;
  }

  static double calculateVolume(ProductModel product) {
    return product.volume;
  }
}

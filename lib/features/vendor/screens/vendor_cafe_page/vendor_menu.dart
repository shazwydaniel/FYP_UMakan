import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_add_adverts.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/cafe_details/edit_cafe.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/menu_item/add_menu_item.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/menu_item/edit_menu_item.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class VendorMenu extends StatefulWidget {
  final Rx<CafeDetails> cafe;

  VendorMenu({Key? key, required this.cafe}) : super(key: key);

  @override
  _VendorMenuState createState() => _VendorMenuState();
}

class _VendorMenuState extends State<VendorMenu> {
  final VendorMenuController controller = Get.put(VendorMenuController());

  @override
  void initState() {
    super.initState();

    controller.fetchItemsForCafe(
        VendorController.instance.getCurrentUserId(), widget.cafe.value.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.mustard,
      ),
      backgroundColor: TColors.mustard,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      widget.cafe.value.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Ensure long names don't overflow
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditCafeDetailsPage(
                            cafe: widget.cafe, // Pass the selected cafe
                            onSave: () {
                              // Fetch updated data from VendorsHome after editing
                              setState(() {
                                VendorController.instance.fetchCafesForVendor(
                                  VendorController.instance.currentUserId,
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 2.0, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(15), // Same radius as ClipRRect
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: widget.cafe.value.image != null &&
                          widget.cafe.value.image.isNotEmpty
                      ? Image.network(
                          widget.cafe.value.image,
                          width: double.infinity,
                          height: 160, // Adjust the height
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            height: 200,
                            child: Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.photo,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 15, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 4, // Thin vertical line width
                      height: 40, // Adjust the height as needed
                      color: TColors.amber,
                    ),
                    const SizedBox(
                        width: 10), // Space between the line and text

                    Text(
                      'Menu Items',
                      style: TextStyle(
                        fontSize: 16, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.375,
                child: Obx(() {
                  if (controller.items.isEmpty) {
                    return const Center(child: Text('No items available.'));
                  } else {
                    return ListView.builder(
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) {
                        final item = controller.items[index];

                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMenuItemPage(
                                    menuItem: item,
                                    cafeId: widget.cafe.value.id,
                                  ),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  // Refresh the list after editing
                                  controller.fetchItemsForCafe(
                                      VendorController.instance
                                          .getCurrentUserId(),
                                      widget.cafe.value.id);
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 190,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: TColors.amber,
                                margin: const EdgeInsets.only(bottom: 30.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Text Details on the Left
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.itemName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: TColors.textLight,
                                              ),
                                            ),
                                            Text(
                                              'Cost: RM${item.itemPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: TColors.textLight,
                                              ),
                                            ),
                                            Text(
                                              'Calories: ${item.itemCalories} cal',
                                              style: const TextStyle(
                                                color: TColors.textLight,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: item.isAvailable
                                                    ? const Color.fromARGB(
                                                        255, 52, 204, 128)
                                                    : TColors.textGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: TColors.textLight,
                                                ),
                                              ),
                                              child: Text(
                                                item.isAvailable
                                                    ? 'Available'
                                                    : 'Unavailable',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                if (item.isSpicy)
                                                  Container(
                                                    width: 24, // Circle size
                                                    height: 24,
                                                    margin: EdgeInsets.only(
                                                        right:
                                                            6), // Spacing between circles
                                                    decoration: BoxDecoration(
                                                      color: const Color
                                                          .fromARGB(
                                                          255,
                                                          255,
                                                          134,
                                                          6), // Circle color for Spicy
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width:
                                                              2), // White border
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'S',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .black, // Text color
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            12, // Font size
                                                      ),
                                                    ),
                                                  ),
                                                if (item.isVegetarian)
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    margin: EdgeInsets.only(
                                                        right: 6),
                                                    decoration: BoxDecoration(
                                                      color: const Color
                                                          .fromARGB(
                                                          255,
                                                          70,
                                                          215,
                                                          75), // Circle color for Vegetarian
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'V',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                if (item.isLowSugar)
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    margin: EdgeInsets.only(
                                                        right: 6),
                                                    decoration: BoxDecoration(
                                                      color: TColors
                                                          .blush, // Circle color for Low Sugar
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'LS',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            10, // Slightly smaller for "LS"
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Circular Image on the Right
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          color: Colors.grey[300],
                                        ),
                                        child: item.itemImage.isNotEmpty &&
                                                item.itemImage !=
                                                    "default_image_url"
                                            ? ClipOval(
                                                child: Image.network(
                                                  item.itemImage,
                                                  fit: BoxFit.cover,
                                                  width: 80,
                                                  height: 80,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: Icon(
                                                  Icons.fastfood,
                                                  size: 40,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
                  }
                }),
              ),

              // Add Menu Item button
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Black border color
                    width: 2.0, // Border width
                  ),
                  borderRadius:
                      BorderRadius.circular(15), // Match button's border radius
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddMenuItemPage(cafeId: widget.cafe.value.id),
                      ),
                    );
                    if (result == true) {
                      controller.fetchItemsForCafe(
                          VendorController.instance.getCurrentUserId(),
                          widget.cafe.value.id);
                    }
                  },
                  child: const Text('Add Menu Item'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: TColors.textDark,
                    backgroundColor: TColors.cream,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              // Add Advertisement button
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VendorAdverts(cafeId: widget.cafe.value.id),
                      ),
                    );
                  },
                  child: const Text('Add Advertisement'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: TColors.amber,
                    side: BorderSide(
                        color: Colors.black, // Border color of the button
                        width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

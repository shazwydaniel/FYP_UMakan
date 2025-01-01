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
                              height: 120,
                              child: Card(
                                color: TColors.amber,
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: TColors.textLight,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\RM${item.itemPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: TColors.textLight,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${item.itemCalories} kcal',
                                              style: const TextStyle(
                                                color: TColors.textLight,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Circular Image on the Right
                                      ClipOval(
                                        child: item.itemImage != null &&
                                                item.itemImage.isNotEmpty
                                            ? Image.network(
                                                item.itemImage,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(
                                                  Icons.broken_image,
                                                  size: 80,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : Icon(
                                                Icons.fastfood,
                                                size: 80,
                                                color: Colors.grey,
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

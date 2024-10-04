import 'package:buisness/components/dashboard_drawer.dart';
import 'package:buisness/components/pages_buttons.dart';
import 'package:buisness/pages/employees_page.dart';
import 'package:buisness/pages/inventory_page.dart';
import 'package:buisness/pages/sales_page.dart';
import 'package:buisness/services/inventory_service.dart';
import 'package:buisness/services/sales_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

const storage = FlutterSecureStorage();

class Dashboard extends StatefulWidget {
  final Map<String, dynamic> business; // Add this line to hold the business ID

  const Dashboard({super.key, required this.business});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final SalesSpreadsheetService _salesSpreadsheetService;
  late final InventorySpreadsheetService _inventorySpreadsheetService;

  @override
  void initState() {
    super.initState();
    _salesSpreadsheetService = SalesSpreadsheetService();
    _inventorySpreadsheetService = InventorySpreadsheetService();

    // Call the function to create the business sheet if it doesn't exist
    _createBusinessSheet();
  }

  Future<void> _createBusinessSheet() async {
    String businessId = widget.business['_id']; // Assuming 'id' is the key for business ID
    try {
      await _salesSpreadsheetService.createSalesSheetIfNotExists(businessId);
      await _inventorySpreadsheetService.createInventorySheetIfNotExists(businessId);
    } catch (e) {
      // Handle any errors that may occur
      print('Error creating business sheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: DashboardDrawer(business: widget.business,),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PagesButtons(
                  name: "Employees",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeesPage(
                          business: widget.business, // Assuming 'id' is the key for business ID
                        ),
                      ),
                    );
                  },
                ),
                PagesButtons(
                  name: "Inventory",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryPage(
                          business: widget.business, // Assuming 'id' is the key for business ID
                        ),
                      ),
                    ); 
                  },
                ),
                PagesButtons(
                  name: "Sales",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesPage(
                          business: widget.business, // Assuming 'id' is the key for business ID
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

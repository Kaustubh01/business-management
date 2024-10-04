import 'package:buisness/services/inventory_service.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  final Map<String, dynamic> business; 
  const InventoryPage({super.key, required this.business});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final InventorySpreadsheetService _spreadsheetService = InventorySpreadsheetService();

  // Fetch the data from the spreadsheet service
  Future<List<Map<String, String>>> _fetchInventoryData() {
    return _spreadsheetService.getInventoryData(widget.business['_id']);
  }

  // Create the inventory sheet if it does not exist


  @override
  void initState() {
    super.initState();
  }

// Function to show the dialog for adding a new product
void _showAddProductDialog() {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price (USD)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Get the values from the text controllers
              final String model = modelController.text;
              final String brand = brandController.text;
              final String price = priceController.text;
              final String quantity = quantityController.text;

              // Prepare item data with model, brand, price, and quantity
              Map<String, String> itemData = {
                'Product Name': model,
                'Brand': brand,
                'Unit Price (USD)': price,
                'Quantity': quantity,
              };

              // Add the new product
              await _spreadsheetService.addInventoryItem(widget.business['_id'], itemData);

              // Close the dialog
              Navigator.of(context).pop();
              setState(() {}); // Refresh the UI
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _fetchInventoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found')); // No data state
          }

          // Data is available
          final inventoryData = snapshot.data!;

          return ListView.builder(
            itemCount: inventoryData.length,
            itemBuilder: (context, index) {
              final product = inventoryData[index];
              return Card(
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.all(10.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['Product Name'] ?? 'Unknown Model',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Brand: ${product['Brand'] ?? 'Unknown Brand'}'),
                      Text('Price: \$${product['Unit Price (USD)'] ?? 'N/A'}'),
                      Text('Quantity: ${product['Quantity'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: _showAddProductDialog,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
